import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habib_reminder/src/features/home/data/data_source/audio_dummy_list.dart';
import 'package:habib_reminder/src/features/home/data/models/audio_model.dart';
import 'package:habib_reminder/src/features/home/data/repository/settings_repo.dart';

part 'habib_state.dart';

class HabibCubit extends Cubit<HabibState> {
  final SettingsRepo settingsRepo;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _previewAudioPlayer = AudioPlayer();
  Timer? _timer;
  Timer? _countdownTimer;

  HabibCubit(this.settingsRepo) : super(HabibLoadingState());

  Future<void> start() async {
    emit(HabibLoadingState());

    // Use saved audio list or default to dummy list
    final audioList = settingsRepo.loadAudioList() ?? audioDummyList;
    final double globalVolume = settingsRepo.loadGlobalVolume();
    final int audioIntervalInMinutes = settingsRepo
        .loadAudioIntervalInMinutes();
    final bool isRunning = settingsRepo.loadIsRunning();

    emit(
      HabibLoadedState(
        audioList: audioList,
        globalVolume: globalVolume,
        audioIntervalInMinutes: audioIntervalInMinutes,
        isRunning: isRunning,
        timeRemainingInSeconds: audioIntervalInMinutes * 60,
      ),
    );

    _play();
  }

  Future<void> changeGlobalVolume(double volume) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    await _audioPlayer.setVolume(volume);
    await settingsRepo.saveGlobalVolume(volume);
    emit(state.copyWith(globalVolume: volume));
  }

  Future<void> _play() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;

    final randomAudio = List.of(state.audioList.where((e) => e.play))
      ..shuffle();

    stopTimer();
    final currentAudio = randomAudio.firstOrNull;
    if (currentAudio != null) {
      await _audioPlayer.play(
        AssetSource('sounds/${currentAudio.path}'),
        volume: state.globalVolume * currentAudio.volume,
      );
    }
    _startTimer();
  }

  Future<void> playPreview({required AudioModel audio}) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;

    await _previewAudioPlayer.play(
      AssetSource('sounds/${audio.path}'),
      volume: state.globalVolume * audio.volume,
    );
  }

  Future<void> startReminder() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    await settingsRepo.saveIsRunning(true);
    emit(state.copyWith(isRunning: true));
    await _play();
  }

  Future<void> stopReminder() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    await _audioPlayer.stop();
    stopTimer();
    await settingsRepo.saveIsRunning(false);
    emit(state.copyWith(isRunning: false, timeRemainingInSeconds: 0));
  }

  void _startTimer() {
    final state = this.state;
    if (state is! HabibLoadedState) return;

    // Reset countdown to full interval
    final totalSeconds = state.audioIntervalInMinutes * 60;
    emit(state.copyWith(timeRemainingInSeconds: totalSeconds));

    // Start the main timer
    _timer = Timer.periodic(
      Duration(minutes: state.audioIntervalInMinutes),
      (timer) => _play(),
    );

    // Start countdown timer
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final state = this.state;
      if (state is! HabibLoadedState) return;

      if (state.timeRemainingInSeconds > 0) {
        emit(
          state.copyWith(
            timeRemainingInSeconds: state.timeRemainingInSeconds - 1,
          ),
        );
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    _timer?.cancel();
    _timer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  Future<void> changeInterval(int audioIntervalInMinutes) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    stopTimer();
    await settingsRepo.saveAudioIntervalInMinutes(audioIntervalInMinutes);
    emit(
      state.copyWith(
        audioIntervalInMinutes: audioIntervalInMinutes,
        timeRemainingInSeconds: audioIntervalInMinutes * 60,
      ),
    );
    _startTimer();
  }

  Future<void> toggleAudio(AudioModel audio) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    final newList = List.of(
      state.audioList,
    ).map((e) => e.id == audio.id ? e.copyWith(play: !e.play) : e).toList();
    await settingsRepo.saveAudioList(newList);
    emit(state.copyWith(audioList: newList));
  }

  String formatTimeRemaining(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
