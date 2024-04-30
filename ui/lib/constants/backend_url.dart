class BackendUrl {
  static const String apiUrl = 'http://127.0.0.1:8000/api/';
  static const String currentUserUrl = BackendUrl.apiUrl + 'MyProfile/';
  static const String followingUsersUrl = BackendUrl.apiUrl + 'Following/';
  static const String bookmarkedRecipesUrl = BackendUrl.apiUrl + 'MyBookmarks/';
  static const String selfRecipesUrl = BackendUrl.apiUrl + 'MyRecipes/';
}
