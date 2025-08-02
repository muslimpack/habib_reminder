import 'package:habib_reminder/src/core/constants/const.dart';
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get humanize {
    return DateFormat(kDateTimeHumanFormat).format(this);
  }

  String get humanizeDateOnly {
    return DateFormat(kDateTimeDateOnlyHumanFormat).format(this);
  }

  DateTime get dateOnly {
    return DateTime(year, month, day);
  }
}
