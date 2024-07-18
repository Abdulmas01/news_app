import 'package:firebase_auth/firebase_auth.dart';

extension UserCredentialExtion on UserCredential {
  String get usernameFromEmail => user!.email!.split("@")[0];
}
