import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/common/widgets/background_gradient_widget.dart';
import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:changemaker_flutter_app/features/auth/providers/auth_provider.dart';
import 'package:changemaker_flutter_app/features/auth/providers/profile_provider.dart';
import 'package:changemaker_flutter_app/features/profile/views/profile_selected_topic.dart';
import 'package:changemaker_flutter_app/features/profile/views/profile_summary.dart';
import 'package:changemaker_flutter_app/features/profile/views/profile_topics.dart';
import 'package:changemaker_flutter_app/features/profile/views/share_details.dart';
import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage(name: 'ProfileRoute')
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    ref.read(profileStateNotifierProvider.notifier).fetchUserTopics();
    final id = ref.read(authStateNotifierProvider).user?.uid;
    ref.read(profileStateNotifierProvider.notifier).getUserDetails(id ?? '');
  }

  Future<void> pickImage() async {
    try {
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );

      if (file != null) {
        setState(() {
          selectedImage = File(file.path);
        });
      }
    } catch (e) {
      debugPrint('IMAGE PICK ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileStateNotifierProvider);

    Widget dynamicWidget;
    String title;

    switch (profileState.profileTitle) {
      case ProfileStage.userSummary:
        title = '';
        dynamicWidget = const ProfileSummary();

      case ProfileStage.userTopics:
        title = 'My Topics';
        dynamicWidget = const ProfileTopics();

      case ProfileStage.userSelectedTopic:
        title = 'My Topics';
        dynamicWidget = const ProfileSelectedTopic();

      case ProfileStage.shareDetails:
        title = 'Share Details';
        dynamicWidget = const ShareDetails();
    }

    return Scaffold(
      body: BackgroundGradientWidget(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              const Gap(16),

              /// Firebase User Name
              Text(
                ref.read(authStateNotifierProvider).user?.displayName ??
                    'Hello',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 30.sp,
                ),
                textAlign: TextAlign.center,
              ),

              /// UPDATED — Profile Image Upload + Edit
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 145.r,
                  width: 145.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                    image: selectedImage != null
                        ? DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.contain,
                          )
                        : const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1654110455429-cf322b40a906?auto=format&fit=crop&q=80&w=1180',
                            ),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),

              /// Edit Button (visible only if image uploaded)
              if (selectedImage != null)
                TextButton(
                  onPressed: pickImage,
                  child: const Text('Edit Image'),
                ),

              const Gap(16),

              /// Title Chip
              Visibility(
                visible: title.isNotEmpty,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: ref.read(colorProvider).filledButtonColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 25.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Expanded(
                child: dynamicWidget,
              ),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton(
                  onPressed: () {
                    final notifier = ref.read(
                      profileStateNotifierProvider.notifier,
                    );
                    final state = ref.read(profileStateNotifierProvider);

                    switch (state.profileTitle) {
                      case ProfileStage.userSummary:
                        notifier.updateProfileTitle(ProfileStage.userTopics);

                      case ProfileStage.userTopics:
                        notifier.updateProfileTitle(ProfileStage.shareDetails);

                      case ProfileStage.shareDetails:
                        ref.read(routeProvider).replaceAll([
                          const HomePageRoute(),
                        ]);

                      default:
                        notifier.updateProfileTitle(ProfileStage.userSummary);
                    }
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: ref.read(colorProvider).filledButtonColor,
                  ),
                  child: Text(
                    t.login.further,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
