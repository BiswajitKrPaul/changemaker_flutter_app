import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorUtils {
  Color get gradientStartColor => const Color(0xff47AFB9);
  Color get gradientMiddleColor => const Color(0xff5AD7BA);
  Color get gradientEndColor => const Color(0xffB2FFED);
  Color get filledButtonColor => const Color(0xff087DFF);
  Color get rejectedColor => const Color(0xffF55053);
}

final colorProvider = Provider<ColorUtils>((ref) {
  return ColorUtils();
});
