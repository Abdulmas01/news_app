class AccountApi {
  bool isPasswordMatch(
      {required String password, required String confirmPassword}) {
    return password == confirmPassword ? true : false;
  }
}
