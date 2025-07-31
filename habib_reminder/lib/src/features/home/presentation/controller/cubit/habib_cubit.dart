import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habib_reminder/src/features/home/data/data_source/audio_dummy_list.dart';
import 'package:habib_reminder/src/features/home/data/models/audio_model.dart';

part 'habib_state.dart';

class HabibCubit extends Cubit<HabibState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer previewAudioPlayer = AudioPlayer();
  Timer? timer;
  Timer? countdownTimer;
  HabibCubit() : super(HabibLoadingState());

  Future<void> start() async {
    emit(HabibLoadingState());

    final audioList = audioDummyList;

    /// get random audio

    final double volume = 1;
    final int audioIntervalInMinutes = 1;

    emit(
      HabibLoadedState(
        audioList: audioList,
        globalVolume: volume,
        audioIntervalInMinutes: audioIntervalInMinutes,
        isRunning: true,
        timeRemainingInSeconds: audioIntervalInMinutes * 60,
      ),
    );

    play();
  }

  Future<void> changeVolume(double volume) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    await audioPlayer.setVolume(volume);
    emit(state.copyWith(globalVolume: volume));
  }

  Future<void> play() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;

    final randomAudio = List.of(state.audioList.where((e) => e.play))
      ..shuffle();

    stopTimer();
    final currentAudio = randomAudio.firstOrNull;
    if (currentAudio != null) {
      await audioPlayer.play(
        AssetSource('sounds/${currentAudio.path}'),
        volume: state.globalVolume * currentAudio.volume,
      );
    }
    startTimer();
  }

  Future<void> playPreview({required AudioModel audio}) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;

    await previewAudioPlayer.play(
      AssetSource('sounds/${audio.path}'),
      volume: state.globalVolume * audio.volume,
    );
  }

  Future<void> stop() async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    await audioPlayer.stop();
    stopTimer();
    emit(state.copyWith(
      isRunning: false,
      timeRemainingInSeconds: 0,
    ));
  }

  void startTimer() {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    
    // Reset countdown to full interval
    final totalSeconds = state.audioIntervalInMinutes * 60;
    emit(state.copyWith(
      isRunning: true,
      timeRemainingInSeconds: totalSeconds,
    ));
    
    // Start the main timer
    timer = Timer.periodic(
      Duration(minutes: state.audioIntervalInMinutes),
      (timer) => play(),
    );
    
    // Start countdown timer
    startCountdownTimer();
  }

  void startCountdownTimer() {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final state = this.state;
        if (state is! HabibLoadedState) return;
        
        if (state.timeRemainingInSeconds > 0) {
          emit(state.copyWith(
            timeRemainingInSeconds: state.timeRemainingInSeconds - 1,
          ));
        } else {
          timer.cancel();
        }
      },
    );
  }

  void stopTimer() {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    timer?.cancel();
    timer = null;
    countdownTimer?.cancel();
    countdownTimer = null;
  }

  Future<void> changeInterval(int audioIntervalInMinutes) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    stopTimer();
    emit(state.copyWith(
      audioIntervalInMinutes: audioIntervalInMinutes,
      timeRemainingInSeconds: audioIntervalInMinutes * 60,
    ));
    startTimer();
  }

  Future<void> toggleAudio(AudioModel audio) async {
    final state = this.state;
    if (state is! HabibLoadedState) return;
    emit(
      state.copyWith(
        audioList: state.audioList
            .map((e) => e.id == audio.id ? e.copyWith(play: !e.play) : e)
            .toList(),
      ),
    );
  }

  String formatTimeRemaining(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
