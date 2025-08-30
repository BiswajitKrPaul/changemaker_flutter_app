import 'package:auto_route/annotations.dart';
import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/features/onboarding/providers/onboarding_page_provider.dart';
import 'package:changemaker_flutter_app/features/onboarding/widgets/onboarding_item.dart';
import 'package:changemaker_flutter_app/utils/color_utils.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();

  final bgColors = <Color>[
    const Color(0xff6390a8),
    const Color(0xffd2a166),
    const Color(0xff83ac76),
    const Color(0xff88fcf9),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: 4,
              padEnds: false,
              onPageChanged: (value) {
                ref
                    .read(onboardingPageProvider.notifier)
                    .setPage(value.toDouble());
              },
              itemBuilder: (context, index) {
                return OnboardingItem(
                  index: index,
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    DotsIndicator(
                      position: ref.watch(onboardingPageProvider),
                      dotsCount: 4,
                      animate: true,
                      decorator: DotsDecorator(
                        activeColor: Colors.black,
                        color: Colors.white,
                        size: const Size.square(8),
                        spacing: const EdgeInsets.all(2),
                        activeSize: const Size(24, 8),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      shape: const CircleBorder(),
                      foregroundColor: Colors.white,
                      backgroundColor: ref
                          .read(colorProvider)
                          .filledButtonColor,
                      elevation: 0,
                      onPressed: () {
                        if (ref.watch(onboardingPageProvider).toInt() > 2) {
                          ref.read(routeProvider).replaceAll([
                            const HomePageRoute(),
                          ]);
                        } else {
                          _pageController.animateToPage(
                            ref.read(onboardingPageProvider).toInt() + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: ref.watch(onboardingPageProvider).toInt() > 2
                          ? const Icon(FontAwesomeIcons.check)
                          : const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
