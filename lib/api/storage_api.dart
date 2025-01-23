import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/preferences.dart';

class StorageApi {
  static final box = GetStorage();
  static const String loggedInKey = "userLoggin";
  static const String user = "username";
  static const String emailkey = "email";
  static const String preferencesKey = "emailhuihuihiuh";
  static const String articlesKey = "asallsl";

  static String getEmail() {
    return box.read(emailkey) ?? "No email Address";
  }

  static List<Preferences> getprefference() {
    List pref = box.read(preferencesKey) ?? [];
    return pref.map((e) => Preferences.fromJson(e)).toList();
  }

  static bool getLoggedin() {
    return box.read(loggedInKey) ?? false;
  }

  static List<Article> getLocallArticle() {
    List all = box.read(articlesKey) ?? [];
    return all
        .map((e) => Article.fromJson((e as Map<String, dynamic>)))
        .toList();
  }

  static String getUsername() {
    return box.read(user);
  }

  static void setPrefference(List<Preferences> preference) {
    box.write(preferencesKey, preference.map((e) => e.toJson()).toList());
  }

  static void setUserCreadential(
      {required String username, required String email}) {
    box.write(user, username);
    box.write(emailkey, email);
  }

  static void setLoggedin(bool setLoggin) {
    box.write(loggedInKey, setLoggin);
  }

  static void addArticle(Article article) {
    List all = box.read(articlesKey) ?? [];
    all.removeWhere((element) => element["id"] == article.id);
    all.add(article.toJson());
    box.write(articlesKey, all);
  }

  static void logout() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    box.write(user, null);
    box.write(emailkey, null);
    await auth.signOut();
    setLoggedin(false);
  }
}
