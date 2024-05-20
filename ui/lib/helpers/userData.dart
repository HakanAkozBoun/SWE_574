class UserData {
  static int? user_id;
  static String? user_name;

  setUserId(int id) {
    user_id = id;
  }

  setUserName(String name) {
    user_name = name;
  }

  getUserId() {
    return user_id;
  }

  getUserName() {
    return user_name;
  }
}
