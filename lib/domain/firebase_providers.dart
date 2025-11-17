import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://changemaker-22f3c-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
});

final userCollectionProvider = Provider<CollectionReference>((ref) {
  return ref.read(firebaseFirestoreProvider).collection(Collections.users);
});

final realtimeDbRepositoryProvider = Provider<RealtimeDbRepository>((ref) {
  final db = ref.read(firebaseDatabaseProvider);
  return RealtimeDbRepository(db);
});

class Collections {
  static const users = 'users';
  static const subscription = 'subscription';
}

class RealtimeDbRepository {
  RealtimeDbRepository(this.database);
  final FirebaseDatabase database;

  // Read data once
  Future<DataSnapshot> readOnce(String path) async {
    final ref = database.ref(path);
    return ref.get();
  }

  // Listen to stream
  Stream<DatabaseEvent> listen(String path) {
    final ref = database.ref(path);
    return ref.onValue;
  }

  // Write or update
  Future<void> write(String path, Map<String, dynamic> data) async {
    final ref = database.ref(path);
    await ref.set(data);
  }

  Future<void> update(String path, Map<String, dynamic> data) async {
    final ref = database.ref(path);
    await ref.update(data);
  }
}
