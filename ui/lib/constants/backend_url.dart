class BackendUrl {
  static const String apiUrl = 'http://167.172.171.174:8000/api/';

  // static const String apiUrl = 'http://localhost:8000/api/';

  static const String currentUserUrl = apiUrl + 'MyProfile/';
  static const String followingUsersUrl = apiUrl + 'Following/';
  static const String bookmarkedRecipesUrl = apiUrl + 'MyBookmarks/';
  static const String selfRecipesUrl = apiUrl + 'MyRecipes/';
  static const String updateUserProfile = apiUrl + 'UpdateMyProfile/';
  static const String updateUser = apiUrl + 'UpdateUserInfo/';
  static const String checkUsernameAvailability = apiUrl + 'CheckUsername/';
  static const String checkEmailAvailability = apiUrl + 'CheckEmail/';
  static const String goals = apiUrl + 'Goals/';
  static const String createGoal = apiUrl + 'CreateGoal/';
  static const String updateGoal = apiUrl + 'UpdateGoal/';
}
