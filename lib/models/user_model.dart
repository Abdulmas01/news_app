import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/main.dart';
import 'package:news_app/models/preferences.dart';
import 'package:news_app/utils/database_collection.dart';

class User {
  final String username;
  final String? email;
  List<Preferences> userPrefference = [];

  User({required this.username, this.email});
  factory User.fromJson(Map<String, dynamic> json) =>
      User(username: json['username']);

  static Future<User> userfromDb(
      {required String email, required String password}) async {
    String username = email.split("@")[0];
    QuerySnapshot<Map<String, dynamic>> snapshot = await db!
        .collection(usersCollection)
        .where("email", isEqualTo: email)
        .get();
    if (snapshot.docs.isEmpty) {
      await db
          ?.collection(usersCollection)
          .doc(username)
          .set({"username": username, "email": email});
      return User(username: username);
    }
    Map<String, dynamic> userdata = snapshot.docs.first.data();
    if (userdata.keys.contains("username")) {
      username = userdata["username"];
      List<Preferences>? pref = (userdata["preference"] as List?)
          ?.map((e) => Preferences.fromString(e))
          .toList();
      return User(username: username)..userPrefference = pref ?? [];
    } else {
      return Future.error(User);
    }
  }

  Future registerNewUser({required String password}) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
          email: email!, password: password);
      await db?.collection(usersCollection).doc(username).set(tojson());
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  bool vallidatePassword(
      {required String password, required String confirmPassword}) {
    return password == confirmPassword;
  }

  Map<String, dynamic> tojson() {
    return {"username": username, "email": email};
  }

  Map<String, dynamic> usernameJson() {
    return {"username": username};
  }
}
