import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DesktopWindowButtons extends StatelessWidget {
  const DesktopWindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                windowManager.hide();
              },
              icon: Icon(Icons.hide_image_outlined),
            ),
            WindowCaptionButton.minimize(
              brightness: Theme.of(context).brightness,
              onPressed: () {
                windowManager.minimize();
              },
            ),
            WindowCaptionButton.close(
              brightness: Theme.of(context).brightness,
              onPressed: () {
                windowManager.close();
              },
            ),
          ],
        ),
      ),
    );
  }
}
