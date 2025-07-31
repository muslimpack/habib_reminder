import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habib_reminder/src/core/constants/const.dart';
import 'package:habib_reminder/src/core/extension/extension_platform.dart';
import 'package:habib_reminder/src/features/desktop_ui/presentation/components/desktop_window_button.dart';
import 'package:window_manager/window_manager.dart';

class DesktopAppBar extends StatefulWidget {
  final BuildContext? shellContext;

  const DesktopAppBar({super.key, this.shellContext});

  @override
  State<DesktopAppBar> createState() => _DesktopAppBarState();
}

class _DesktopAppBarState extends State<DesktopAppBar> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (kIsWeb)
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(kAppNameAr),
              ),
            if (PlatformExtension.isDesktop)
              const Expanded(
                child: DragToMoveArea(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(kAppNameAr),
                  ),
                ),
              ),

            if (!kIsWeb) const DesktopWindowButtons(),
          ],
        ),
      ),
    );
  }
}
