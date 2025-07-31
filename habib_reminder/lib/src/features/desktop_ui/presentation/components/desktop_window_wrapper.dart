// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:habib_reminder/src/core/di/dependency_injection.dart';
import 'package:habib_reminder/src/features/desktop_ui/data/repository/desktop_repo.dart';
import 'package:habib_reminder/src/features/desktop_ui/presentation/components/desktop_app_bar.dart';
import 'package:window_manager/window_manager.dart';

class DesktopWindowWrapper extends StatefulWidget {
  final Widget? child;
  const DesktopWindowWrapper({super.key, this.child});

  @override
  State<DesktopWindowWrapper> createState() => _DesktopWindowWrapperState();
}

class _DesktopWindowWrapperState extends State<DesktopWindowWrapper>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() {
    super.onWindowResize();
    sl<DesktopRepo>().changeDesktopWindowSize(MediaQuery.of(context).size);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Column(
          children: [
            const DesktopAppBar(),
            Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: widget.child ?? const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
