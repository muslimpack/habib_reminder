import 'package:get_storage/get_storage.dart';
import 'package:habib_reminder/src/features/home/data/models/audio_model.dart';

class SettingsRepo {
  final GetStorage box;

  SettingsRepo(this.box);

  // Keys for storing data
  static const String _globalVolumeKey = 'global_volume';
  static const String _audioIntervalInMinutesKey = 'audio_interval_in_minutes';
  static const String _isRunningKey = 'is_running';
  static const String _audioListKey = 'audio_list';
  static const String _launchMinimizedKey = 'launch_minimized';

  // Save global volume
  Future<void> saveGlobalVolume(double volume) async {
    await box.write(_globalVolumeKey, volume);
  }

  // Load global volume
  double loadGlobalVolume() {
    return box.read(_globalVolumeKey) ?? 0.5;
  }

  // Save audio interval in minutes
  Future<void> saveAudioIntervalInMinutes(int interval) async {
    await box.write(_audioIntervalInMinutesKey, interval);
  }

  // Load audio interval in minutes
  int loadAudioIntervalInMinutes() {
    return box.read(_audioIntervalInMinutesKey) ?? 1;
  }

  // Save running state
  Future<void> saveIsRunning(bool isRunning) async {
    await box.write(_isRunningKey, isRunning);
  }

  // Load running state
  bool loadIsRunning() {
    return box.read(_isRunningKey) ?? true;
  }

  // Save audio list
  Future<void> saveAudioList(List<AudioModel> audioList) async {
    final audioListData = audioList.map((audio) => audio.toMap()).toList();
    await box.write(_audioListKey, audioListData);
  }

  // Load audio list
  List<AudioModel>? loadAudioList() {
    final audioListData = box.read(_audioListKey) as List<dynamic>?;
    if (audioListData == null) return null;

    return audioListData
        .map((data) => AudioModel.fromMap(data as Map<String, dynamic>))
        .toList();
  }

  // Save launch minimized state
  Future<void> saveLaunchMinimized(bool isRunning) async {
    await box.write(_launchMinimizedKey, isRunning);
  }

  // Load launch minimized state

  bool loadILaunchMinimized() {
    return box.read(_launchMinimizedKey) ?? false;
  }
}
