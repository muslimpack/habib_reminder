import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habib_reminder/src/core/constants/const.dart';
import 'package:habib_reminder/src/core/di/dependency_injection.dart';
import 'package:habib_reminder/src/core/extension/extension_platform.dart';
import 'package:habib_reminder/src/core/utils/app_print.dart';
import 'package:habib_reminder/src/features/home/presentation/controller/cubit/habib_cubit.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class SystemTrayService {
  static const String _appName = kAppNameAr;
  static final String _trayIconPath = Platform.isWindows
      ? 'assets/icons/icon.ico'
      : 'assets/icons/icon.png';

  final SystemTray _systemTray = SystemTray();
  final Menu _menuMain = Menu();

  Future<void> initSystemTray() async {
    if (!PlatformExtension.isDesktop) return;
    try {
      await _systemTray.initSystemTray(iconPath: _trayIconPath);
      _systemTray.setTitle(_appName);
      _systemTray.setToolTip(_appName);

      _systemTray.registerSystemTrayEventHandler((eventName) {
        if (eventName == kSystemTrayEventClick) {
          Platform.isWindows
              ? windowManager.show()
              : _systemTray.popUpContextMenu();
        } else if (eventName == kSystemTrayEventRightClick) {
          Platform.isWindows
              ? _systemTray.popUpContextMenu()
              : windowManager.show();
        }
      });

      await _menuMain.buildFrom([
        MenuItemLabel(
          label: 'اظهار/إخفاء النافذة',
          onClicked: (m) => _toggleWindow(),
        ),
        MenuItemLabel(
          label: 'تشغيل التذكير',
          onClicked: (m) => _startReminder(),
        ),
        MenuItemLabel(
          label: 'إيقاف التذكير',
          onClicked: (m) => _stopReminder(),
        ),
        MenuSeparator(),
        MenuItemLabel(label: 'الخروج', onClicked: (m) => _exitApp()),
      ]);

      _systemTray.setContextMenu(_menuMain);
    } catch (e) {
      appPrint('Failed to initialize system tray: $e');
    }
  }

  void _toggleWindow() async {
    try {
      final isVisible = await windowManager.isVisible();
      if (isVisible) {
        await windowManager.hide();
      } else {
        await windowManager.show();
        await windowManager.focus();
      }
    } catch (e) {
      debugPrint('Failed to toggle window: $e');
    }
  }

  void _startReminder() async {
    try {
      final habibCubit = sl<HabibCubit>();
      await habibCubit.startReminder();
    } catch (e) {
      debugPrint('Failed to start reminder: $e');
    }
  }

  void _stopReminder() async {
    try {
      final habibCubit = sl<HabibCubit>();
      await habibCubit.stopReminder();
    } catch (e) {
      debugPrint('Failed to stop reminder: $e');
    }
  }

  void _exitApp() {
    exit(0);
  }

  void dispose() {
    _systemTray.destroy();
  }
}
