class BackendUrl {
  static const String apiUrl = 'http://167.172.171.174:8000/api/';

  ///static const String apiUrl = 'http://127.0.0.1:8000/api/';

  static const String currentUserUrl = apiUrl + 'MyProfile/';
  static const String followingUsersUrl = apiUrl + 'Following/';
  static const String bookmarkedRecipesUrl = apiUrl + 'MyBookmarks/';
  static const String selfRecipesUrl = apiUrl + 'MyRecipes/';
  static const String updateUserProfile = apiUrl + 'UpdateMyProfile/';
}
