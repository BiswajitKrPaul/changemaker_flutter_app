import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingItemFirst extends ConsumerStatefulWidget {
  const OnboardingItemFirst({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingItemFirstState();
}

class _OnboardingItemFirstState extends ConsumerState<OnboardingItemFirst> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xff078B98),
      child: Column(
        children: [
          const Gap(kToolbarHeight + 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              t.onboarding.title.t1,
              style: GoogleFonts.dmSans(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: const Color(0xffFEBC2F),
                letterSpacing: -2.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                ref.read(assetsProvider).logo,
              ),
            ),
          ),
          const Gap(16),
          Flexible(
            child: Text(
              t.onboarding.desc.d1,
              style: GoogleFonts.dmSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(16),
        ],
      ),
    ).animate().fade(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
      delay: const Duration(milliseconds: 300),
    );
  }
}
