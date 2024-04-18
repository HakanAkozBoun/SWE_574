from django.urls import path, include
from .views import recommend_items, blogApiView, categoryApiView, CategoryPostApiView, PopularPostsApiView, GetUserList, CreateUser, CreateCategory, GetCategoryList, Login,CreateBlog,GetBlog,UpdateUser, GetUser, File, GetUnitItemList, GetFoodList, GetRecipeList, GetUnitTypeList, GetFood, GetUnitType, GetUnitItem, GetUnitConversionList, GetUnitList, GetNutrition, CreateComment, GetCommentList, bookmark_toggle, RegisterAPIView
from .views import recommend_items, blogApiView, GetBlogList, categoryApiView, CategoryPostApiView, PopularPostsApiView, GetUserList, CreateUser, CreateCategory, GetCategoryList, Login,CreateBlog,GetBlog,UpdateUser, GetUser, File, GetUnitItemList, GetFoodList, GetRecipeList, GetUnitTypeList, GetFood, GetUnitType, GetUnitItem, GetUnitConversionList, GetUnitList, GetNutrition, CreateComment, GetCommentList, bookmark_toggle
from rest_framework import routers
from django.contrib.auth import views as auth_views
from two_factor.urls import urlpatterns as tf_urls

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
    
    # sign in/register
    path('api/register/', RegisterAPIView.as_view(), name='api_register'),
    path('login/', auth_views.LoginView.as_view(), name='login'),  # Giriş sayfası
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),  # Çıkış işlemi
    path('accounts/', include('django.contrib.auth.urls')),  # Django auth için URL
    path('accounts/two_factor/', include(tf_urls)),  # İki faktörlü auth için URL
]