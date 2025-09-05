import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingItemFourth extends ConsumerStatefulWidget {
  const OnboardingItemFourth({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingItemFourthState();
}

class _OnboardingItemFourthState extends ConsumerState<OnboardingItemFourth> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xffBAF3EE),
      child: Column(
        children: [
          const Gap(kToolbarHeight + 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              t.onboarding.title.t4,
              style: GoogleFonts.dmSans(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: const Color(0xff625B71),
                letterSpacing: -2.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            child: SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(
                  ref.read(assetsProvider).logo,
                ),
              ),
            ),
          ),
          const Gap(16),
          Text(
            t.onboarding.desc.d4.d41,
            style: GoogleFonts.dmSans(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: const Color(0xff0088FF),
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          Text(
            t.onboarding.desc.d4.d42,
            style: GoogleFonts.dmSans(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: const Color(0xff625B71),
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          Text(
            t.onboarding.desc.d4.d43,
            style: GoogleFonts.dmSans(
              fontSize: 33,
              fontWeight: FontWeight.w700,
              color: const Color(0xff0088FF),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            t.onboarding.desc.d4.d44,
            style: GoogleFonts.dmSans(
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: const Color(0xff0088FF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fade(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
      delay: const Duration(milliseconds: 300),
    );
  }
}
