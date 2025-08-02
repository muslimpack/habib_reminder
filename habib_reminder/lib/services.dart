import 'package:flutter/material.dart';
import 'package:habib_reminder/src/core/constants/const.dart';
import 'package:habib_reminder/src/core/di/dependency_injection.dart'
    as service_locator;
import 'package:habib_reminder/src/core/extension/extension_platform.dart';
import 'package:habib_reminder/src/core/services/system_tray_service.dart';
import 'package:habib_reminder/src/core/widgets/error_screen.dart';
import 'package:habib_reminder/src/features/desktop_ui/data/repository/desktop_repo.dart';
import 'package:window_manager/window_manager.dart';

import 'src/core/di/dependency_injection.dart';

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) =>
      ErrorScreen(details: details);
  await service_locator.initSL();

  await initWindowsManager();
  await initSystemTray();
}

Future initWindowsManager() async {
  if (!PlatformExtension.isDesktop) return;

  await windowManager.ensureInitialized();

  final WindowOptions windowOptions = WindowOptions(
    size: sl<DesktopRepo>().desktopWindowSize,
    center: true,
    fullScreen: false,
    title: kAppNameAr,
    titleBarStyle: TitleBarStyle.hidden,
    maximumSize: sl<DesktopRepo>().desktopWindowSize,
    minimumSize: sl<DesktopRepo>().desktopWindowSize,
    windowButtonVisibility: false,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setResizable(false);
  });
}

Future initSystemTray() async {
  final systemTrayService = sl<SystemTrayService>();
  await systemTrayService.initSystemTray();
}
