import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:habib_reminder/src/core/utils/app_print.dart';

class DesktopRepo {
  final GetStorage box;

  DesktopRepo(this.box);

  ///* ******* desktop Window Size ******* */
  static const String desktopWindowSizeKey = "desktopWindowSize";
  Size? get desktopWindowSize {
    const Size defaultSize = Size(480, 854);
    try {
      final data =
          jsonDecode(
                box.read<String?>(desktopWindowSizeKey) ??
                    '{"width":${defaultSize.width},"height":${defaultSize.height}}',
              )
              as Map<String, dynamic>;
      appPrint(data);

      final double width = (data['width'] as num).toDouble();
      final double height = (data['height'] as num).toDouble();

      return Size(width, height);
    } catch (e) {
      appPrint(e);
    }
    return defaultSize;
  }

  Future<void> changeDesktopWindowSize(Size value) {
    final screenSize = {'width': value.width, 'height': value.height};
    final String data = jsonEncode(screenSize);
    return box.write(desktopWindowSizeKey, data);
  }
}
