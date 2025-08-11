import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetsUtils {
  String get logo => 'assets/logo/changemaker_logo.png';
  String get landingPageBackground => 'assets/image/backgroundimage.png';
  String get tempImg => 'assets/image/tempImg.png';
}

final assetsProvider = Provider<AssetsUtils>((ref) {
  return AssetsUtils();
});
