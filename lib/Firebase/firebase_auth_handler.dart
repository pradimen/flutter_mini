import 'package:firebase_auth/firebase_auth.dart';
import 'package:petfit/Firebase/util.dart';

class AuthExceptionHandler {
  static AuthResultStatus handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    print('Login errorcode $exceptionCode');
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage =
            "Error in login. Please try again with valid credintials.";
    }

    return errorMessage;
  }
}

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  AuthenticationProvider(this.firebaseAuth);
  Stream<User?> get authState => firebaseAuth.idTokenChanges();
  User? currentUser;
  var authResult = AuthResultStatus.undefined;
  // final database = DataRepository();

  bool checkForAdminUser(User credential) {
    if (credential.email != null) {
      FirebaseConnection().isLoggedIn = true;
      if (credential.email!.contains('petfit_admin@gmail.com')) {
        return true;
      }
    }
    FirebaseConnection().isLoggedIn = true;
    return false;
  }

  // void isUserLoggedIn(User credintial) {
  //   if (credintial.email != null) {
  //     FirebaseConnection().isLoggedIn = true;
  //   }
  //   FirebaseConnection().isLoggedIn = false;
  // }

  Future<String?> signIn(
      {required String email,
      required String password,
      required Function onLogin}) async {
    try {
      UserCredential authCredintials = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (authCredintials.user != null) {
        FirebaseConnection().isAdmin = checkForAdminUser(authCredintials.user!);
        authResult = AuthResultStatus.successful;
        currentUser = authCredintials.user;
      } else {
        authResult = AuthResultStatus.undefined;
      }
      onLogin(authResult);
      return authCredintials.user?.email;
    } on FirebaseAuthException catch (e) {
      authResult = AuthExceptionHandler.handleException(e);
      onLogin(authResult);
      return e.message;
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      currentUser = null;
      FirebaseConnection().isAdmin = false;
      FirebaseConnection().isLoggedIn = false;
      print("Signout");
    } on FirebaseException catch (e) {
      print("Signour error ${e.message}");
    }
  }
}
