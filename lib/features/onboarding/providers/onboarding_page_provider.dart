import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingNotifier extends Notifier<double> {
  @override
  double build() {
    return 0;
  }

  void setPage(double page) => state = page;
}

final NotifierProvider<OnboardingNotifier, double> onboardingPageProvider =
    NotifierProvider.autoDispose<OnboardingNotifier, double>(
      OnboardingNotifier.new,
    );
