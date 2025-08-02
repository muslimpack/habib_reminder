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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    Image.asset("assets/icons/icon.png"),
                    Text(kAppNameAr),
                  ],
                ),
              ),
            if (PlatformExtension.isDesktop)
              Expanded(
                child: DragToMoveArea(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            "assets/icons/icon.png",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Text(kAppNameAr),
                      ],
                    ),
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
