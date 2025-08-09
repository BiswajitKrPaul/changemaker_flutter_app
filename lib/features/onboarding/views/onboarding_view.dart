import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

@RoutePage()
class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
        swipeableBody: const [],
      ),
    );
  }
}
