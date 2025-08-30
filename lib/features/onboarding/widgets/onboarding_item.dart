import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/assets_utils.dart';
import 'package:changemaker_flutter_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class OnboardingItem extends ConsumerWidget {
  const OnboardingItem({required this.index, super.key});

  final int index;

  static const _bgColors = <Color>[
    Color(0xff6390a8),
    Color(0xffd2a166),
    Color(0xff83ac76),
    Color(0xff88fcf9),
  ];

  static const List<Color> _titleColor = [
    Color(0xffd2a166),
    Color(0xff83ac76),
    Colors.white,
    Colors.black,
  ];

  static const List<Color> _descColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titles = <String>[
      t.onboarding.title.t1,
      t.onboarding.title.t2,
      t.onboarding.title.t3,
      t.onboarding.title.t4,
    ];

    final descs = <String>[
      t.onboarding.desc.d1,
      t.onboarding.desc.d2,
      t.onboarding.desc.d3,
      t.onboarding.desc.d4,
    ];
    return ColoredBox(
      color: _bgColors[index],
      child: Column(
        children: [
          const Gap(kToolbarHeight + 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              titles[index],
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _titleColor[index],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Image.asset(
                ref.read(assetsProvider).logo,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                descs[index],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: _descColor[index],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Gap(16),
          Visibility(
            visible: index == 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                t.onboarding.d5,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                  color: ref.read(colorProvider).filledButtonColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
