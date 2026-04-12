class CheckNull {
  static String string(dynamic value) {
    if (value == null) return "";
    return value.toString();
  }

  static bool boolean(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static int intValue(int? value) {
    if (value == null) {
      return 0;
    } else {
      return value;
    }
  }

  static double doubleValue(double? value) {
    if (value == null) {
      return 0;
    } else {
      return value;
    }
  }

  static List list(List? value) {
    if (value == null) {
      return [];
    } else {
      return value;
    }
  }

  static Map<String, dynamic> map(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return {};
  }
}
