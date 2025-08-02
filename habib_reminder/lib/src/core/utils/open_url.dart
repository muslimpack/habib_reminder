import 'package:url_launcher/url_launcher.dart';

Future<void> openURL(String url) async {
  final parsed = Uri.parse(url);
  try {
    if (await canLaunchUrl(parsed)) {
      await launchUrl(
        parsed,
        mode: LaunchMode.externalApplication,
      );
    }
  } catch (_) {}
}
