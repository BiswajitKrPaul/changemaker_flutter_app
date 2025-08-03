import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_provider.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    @Default(false) bool isLoggedIn,
  }) = _AuthState;
}

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    ref
        .watch(firebaseAuthProvider)
        .authStateChanges()
        .listen(
          updateUser,
        );
    return const AuthState();
  }

  void updateUser(User? user) {
    state = state.copyWith(user: user, isLoggedIn: user != null);
  }

  void signOut() {
    ref.read(firebaseAuthProvider).signOut();
  }
}

final authStateNotifierProvider =
    NotifierProvider<AuthStateNotifier, AuthState>(AuthStateNotifier.new);
