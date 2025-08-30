import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_providers.freezed.dart';

@freezed
abstract class ResetPasswordProviders with _$ResetPasswordProviders {
  const factory ResetPasswordProviders({
    @Default(false) bool isLoading,
    @Default('') String email,
  }) = _ResetPasswordProviders;
}

class ResetPasswordNotifier extends Notifier<ResetPasswordProviders> {
  @override
  ResetPasswordProviders build() {
    return const ResetPasswordProviders();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  String? isEmailHasError() {
    final v1 = ValidationBuilder(
      localeName: LocaleSettings.currentLocale.languageCode,
    ).email().build();
    return v1(state.email);
  }

  bool isButtonEnanbled() {
    final v1 = ValidationBuilder().email().build();
    return v1(state.email) != null;
  }

  Future<void> resetPassword() async {
    try {
      state = state.copyWith(isLoading: true);
      await ref
          .read(firebaseAuthProvider)
          .sendPasswordResetEmail(email: state.email);
      state = state.copyWith(isLoading: false);
      await ref.read(routeProvider).replaceAll([
        const LandingPageRoute(),
      ]);
      AppUtils.showSnackBar(t.resetpassword.send);
    } on Exception catch (e) {
      AppUtils.showSnackBar(e.toString());
      state = state.copyWith(isLoading: false);
    }
  }
}

final resetPasswordProvider =
    NotifierProvider<ResetPasswordNotifier, ResetPasswordProviders>(
      ResetPasswordNotifier.new,
    );
