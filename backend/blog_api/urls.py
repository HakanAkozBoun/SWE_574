from django.urls import path, include
from .views import add_rating, recommend_items, blogApiView, GetBlogList, categoryApiView, CategoryPostApiView, PopularPostsApiView, GetUserList, CreateUser, CreateCategory, GetCategoryList, Login,CreateBlog,GetBlog,UpdateUser, GetUser, File, GetUnitItemList, GetFoodList, GetRecipeList, GetUnitTypeList, GetFood, GetUnitType, GetUnitItem, GetUnitConversionList, GetUnitList, GetNutrition, CreateComment, GetCommentList, bookmark_toggle, UserProfileViewSet, InputFoodViewSet
from rest_framework import routers

router = routers.SimpleRouter()
router.register('blogs', blogApiView, basename='blogs')
router.register('category', categoryApiView, basename='category')
router.register('categoryBasedBlogs', CategoryPostApiView, basename='categoryBasedBlogs')
router.register('PopularPostsApiView', PopularPostsApiView, basename='PopularPostsApiView')

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
    path('CreateUser/', CreateUser, name='CreateUser'),
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
    path('recommend/', recommend_items, name='recommend_items'),
    path('add_rating/', add_rating, name='add_rating'),
    path('userprofile/', UserProfileViewSet, name='UserProfileViewSet'),
    path('inputfood/', InputFoodViewSet, name='InputFoodViewSet'),
    
]