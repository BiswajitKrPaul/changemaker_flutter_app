import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setPage(int page) => state = page;
}

final onboardingPageProvider = NotifierProvider<OnboardingNotifier, int>(
  OnboardingNotifier.new,
);
