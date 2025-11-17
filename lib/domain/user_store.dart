import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserStore {
  UserStore(this.ref);

  final Ref ref;

  Object? get userCreds => null;

  Future<void> saveUserDetails(
    UserCredential userCreds, {
    String? gender,
  }) async {
    await ref.read(userCollectionProvider).doc(userCreds.user!.uid).set({
      'uid': userCreds.user!.uid,
      'email': userCreds.user!.email,
      'name': userCreds.user!.displayName,
      'photoUrl': userCreds.user?.photoURL,
      'gender': gender,
    }, SetOptions(merge: true));
  }

  Future<void> saveRegisterUserDetail({
    String? gender,
    String? name,
    String? email,
    String? uid,
    String? photoUrl,
  }) async {
    await ref.read(userCollectionProvider).doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'gender': gender,
    }, SetOptions(merge: true));
  }
}

final userStoreProvider = Provider<UserStore>((ref) {
  return UserStore(ref);
});
