import 'package:auto_route/annotations.dart';
import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/features/onboarding/providers/onboarding_page_provider.dart';
import 'package:changemaker_flutter_app/features/onboarding/widgets/onboarding_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onboarding/onboarding.dart';

@RoutePage()
class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Onboarding(
          swipeableBody: const [
            OnboardingItem(),
            OnboardingItem(),
            OnboardingItem(),
          ],
          onPageChanges:
              (netDragDistance, pagesLength, currentIndex, slideDirection) =>
                  ref
                      .read(onboardingPageProvider.notifier)
                      .setPage(currentIndex),
          buildFooter:
              (
                context,
                netDragDistance,
                pagesLength,
                currentIndex,
                setIndex,
                slideDirection,
              ) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 36,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Indicator(
                        painter: CirclePainter(
                          netDragPercent: netDragDistance,
                          pagesLength: pagesLength,
                          currentPageIndex: ref.watch(onboardingPageProvider),
                          slideDirection: slideDirection,
                          radius: 6,
                          space: 12,
                          activePainter: Paint()
                            ..color = Colors.green
                            ..strokeCap = StrokeCap.round
                            ..strokeWidth = 1,
                          inactivePainter: Paint()
                            ..color = Colors.green
                            ..strokeCap = StrokeCap.round
                            ..strokeWidth = 1
                            ..style = PaintingStyle.stroke,
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 48,
                        margin: const EdgeInsets.all(
                          kFloatingActionButtonMargin,
                        ),
                      ),
                      if (currentIndex == pagesLength - 1)
                        FloatingActionButton(
                          shape: const CircleBorder(),
                          elevation: 1,
                          onPressed: () {
                            if (currentIndex == pagesLength - 1) {
                              ref.read(routeProvider).replaceAll([
                                const HomePageRoute(),
                              ]);
                            } else {
                              setIndex(currentIndex + 1);
                            }
                          },
                          child: currentIndex != pagesLength - 1
                              ? const Icon(Icons.arrow_forward)
                              : const Icon(Icons.check),
                        ),
                    ],
                  ),
                );
              },
        ),
      ),
    );
  }
}
