from django.urls import path, include


from .views import UpdateGoal, CreateGoal, GetGoals, GetNutritionDailyWithGoals, GetNutritionWeeklyWithGoal, UpdateUserInfo, UpdateUserProfile, add_rating, check_email, recommend_items, blogApiView, GetBlogList, categoryApiView, CategoryPostApiView, PopularPostsApiView, GetUserList, CreateCategory, GetCategoryList, Login, CreateBlog, GetBlog, UpdateUser, GetUser, File, GetUnitItemList, GetFoodList, GetRecipeList, GetUnitTypeList, GetFood, GetUnitType, GetSelfRecipes, GetFollowingUserProfilesList, GetBookmarkedRecipes, GetUnitItem, GetUnitConversionList, GetUnitList, GetNutrition, CreateComment, GetCommentList, bookmark_toggle, UserProfileView, InputFoodView, AllergyView, GetUnitList, RegisterAPIView, GetCurrentUserProfile, GetNutritionDaily, check_username  # CreateUser



from rest_framework import routers

router = routers.SimpleRouter()
router.register('blogs', blogApiView, basename='blogs')
router.register('category', categoryApiView, basename='category')
router.register('categoryBasedBlogs', CategoryPostApiView,
                basename='categoryBasedBlogs'
#router.register('PopularPostsApiView', PopularPostsApiView,basename='PopularPostsApiView'
 )

urlpatterns = [
    path('', include(router.urls)),
    path('UserList/', GetUserList, name='UserList'),
    path('UnitItemList/', GetUnitItemList, name='UnitItemList'),
    path('UnitItem/', GetUnitItem, name='UnitItem'),
    path('UnitList/', GetUnitList, name='UnitList'),
    path('CreateComment/', CreateComment, name='CreateComment'),
    path('CommentList/', GetCommentList, name='CommentList'),
    path('Food/', GetFood, name='Food'),
    path('FoodList/', GetFoodList, name='FoodList'),
    path('RecipeList/', GetRecipeList, name='RecipeList'),
    path('UnitTypeList/', GetUnitTypeList, name='UnitTypeList'),
    path('UnitType/', GetUnitType, name='UnitType'),
    path('Nutrition/', GetNutrition, name='Nutrition'),
    path('UnitConversionList/', GetUnitConversionList, name='UnitConversionList'),
    path('CategoryList/', GetCategoryList, name='CategoryList'),
    path('CreateCategory/', CreateCategory, name='CreateCategory'),
    path('Login/', Login, name='Login'),
    path('CreateBlog/', CreateBlog, name='CreateBlog'),
    path('GetBlog/', GetBlog, name='GetBlog'),
    path('UpdateUser/', UpdateUser, name='UpdateUser'),
    path('GetUser/', GetUser, name='GetUser'),
    path('File/', File, name='File'),
    path('BlogList/', GetBlogList, name='BlogList'),

    # NEW URLS
    path('bookmark/', bookmark_toggle, name='bookmark_toggle'),
    path('eaten/', eaten_toggle, name='bookmark_toggle'),
    path('recommend/', recommend_items, name='recommend_items'),

    path('Following/', GetFollowingUserProfilesList, name='FollowingUserList'),
    path('MyBookmarks/', GetBookmarkedRecipes, name='BookmarkedRecipes'),
    path('MyRecipes/', GetSelfRecipes, name='SelfRecipes'),
    path('MyProfile/', GetCurrentUserProfile, name='SelfProfile'),
    path('UpdateMyProfile/', UpdateUserProfile, name='UpdateProfile'),
    path('DailyNutrition/', GetNutritionDaily, name='DailyNutrition'),
    path('DailyNutritionWithGoals/', GetNutritionDailyWithGoals,
         name='DailyNutritionWithGoals'),
    path('WeeklyNutritionWithGoal/', GetNutritionWeeklyWithGoal,
         name='WeeklyNutritionWithGoal'),
    path('Goals/', GetGoals, name='Goals'),
    path('CreateGoal/', CreateGoal, name='CreateGoal'),
    path('UpdateGoal/', UpdateGoal, name='UpdateGoal'),
    path('CheckUsername/', check_username, name='CheckUsername'),
    path('CheckEmail/', check_email, name='CheckEmail'),
    path('UpdateUserInfo/', UpdateUserInfo, name='UpdateUserInfo'),

    path('add_rating/', add_rating, name='add_rating'),
    path('userprofile/', UserProfileView.as_view(), name='UserProfileViewSet'),
    path('inputfood/', InputFoodView.as_view(), name='InputFoodViewSet'),

    path('CreateUser/', RegisterAPIView.as_view(), name='RegisterAPIView'),
    path('allergy/', AllergyView.as_view(), name='AllergyViewSet'),
    path('PopularPostsApiView/', PopularPostsApiView, name='BlogList'),
]
