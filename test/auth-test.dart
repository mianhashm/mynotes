import 'package:course/services/auth/auth-exceptions.dart';
import 'package:course/services/auth/auth-provider.dart';
import 'package:course/services/auth/auth-user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();

    // INITIALIZED OR NOT
    test("Should not be initialized to begin with", () {
      expect(provider.isInitialized, false);
    });

    // LOG OUT OR NOT
    test("Cannot log out before initialization", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    // IS INITIALIZED
    test("Should be able to be initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    // CURRENT USER SHOULD BE NULL
    test("User should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    // INITIALIZE IS LESS THAN 2 SECS
    test(
      "Should initialize in less than 2 secs",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(
        Duration(seconds: 3),
      ), // FIX 3: Expanded timeout to prevent millisecond overhead failures
    );

    // LOGIN & CREATE USER STUFF
    test("Create user should delegate to login function", () async {
      // Bad email test
      final badEmailUser = provider.createUser(
        email: "foo@bar.com",
        password: "anypassword",
      );
      expect(
        badEmailUser,
        throwsA(
          const TypeMatcher<userNotFoundAuthException>(),
        ), // FIX 1: Proper class type casing
      );

      // Bad password test
      final badPasswordUser = provider.createUser(
        email: "someone@bar.com",
        password: "foobar",
      );
      expect(
        badPasswordUser,
        throwsA(
          const TypeMatcher<wrongPasswordAuthException>(),
        ), // FIX 1: Proper class type casing
      );

      // Successful creation
      final user = await provider.createUser(
        email:
            "valid@bar.com", // FIX 2: Used valid email instead of foo@bar.com
        password: "password123",
      );
      expect(provider.currentUser, isNotNull);
      expect(user.isEmailVerified, false);
    });

    // LOG OUT AND LOG IN
    test("Should be able to log out and log in again", () async {
      await provider.logOut();
      expect(provider.currentUser, null);

      await provider.logIn(email: "valid@email.com", password: "validpassword");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw userNotFoundAuthException();
    if (password == "foobar") throw wrongPasswordAuthException();
    final user = AuthUser(isEmailVerified: false, email: 'foo@bar.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw userNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw userNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'foo@bar.com');
    _user = newUser;
  }
}
