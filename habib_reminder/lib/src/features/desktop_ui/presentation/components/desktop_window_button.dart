import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DesktopWindowButtons extends StatelessWidget {
  const DesktopWindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: Theme.of(context).brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
