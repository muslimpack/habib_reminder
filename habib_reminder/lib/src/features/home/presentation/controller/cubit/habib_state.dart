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
  final int timeRemainingInSeconds;
  final bool launchAtStartup;
  final bool launchMinimized;
  const HabibLoadedState({
    required this.audioList,
    required this.globalVolume,
    required this.audioIntervalInMinutes,
    required this.isRunning,
    this.timeRemainingInSeconds = 0,
    required this.launchAtStartup,
    required this.launchMinimized,
  });

  Color get timeRemainingInSecondsColor {
    if (timeRemainingInSeconds > 10) {
      return Colors.green;
    } else if (timeRemainingInSeconds > 5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  List<Object> get props => [
    isRunning,
    audioList,
    globalVolume,
    audioIntervalInMinutes,
    timeRemainingInSeconds,
    launchAtStartup,
    launchMinimized,
  ];

  HabibLoadedState copyWith({
    List<AudioModel>? audioList,
    double? globalVolume,
    int? audioIntervalInMinutes,
    bool? isRunning,
    int? timeRemainingInSeconds,
    bool? launchAtStartup,
    bool? launchMinimized,
  }) {
    return HabibLoadedState(
      audioList: audioList ?? this.audioList,
      globalVolume: globalVolume ?? this.globalVolume,
      audioIntervalInMinutes:
          audioIntervalInMinutes ?? this.audioIntervalInMinutes,
      isRunning: isRunning ?? this.isRunning,
      timeRemainingInSeconds:
          timeRemainingInSeconds ?? this.timeRemainingInSeconds,
      launchAtStartup: launchAtStartup ?? this.launchAtStartup,
      launchMinimized: launchMinimized ?? this.launchMinimized,
    );
  }
}
