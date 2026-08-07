import 'package:course/firebase_options.dart';
import 'package:course/services/auth/auth-user.dart';
import 'package:course/services/auth/auth-provider.dart';
import 'package:course/services/auth/auth-exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw userNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw weakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw emailAlreadyInUseAuthException();
      } else {
        throw genericAuthException();
      }
    } catch (_) {
      throw genericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw userNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code case 'invalid-credential') {
        throw wrongPasswordAuthException();
      } else if (e.code case 'invalid-email') {
        throw invalidEmailAuthException();
      } else if (e.code case 'user-not-found') {
        throw userNotFoundAuthException();
      } else {
        throw genericAuthException();
      }
    } catch (_) {
      throw genericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw userNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw userNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
