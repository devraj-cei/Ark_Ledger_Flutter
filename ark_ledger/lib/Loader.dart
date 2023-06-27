import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

method_loading() async {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 5.h
    ..radius = 1.h
    ..progressColor = const Color(0xFFfbd71c)
    ..backgroundColor = Colors.white
    ..indicatorColor = const Color(0xFFfbd71c)
    ..contentPadding = EdgeInsets.all(3.h)
    ..textColor=Colors.black
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true;
}