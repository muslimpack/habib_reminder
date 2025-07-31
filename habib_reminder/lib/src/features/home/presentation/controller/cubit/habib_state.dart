// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'habib_cubit.dart';

sealed class HabibState extends Equatable {
  const HabibState();

  @override
  List<Object> get props => [];
}

final class HabibLoadingState extends HabibState {}

class HabibLoadedState extends HabibState {
  final List<AudioModel> audioList;
  final double globalVolume;
  final int audioIntervalInMinutes;
  final bool isRunning;
  const HabibLoadedState({
    required this.audioList,
    required this.globalVolume,
    required this.audioIntervalInMinutes,
    required this.isRunning,
  });

  @override
  List<Object> get props => [
    isRunning,
    audioList,
    globalVolume,
    audioIntervalInMinutes,
  ];

  HabibLoadedState copyWith({
    List<AudioModel>? audioList,
    double? globalVolume,
    int? audioIntervalInMinutes,
    bool? isRunning,
  }) {
    return HabibLoadedState(
      audioList: audioList ?? this.audioList,
      globalVolume: globalVolume ?? this.globalVolume,
      audioIntervalInMinutes:
          audioIntervalInMinutes ?? this.audioIntervalInMinutes,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
