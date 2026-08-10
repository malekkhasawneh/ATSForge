import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppInsets {
  static EdgeInsets get page =>
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h);
  static EdgeInsets get card =>
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h);
  static EdgeInsets get compact =>
      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h);
}
