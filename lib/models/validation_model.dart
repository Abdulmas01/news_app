class ValidationModel {
  final bool validationError;
  final String? message;

  ValidationModel({required this.validationError, this.message});
  static bool matchPassword(password, confirmPassword) {
    return password == confirmPassword ? true : false;
  }
}
