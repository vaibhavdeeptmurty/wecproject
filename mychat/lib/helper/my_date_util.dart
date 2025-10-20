import 'package:flutter/material.dart';

class MyDateUtil {
  // FOR GETTING FORMATTED TIME FROM MILLISECOND SINCE EPOCHS
  static String getFormattedTime(BuildContext context, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}
