import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habib_reminder/src/core/di/dependency_injection.dart';
import 'package:habib_reminder/src/core/extension/extension_platform.dart';
import 'package:habib_reminder/src/features/home/presentation/controller/cubit/habib_cubit.dart';
import 'package:habib_reminder/src/features/home/presentation/screens/home_screen.dart';
import 'package:habib_reminder/src/features/desktop_ui/presentation/components/desktop_window_wrapper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HabibCubit>()..start(),
      child: MaterialApp(
        title: 'Habib Reminder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
        ),
        supportedLocales: [const Locale('ar')],
        locale: Locale("ar"),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          if (PlatformExtension.isDesktop) {
            return DesktopWindowWrapper(child: child);
          }
          return child ?? const SizedBox();
        },
        home: const HomeScreen(),
      ),
    );
  }
}
