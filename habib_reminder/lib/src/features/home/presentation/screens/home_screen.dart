import 'package:flutter/material.dart';
import 'package:habib_reminder/src/core/constants/const.dart';
import 'package:habib_reminder/src/core/extension/extension_platform.dart';
import 'package:habib_reminder/src/features/home/presentation/screens/about_us_view.dart';
import 'package:habib_reminder/src/features/home/presentation/screens/settings_view.dart';
import 'package:habib_reminder/src/features/home/presentation/screens/summary_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      controller: _tabController,
      tabs: [
        Tab(icon: Icon(Icons.dashboard_rounded)),
        Tab(icon: Icon(Icons.settings)),
        Tab(icon: Icon(Icons.info)),
      ],
    );
    return Scaffold(
      appBar: PlatformExtension.isDesktop
          ? null
          : AppBar(
              title: const Text(kAppNameAr),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/icons/icon.png"),
              ),

              bottom: tabBar,
            ),
      body: Column(
        children: [
          tabBar,
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [SummaryView(), SettingsView(), AboutUsView()],
            ),
          ),
        ],
      ),
    );
  }
}
