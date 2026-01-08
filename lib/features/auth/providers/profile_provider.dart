import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:changemaker_flutter_app/features/models/topics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_provider.freezed.dart';

enum ProfileStage {
  userSummary('userSummary'),
  userTopics('userTopics'),
  userSelectedTopic('userSelectedTopic'),
  shareDetails('shareDetails');

  const ProfileStage(this.label);
  final String label;
}

class ProfileItem {
  const ProfileItem({
    required this.title,
    required this.value,
    required this.isChecked,
  });
  final String title;
  final String value;
  final bool isChecked;

  ProfileItem copyWith({
    String? title,
    String? value,
    bool? isChecked,
  }) {
    return ProfileItem(
      title: title ?? this.title,
      value: value ?? this.value,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileStage.userSummary) ProfileStage profileTitle,
    @Default([
      ProfileItem(title: 'Alter', value: '', isChecked: false),
      ProfileItem(
        title: 'Place of residence',
        value: '',
        isChecked: false,
      ),
      ProfileItem(title: 'Profession', value: '', isChecked: false),
      ProfileItem(title: 'User since', value: '', isChecked: false),
      ProfileItem(title: 'Gender', value: '', isChecked: false),
    ])
    List<ProfileItem> summaryItems,
    @Default(null) Topics? userTopics,
  }) = _ProfileState;
}

class ProfileStateNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  void updateProfileTitle(ProfileStage title) {
    state = state.copyWith(profileTitle: title);
  }

  void updateValue(int index, String newValue) {
    final updatedItems = [
      for (int i = 0; i < state.summaryItems.length; i++)
        i == index
            ? state.summaryItems[i].copyWith(value: newValue)
            : state.summaryItems[i],
    ];

    state = state.copyWith(summaryItems: updatedItems);
  }

  void toggleCheck(int index) {
    final updated = [
      for (int i = 0; i < state.summaryItems.length; i++)
        i == index
            ? state.summaryItems[i].copyWith(
                isChecked: !state.summaryItems[i].isChecked,
              )
            : state.summaryItems[i],
    ];

    state = state.copyWith(summaryItems: updated);
  }

  Future<void> getUserDetails(String uid) async {
    print('Fetching user details for UID: $uid');

    final querySnapshot = await ref
        .read(userCollectionProvider)
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data =
          (querySnapshot.docs.first.data() ?? {}) as Map<String, dynamic>;

      print('User data: $data');

      // 🔥 Mapping UI titles → Firestore keys (all lowercase)
      final titleKeyMap = <String, String>{
        'alter': 'age',
        'place of residence': 'placeofresidence',
        'profession': 'profession',
        'user since': 'usersince',
        'gender': 'gender',
      };

      state = state.copyWith(
        summaryItems: state.summaryItems.map((item) {
          final title = item.title.toLowerCase();

          // mapping UI title → firestore field
          final titleKeyMap = <String, String>{
            'alter': 'age',
            'place of residence': 'placeofresidence',
            'profession': 'profession',
            'user since': 'usersince',
            'gender': 'gender',
          };

          // find firestore key
          final firestoreKey = titleKeyMap[title];

          // No match → return original
          if (firestoreKey == null) return item;

          // read from firestore
          final newValue = data[firestoreKey]?.toString();

          print('MATCHED → $title -> $firestoreKey -> $newValue');

          return item.copyWith(
            value: newValue ?? item.value,
          );
        }).toList(),
      );
    } else {
      print('No user found with UID: $uid');
    }
  }

  Future<void> fetchUserTopics() async {
    final db = ref.read(firebaseDatabaseProvider);

    final snapshot = await db.ref('/').get();

    if (!snapshot.exists) {
      print('No topics found');
      return;
    }

    final raw = snapshot.value;

    if (raw is! Map) {
      print('Invalid format');
      return;
    }

    // 🔥 Convert Map<Object?, Object?> → Map<String, dynamic>
    final jsonMap = raw.map(
      (key, value) => MapEntry(
        key.toString(),
        _convertValue(value),
      ),
    );

    // Now parse into Topics model safely
    final topics = Topics.fromJson(jsonMap);

    state = state.copyWith(userTopics: topics);
    print('Topics parsed successfully: $topics');
  }

  dynamic _convertValue(dynamic value) {
    if (value is Map) {
      return value.map(
        (k, v) => MapEntry(k.toString(), _convertValue(v)),
      );
    }
    if (value is List) {
      return value.map(_convertValue).toList();
    }
    return value;
  }
}

final profileStateNotifierProvider =
    NotifierProvider<ProfileStateNotifier, ProfileState>(
      ProfileStateNotifier.new,
    );
