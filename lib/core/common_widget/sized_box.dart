import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizeBox on num {
  SizedBox get sbh => SizedBox(height: ScreenUtil().setHeight(toDouble()));
  SizedBox get sbw => SizedBox(width: ScreenUtil().setWidth(toDouble()));
  dynamic get font => ScreenUtil().setSp(toDouble());
}
