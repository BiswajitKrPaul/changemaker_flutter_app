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
