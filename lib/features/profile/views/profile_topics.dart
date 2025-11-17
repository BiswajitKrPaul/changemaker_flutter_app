import 'package:changemaker_flutter_app/features/models/topics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changemaker_flutter_app/features/auth/providers/profile_provider.dart';

class ProfileTopics extends ConsumerStatefulWidget {
  const ProfileTopics({super.key});

  @override
  ConsumerState<ProfileTopics> createState() => _ProfileTopicsState();
}

class _ProfileTopicsState extends ConsumerState<ProfileTopics> {
  // Track selected subtopics
  final Map<String, Set<String>> selectedSubtopics = {};

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileStateNotifierProvider);
    final topics = profileState.userTopics;

    if (topics == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Convert t1…t12 → List<T1>
    final topicList = [
      topics.t1,
      topics.t2,
      topics.t3,
      topics.t4,
      topics.t5,
      topics.t6,
      topics.t7,
      topics.t8,
      topics.t9,
      topics.t10,
      topics.t11,
      topics.t12,
    ];

    // Initialize selection map once
    for (final t in topicList) {
      selectedSubtopics.putIfAbsent(t.title, () => {});
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: topicList.map((topic) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: Text(
              topic.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF024B3A),
              ),
            ),
            children: topic.child.map((c) {
              return ListTile(
                title: Text(c.title),
                trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedSubtopics[topic.title]!.contains(c.title)) {
                        selectedSubtopics[topic.title]!.remove(c.title);
                      } else {
                        selectedSubtopics[topic.title]!.add(c.title);
                      }
                    });
                  },
                  child: Icon(
                    selectedSubtopics[topic.title]!.contains(c.title)
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: selectedSubtopics[topic.title]!.contains(c.title)
                        ? Colors.blue
                        : Colors.grey,
                    size: 28,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
