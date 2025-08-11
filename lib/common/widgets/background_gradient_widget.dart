import 'package:changemaker_flutter_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackgroundGradientWidget extends ConsumerWidget {
  const BackgroundGradientWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ref.read(colorProvider).gradientStartColor,
              ref.read(colorProvider).gradientMiddleColor,
              ref.read(colorProvider).gradientEndColor,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
