import 'package:flutter/material.dart';
import 'package:habib_reminder/src/core/constants/const.dart';
import 'package:habib_reminder/src/core/utils/open_url.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(15),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 15),
          ListTile(
            leading: Image.asset("assets/icons/icon.png"),
            title: Text("تطبيق تذكرة المحب $kAppVersion"),
            subtitle: const Text("تطبيق مجاني خالي من الإعلانات ومفتوح المصدر"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.handshake),
            title: Text("نسألكم الدعاء لنا ولوالدينا"),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: const Text("رابط المشروع المفتوح المصدر"),
            onTap: () {
              openURL("https://github.com/muslimpack/habib_reminder");
            },
          ),
        ],
      ),
    );
  }
}
