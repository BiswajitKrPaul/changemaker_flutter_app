import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSelectedTopic extends ConsumerWidget {
  const ProfileSelectedTopic({super.key});

  final List<String> topics = const [
    'Physical Well-being',
    'Nutrition and Fitness',
    'Improving Sleep Quality',
    'Chronic Pain',
    'Mental Health',
    'Burnout',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ), // border around the text field
        borderRadius: BorderRadius.circular(8), // rounded corners
      ),
      child: Column(
        children: topics.map((topic) {
          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Text(
                      '•',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF024B3A),
                      ),
                    ),
                  ),

                  /// Topic Text
                  Expanded(
                    child: Text(
                      topic,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF024B3A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  /// Right Check Icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3D8BFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
