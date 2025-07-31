import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habib_reminder/src/features/home/data/data_source/audio_dummy_list.dart';
import 'package:habib_reminder/src/features/home/data/models/audio_model.dart';
import 'package:habib_reminder/src/features/home/data/repository/settings_repo.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';

part 'habib_state.dart';

class HabibCubit extends Cubit<HabibState> {
  final SettingsRepo settingsRepo;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _previewAudioPlayer = AudioPlayer();
  Timer? _timer;
  Timer? _countdownTimer;

  late final PackageInfo packageInfo;

  late final LaunchAtStartup launchOnStartup;

  HabibCubit(this.settingsRepo) : super(HabibLoadingState());

  Future<void> start() async {
    emit(HabibLoadingState());

    packageInfo = await PackageInfo.fromPlatform();
    launchOnStartup = launchAtStartup
      ..setup(
        appName: packageInfo.appName,
        appPath: Platform.resolvedExecutable,
        // Set packageName parameter to support MSIX.
        packageName: "com.hassaneltantawy.habib_reminder",
      );

    // Use saved audio list or default to dummy list
    final audioList = settingsRepo.loadAudioList() ?? audioDummyList;
    final double globalVolume = settingsRepo.loadGlobalVolume();
    final int audioIntervalInMinutes = settingsRepo
        .loadAudioIntervalInMinutes();
    final bool isRunning = settingsRepo.loadIsRunning();

    final isLaunchAtStartupEnabled = await launchOnStartup.isEnabled();
    final launchMinimized = settingsRepo.loadILaunchMinimized();

    if (launchMinimized) {
      await windowManager.hide();
    }

    emit(
      HabibLoadedState(
        audioList: audioList,
        globalVolume: globalVolume,
        audioIntervalInMinutes: audioIntervalInMinutes,
        isRunning: isRunning,
        timeRemainingInSeconds: audioIntervalInMinutes * 60,
        launchAtStartup: isLaunchAtStartupEnabled,
        launchMinimized: launchMinimized,
      ),
    );

    _play();
  }

  Future toggleLaunchAtStartup() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    final isLaunchAtStartupEnabled = await launchOnStartup.isEnabled();
    if (isLaunchAtStartupEnabled) {
      await launchOnStartup.disable();
    } else {
      await launchOnStartup.enable();
    }
    emit(state.copyWith(launchAtStartup: !isLaunchAtStartupEnabled));
  }

  Future toggleLaunchMinimized() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    await settingsRepo.saveLaunchMinimized(!state.launchMinimized);
    emit(state.copyWith(launchMinimized: !state.launchMinimized));
  }

  Future<void> changeGlobalVolume(double volume) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    await _audioPlayer.setVolume(volume);
    await settingsRepo.saveGlobalVolume(volume);
    emit(state.copyWith(globalVolume: volume));
  }

  Future<void> changeInterval(int audioIntervalInMinutes) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    _stopTimer();
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
    if (state.isRunning) return;
    await settingsRepo.saveIsRunning(true);
    emit(state.copyWith(isRunning: true));
    await _play();
  }

  Future<void> stopReminder() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    await _audioPlayer.stop();
    _stopTimer();
    await settingsRepo.saveIsRunning(false);
    emit(state.copyWith(isRunning: false, timeRemainingInSeconds: 0));
  }

  Future<void> _play() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;

    final randomAudio = List.of(state.audioList.where((e) => e.play))
      ..shuffle();

    _stopTimer();
    final currentAudio = randomAudio.firstOrNull;
    if (currentAudio != null) {
      await _audioPlayer.play(
        AssetSource('sounds/${currentAudio.path}'),
        volume: state.globalVolume * currentAudio.volume,
      );
    }
    _startTimer();
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

  void _stopTimer() {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    _timer?.cancel();
    _timer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  String formatTimeRemaining(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
