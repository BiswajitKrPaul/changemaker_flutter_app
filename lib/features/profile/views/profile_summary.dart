import 'package:changemaker_flutter_app/features/auth/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ProfileSummary extends ConsumerStatefulWidget {
  const ProfileSummary({super.key});

  @override
  _ProfileSummaryState createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends ConsumerState<ProfileSummary> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileItems = ref.watch(profileStateNotifierProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        spacing: 16,
        children: List.generate(profileItems.summaryItems.length, (index) {
          final item = profileItems.summaryItems[index];

          // Initialize controller if not already
          _controllers.putIfAbsent(
            index,
            () => TextEditingController(text: item.value),
          );

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
              ), // border around the text field
              borderRadius: BorderRadius.circular(8), // rounded corners
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 160, // fixed width for all titles
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF024B3A),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: TextField(
                    controller: _controllers[index],
                    decoration: const InputDecoration(
                      hintText: 'Enter value',
                      border: InputBorder.none, // No border
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.zero, // Optional: remove extra padding
                    ),
                    onChanged: (newValue) {
                      ref
                          .read(profileStateNotifierProvider.notifier)
                          .updateValue(index, newValue);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(profileStateNotifierProvider.notifier)
                        .toggleCheck(index);
                  },
                  child: Icon(
                    item.isChecked ? Icons.check_circle : Icons.circle_outlined,
                    color: item.isChecked ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
