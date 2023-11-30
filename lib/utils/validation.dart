class IsValid {
  IsValid._();
  static bool email(String? e) {
    if (e == null) {
      return false;
    }
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    return RegExp(pattern).hasMatch(e);
  }

  static bool mobileNumber(String? number) {
    if (number == null) return false;
    String pattern = r'(^[0-9]{10}$)';
    return RegExp(pattern).hasMatch(number);
  }

  static bool pancardNumber(String? pan) {
    if (pan == null) return false;
    String pattern = r"[A-Z]{5}[0-9]{4}[A-Z]{1}";
    return RegExp(pattern).hasMatch(pan);
  }

  static bool ifscCode(String? code) {
    if (code == null) return false;
    String pattern = r'^[A-Z]{4}0[A-Z0-9]{6}$';
    return RegExp(pattern).hasMatch(code);
  }

  static bool bankAccountNumber(String? number) {
    if (number == null) return false;
    String pattern = r'[0-9]{9,18}';
    return RegExp(pattern).hasMatch(number);
  }

  static bool password(String? pswd) {
    if (pswd == null) return false;
    String pattern =
        r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{4,}$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(pswd);
  }

//The input value is not empty and contains only letters, spaces, and common punctuation marks
  static bool text(String? txt) {
    if (txt == null) return false;
    String pattern = r"^[a-zA-Z\s\.\-\'\,]*$";
    return RegExp(pattern).hasMatch(txt);
  }
}
