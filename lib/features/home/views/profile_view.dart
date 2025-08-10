import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(authStateNotifierProvider.notifier).signOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
