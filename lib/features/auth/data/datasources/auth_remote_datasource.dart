import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(cred.user!.uid)
          .get();
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        id:    cred.user!.uid,
        name:  name,
        email: email,
        role:  'customer',
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toJson());
      return user;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> logout() async => await _auth.signOut();

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(firebaseUser.uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromJson({...doc.data()!, 'id': doc.id});
  }
}