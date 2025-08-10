import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:changemaker_flutter_app/domain/user_store.dart';
import 'package:changemaker_flutter_app/utils/app_utils.dart';
import 'package:changemaker_flutter_app/utils/extension_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_provider.freezed.dart';

enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  const Gender(this.label);
  final String label;
}

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(false) bool isDone,
    @Default(false) bool isLoading,
    Gender? gender,
    @Default('') String name,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isConfirmPasswordVisible,
  }) = _RegisterState;
}

class RegisterStateNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  bool isButtonEnanbled() {
    final v1 = ValidationBuilder().email().build();
    final v2 = ValidationBuilder().minLength(5).build();
    final v3 = ValidationBuilder().required().build();
    final v4 = ValidationBuilder().minLength(8).build();
    final v5 = ValidationBuilder()
        .minLength(8)
        .confirmPassword(state.password)
        .build();
    return v1(state.email) != null ||
        v2(state.password) != null ||
        v3(state.name) != null ||
        v4(state.password) != null ||
        v5(state.confirmPassword) != null;
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void updateGender(String gender) {
    state = state.copyWith(
      gender: Gender.values.firstWhere(
        (element) => element.name == gender,
      ),
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  Future<void> register() async {
    try {
      state = state.copyWith(isLoading: true);
      final firebaseAuthP = ref.read(firebaseAuthProvider);
      final data = await firebaseAuthP.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      if (data.user != null) {
        await ref
            .read(userStoreProvider)
            .saveRegisterUserDetail(
              uid: data.user!.uid,
              email: state.email,
              name: state.name,
              photoUrl: data.user?.photoURL,
              gender: state.gender?.label,
            );
        state = state.copyWith(isLoading: false);
        await ref.read(routeProvider).replaceAll([const OnboardingViewRoute()]);
      }
    } on FirebaseAuthException catch (e) {
      AppUtils.showSnackBar(e.message ?? 'Could not register');
      state = state.copyWith(isLoading: false);
    }
  }
}

final NotifierProvider<RegisterStateNotifier, RegisterState> registerProvider =
    NotifierProvider.autoDispose<RegisterStateNotifier, RegisterState>(
      RegisterStateNotifier.new,
    );
