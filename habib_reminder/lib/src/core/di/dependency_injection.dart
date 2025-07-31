import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:habib_reminder/src/core/constants/const.dart';
import 'package:habib_reminder/src/features/desktop_ui/data/repository/desktop_repo.dart';
import 'package:habib_reminder/src/features/home/data/repository/settings_repo.dart';
import 'package:habib_reminder/src/features/home/presentation/controller/cubit/habib_cubit.dart';

final sl = GetIt.instance;

Future<void> initSL() async {
  ///MARK: Init storages
  sl.registerLazySingleton(() => GetStorage(kGetStorageName));
  sl.registerLazySingleton(() => DesktopRepo(sl()));
  sl.registerLazySingleton(() => SettingsRepo(sl()));

  ///MARK: Init Repo

  ///MARK: Init Manager;

  ///MARK: Init BLOC

  /// Singleton BLoC
  sl.registerLazySingleton(() => HabibCubit(sl()));

  /// Factory BLoC
}
