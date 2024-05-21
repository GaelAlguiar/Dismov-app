import 'package:flutter/material.dart';
import 'package:relative_time/relative_time.dart';

String getRelativeTime(context, int time) {
  return RelativeTime.locale(const Locale('es')).format(
    DateTime.fromMillisecondsSinceEpoch(time),
  );
}