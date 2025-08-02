import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:habib_reminder/src/core/constants/const.dart';
import 'package:habib_reminder/src/core/extension/extension_datetime.dart';
import 'package:habib_reminder/src/core/utils/app_print.dart';
import 'package:habib_reminder/src/core/utils/open_url.dart';
import 'package:path_provider/path_provider.dart';

class ErrorScreen extends StatelessWidget {
  final FlutterErrorDetails details;
  const ErrorScreen({super.key, required this.details});

  Future<void> emailTheError(
    BuildContext context,
    FlutterErrorDetails error,
  ) async {
    // get receiver
    const String emailReceiver = kOrgEmail;
    try {
      final String fullErrorDetails = generateErrorReport(error);

      final String errorReportFilePath = await writeToTextFile(
        fullErrorDetails,
      );
      final Email email = Email(
        body: 'حدث خطأ غير متوقع أثناء استخدام التطبيق.',
        subject: 'تذكرة المحب | خلل في الأداء | $kAppVersion',
        recipients: [emailReceiver],
        attachmentPaths: [errorReportFilePath],
      );
      await FlutterEmailSender.send(email);
    } catch (e) {
      appPrint(e.toString());
      openURL('mailto:$emailReceiver');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ أثناء إرسال البريد"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String generateErrorReport(FlutterErrorDetails error) {
    final lineBreaker = '\n${'-' * 40}\n';
    final StringBuffer buffer = StringBuffer();

    ///
    buffer.writeln(DateTime.now().humanize);
    buffer.writeln(lineBreaker);

    ///
    buffer.writeln('App Version: $kAppVersion');
    buffer.writeln('Operating System: ${Platform.operatingSystem}');
    buffer.writeln(lineBreaker);

    ///
    buffer.writeln('The exception was:\n');
    buffer.writeln(error.exception);
    buffer.writeln(lineBreaker);

    ///
    buffer.writeln('Stack Trace:\n');
    buffer.writeln(error.stack);

    return buffer.toString();
  }

  Future<String> writeToTextFile(String text) async {
    final Directory directory = await getTemporaryDirectory();
    final File file = File('${directory.path}/HabibReminderErrorReport.txt');
    await file.writeAsString(text);
    return file.path;
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم النسخ إلى الحافظة"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = details.exceptionAsString();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 80),
              Text(
                "حدث خطاء غير متوقع",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => emailTheError(context, details),
                      icon: const Icon(Icons.email),
                      label: Text("أرسل بريدا"),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _copyToClipboard(context, errorMessage),
                    icon: const Icon(Icons.copy),
                    label: Text("نسخ"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
