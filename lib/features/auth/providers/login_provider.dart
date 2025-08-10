import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:changemaker_flutter_app/domain/user_store.dart';
import 'package:changemaker_flutter_app/features/auth/providers/auth_provider.dart';
import 'package:changemaker_flutter_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'login_provider.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isLoading,
    @Default(false) bool isSocialLoginLoading,
  }) = _LoginState;
}

class LoginStateNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  bool isButtonEnanbled() {
    final v1 = ValidationBuilder().email().build();
    final v2 = ValidationBuilder().minLength(6).build();
    return v1(state.email) != null || v2(state.password) != null;
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> signInUsingGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final googleUser = await GoogleSignIn.instance.authenticate();

      // Obtain the auth details from the request
      final googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      state = state.copyWith(isSocialLoginLoading: true);
      // Once signed in, return the UserCredential
      final userCredential = await ref
          .read(firebaseAuthProvider)
          .signInWithCredential(credential);
      ref
          .read(authStateNotifierProvider.notifier)
          .updateUser(userCredential.user);
      final data = await ref
          .read(userCollectionProvider)
          .where('uid', isEqualTo: userCredential.user!.uid)
          .get();
      if (data.size == 0) {
        await ref.read(userStoreProvider).saveUserDetails(userCredential);
      }
      if (ref.mounted) {
        await ref.read(routeProvider).replaceAll([const OnboardingViewRoute()]);
      }
    } on FirebaseAuthException catch (e) {
      AppUtils.showSnackBar(
        e.message ?? 'Invalid Login',
      );
    } on GoogleSignInException catch (e) {
      AppUtils.showSnackBar(e.description.toString());
    } finally {
      state = state.copyWith(isSocialLoginLoading: false);
    }
  }

  Future<void> signIn() async {
    try {
      state = state.copyWith(isLoading: true);
      final firebaseAuth = ref.read(firebaseAuthProvider);
      final userCreds = await firebaseAuth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      if (userCreds.user != null) {
        ref.read(authStateNotifierProvider.notifier).updateUser(userCreds.user);
        final data = await ref
            .read(userCollectionProvider)
            .where('uid', isEqualTo: userCreds.user!.uid)
            .get();
        if (data.size == 0) {
          await ref.read(userStoreProvider).saveUserDetails(userCreds);
        }
        if (ref.mounted) {
          await ref.read(routeProvider).replaceAll([
            const OnboardingViewRoute(),
          ]);
        }
      }
    } on FirebaseAuthException catch (e) {
      AppUtils.showSnackBar(
        e.message ?? 'Invalid Login',
      );
    } on Exception catch (e) {
      AppUtils.showSnackBar(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final NotifierProvider<LoginStateNotifier, LoginState>
loginStateNotifierProvider =
    NotifierProvider.autoDispose<LoginStateNotifier, LoginState>(
      LoginStateNotifier.new,
    );
