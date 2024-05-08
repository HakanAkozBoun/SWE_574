from django.utils import timezone
import json

from .models import blog, category, food, recipe, unit, unittype, unititem, unitconversion, nutrition, Follower, comment, UserBookmark, UserRating, UserProfile, InputFood, Eaten, image
from .serializers import UserForProfileFrontEndSerializer, blogSerializer, categorySerializer, UserProfileSerializer, InputFoodSerializer, UserSerializer, AllergySerializer, UserProfileForFrontEndSerializer

from rest_framework import viewsets
from rest_framework import mixins
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.contrib.auth import authenticate
from django.forms.models import model_to_dict
from django.core.files.storage import default_storage
import base64
from django.shortcuts import get_object_or_404
from .models import UserBookmark
from .utils.recommendation import get_recommendations
from rest_framework import views
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView
from rest_framework import serializers, views, status
from rest_framework.response import Response
from .models import Allergy
from django.contrib.auth.models import User


class blogApiView(viewsets.GenericViewSet, mixins.ListModelMixin, mixins.RetrieveModelMixin):
    queryset = blog.objects.all()
    serializer_class = blogSerializer
    lookup_field = 'slug'


class categoryApiView(viewsets.GenericViewSet, mixins.ListModelMixin, mixins.RetrieveModelMixin):
    queryset = category.objects.all()
    serializer_class = categorySerializer
    lookup_field = 'id'


class CategoryPostApiView(viewsets.ViewSet):
    def retrieve(self, request, pk=None):
        queryset = blog.objects.filter(category=pk)
        serializer = blogSerializer(queryset, many=True)
        return Response(serializer.data)


class PopularPostsApiView(viewsets.ViewSet):
    def list(self, request, pk=None):
        queryset = blog.objects.filter(
            postlabel__iexact='POPULAR').order_by('-id')[0:4]
        serializer = blogSerializer(queryset, many=True)
        return Response(serializer.data)


@api_view(['GET'])
def GetUserList(request):
    all_users = User.objects.all().values("id", "username", "first_name",
                                          "last_name", 'email', 'is_active', 'last_login')
    user_list = list(all_users)
    return JsonResponse(user_list, safe=False)


@api_view(['GET'])
def GetFollowingUserProfilesList(request):
    '''
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)
    '''
    # EE 1'i değiştir
  #  queryset = Follower.objects.filter(follower_user=1).select_related('following_user')
    user_id = request.query_params.get('id')
    following_user_set = Follower.objects.filter(
        follower_user=user_id).select_related('following_user')
    following_user_profiles = UserProfile.objects.filter(
        user__in=[follow.following_user for follow in following_user_set])
    serializers = UserProfileForFrontEndSerializer(
        following_user_profiles, many=True)
    return Response(serializers.data)


@api_view(['GET'])
def GetBookmarkedRecipes(request):

   # if not request.user.is_authenticated:
    #    return JsonResponse({'error': 'Authentication required'}, status=401)
    user_id = request.query_params.get('id', '1')
    bookmarks = UserBookmark.objects.filter(
        user=user_id).select_related('blog')

    bookmarked_recipes_list = [{
        'id': bookmark.blog.id,
        'title': bookmark.blog.title,
        # recipelere desc ekleyebiliriz istersek
        # 'description': bookmark.bookmarked_recipe.description,
    } for bookmark in bookmarks]

    return JsonResponse(bookmarked_recipes_list, safe=False)


@api_view(['GET'])
def GetSelfRecipes(request):

    # çalışması için user id olması lazım recipe modelinde
    ''' if not request.user.is_authenticated:
         return JsonResponse({'error': 'Authentication required'}, status=401)
     '''
    # EE id 1 değişmeli
    # id= request.user.id
    user_id = request.query_params.get('id', '1')

    queryset = blog.objects.filter(userid=user_id)
    serializer = blogSerializer(queryset, many=True)
    return Response(serializer.data)
    ''' recipes_list = [{
        'id': recipe.id,
        'food': recipe.food,
        'unit': recipe.unit,
        'amount': recipe.amount,
        'blog': recipe.blog,
        'metricamount': recipe.metricamount,
        'metricunit': recipe.metricunit
    } for recipe in self_recipes]
    '''


@api_view(['PUT'])
def UpdateUser(request):
    user = User.objects.get(id=request.data.get('id'))
    user.username = request.data.get('user')
    user.email = request.data.get('mail')
    user.save()
    return JsonResponse(True, safe=False)


@api_view(['GET'])
def GetUser(request):
    return JsonResponse(model_to_dict(User.objects.get(id=request.GET.get('id'))), safe=False)


@api_view(['GET'])
def check_email(request):
    email = request.GET.get('email', None)
    user_id = request.GET.get('user_id', None)
    if not email:
        return JsonResponse({'error': 'No username provided'}, status=400)

    if user_id:
        exists = User.objects.filter(
            email=email).exclude(id=user_id).exists()
    else:
        exists = User.objects.filter(email=email).exists()

    return JsonResponse({'exists': exists})


@api_view(['GET'])
def check_username(request):
    username = request.GET.get('username', None)
    user_id = request.GET.get('user_id', None)
    if not username:
        return JsonResponse({'error': 'No username provided'}, status=400)

    if user_id:
        exists = User.objects.filter(
            username=username).exclude(id=user_id).exists()
    else:
        exists = User.objects.filter(username=username).exists()

    return JsonResponse({'exists': exists})


@api_view(['PATCH'])
def UpdateUserInfo(request):
    user_id = request.query_params.get('id', '1')
    user = User.objects.get(id=user_id)
    fields_to_update = ['username', 'email',
                        'password',  'first_name', 'last_name']
    for field in fields_to_update:
        if field in request.data:
            setattr(user, field, request.data[field])
    user.save()
    userProfile = UserProfile.objects.get(user=user)
    serializer_class = UserProfileForFrontEndSerializer
    return Response(serializer_class(userProfile).data)


@api_view(['PATCH'])
def UpdateUserProfile(request):
    user_id = request.query_params.get('id')
    try:
        userProfile = UserProfile.objects.get(user=user_id)
    except UserProfile.DoesNotExist:
        return JsonResponse({'error': 'UserProfile not found.'}, status=404)

    fields_to_update = ['age', 'weight', 'height', 'description', 'image',
                        'experience', 'gender', 'graduated_from', 'cuisines_of_expertise', 'working_at']
    for field in fields_to_update:
        if field in request.data:
            setattr(userProfile, field, request.data[field])

    userProfile.save()
    serializer_class = UserProfileForFrontEndSerializer
    return Response(serializer_class(userProfile).data)
    # return JsonResponse(model_to_dict(userProfile), safe=False)


@api_view(['GET'])
def GetCurrentUserProfile(request):
    # EE id=1'i değiştir
    user_id = request.query_params.get('id', '1')
    given_user = User.objects.get(id=user_id)
    queryset = UserProfile.objects.get(user=given_user)
    serializer_class = UserProfileForFrontEndSerializer
    return Response(serializer_class(queryset).data)
    # return JsonResponse(model_to_dict(UserProfile.objects.get(id=request.GET.get('id'))), safe=False)


# @api_view(['GET'])
# def GetCategoryList(request):
#     all_users = category.objects.all().values("id", "name", "image")
#     user_list = list(all_users)
#     return JsonResponse(user_list, safe=False)

@api_view(['GET'])
def GetCategoryList(request):
    all = category.objects.all().values("id", "name", "image")
    imagelist = image.objects.filter(id__in=all.values_list('image', flat=True))
    response = []
    for category_ in all:
        json = { 'base64' : None, 'image': None, 'type':None }
        if category_.get('image') is not None:
            image_ = imagelist.filter(id=category_.get('image')).first()
            if image_ is not None:
               json['base64'] = image_.data
               json['image'] = image_.name
               json['type'] = image_.type
        json['id'] = category_.get('id')
        json['name'] = category_.get('name')
        response.append(json)
   
    return JsonResponse(response, safe=False)

@api_view(['POST'])
def CreateCategory(request):
    _id = request.data.get('id')
    if _id is None:
        category.objects.create(name=request.data.get(
            'name'), image=request.data.get('image'))
    else:
        _category = category.objects.filter(id=_id).first()
        if _category is None:
            return JsonResponse("id not found", safe=False)
        _category.name = request.data.get('name')
        _category.image = request.data.get('image')
        _category.save()
    return JsonResponse("OK", safe=False)


@api_view(['POST'])
def File(request):
    file = request.FILES['file']
    image_ = image.objects.create(name=file.name, data=base64.b64encode(file.read()).decode('ascii'), type=file.content_type)
    return JsonResponse({'id': image_.id, 'name': image_.name}, safe=False)


@api_view(['POST'])
def CreateBlog(request):
    # EE user id None olarak sabitlendi
    # _id = request.data.get('id')
    _id = None
    if _id is None:

        _blog = blog.objects.create(category_id=request.data.get('category'), title=request.data.get('title'), slug=request.data.get('slug'), excerpt=request.data.get('excerpt'), content=request.data.get('content'), contentTwo=request.data.get('contentTwo'), avg_rating=request.data.get(
            'avg_rating'), serving=request.data.get('serving'), userid=request.data.get('userid'), preparationtime=request.data.get('preparationtime'), cookingtime=request.data.get('cookingtime'), image=request.data.get('image'), ingredients=request.data.get('ingredients'), postlabel=request.data.get('postlabel'))
    else:
        _blog = blog.objects.filter(id=_id).first()
        if _blog is None:
            return JsonResponse("id not found", safe=False)
        _blog.category_id = request.data.get('category')
        _blog.title = request.data.get('title')
        _blog.slug = request.data.get('slug')
        _blog.excerpt = request.data.get('excerpt')
        _blog.content = request.data.get('content')
        _blog.contentTwo = request.data.get('contentTwo')
        _blog.preparationtime = request.data.get('preparationtime')
        _blog.cookingtime = request.data.get('cookingtime')
        _blog.avg_rating = request.data.get('avg_rating')
        _blog.image = request.data.get('image')
        _blog.ingredients = request.data.get('ingredients')
        _blog.postlabel = request.data.get('postlabel')
        _blog.userid = request.data.get('userid')
        _blog.serving = request.data.get('serving')

        _blog.save()

        list = recipe.objects.filter(blog=_id)
        for item in list:
            item.delete()

    list = request.data.get('list')
    conversion = unitconversion.objects.all()
    for item in list:
        metricamount = item.get('amount')
        metricunit = item.get('unit')
        _conversion = conversion.filter(imperial=item.get('unit'))
        if _conversion:
            metricamount /= _conversion.first().ivalue
            metricunit = _conversion.first().metric
        recipe.objects.create(food=item.get('food'), unit=item.get('unit'), amount=item.get(
            'amount'), blog=_blog.id, metricamount=metricamount, metricunit=metricunit)
    return JsonResponse(_blog.id, safe=False)


@api_view(['GET'])
def GetBlogList(request):
    all_blog = blog.objects.all().values("id", "name", "image")
    blog_list = list(all_blog)
    return JsonResponse(blog_list, safe=False)


@api_view(['GET'])
def GetBlog(request):
    all_blog = blog.objects.filter(blog=2).values("id", "name", "image")
    blog_list = list(all_blog)
    return JsonResponse(blog_list, safe=False)


@api_view(['GET'])
def GetFood(request):
    return JsonResponse(model_to_dict(food.objects.get(id=request.GET.get('id'))), safe=False)


@api_view(['GET'])
def GetFoodList(request):
    list = []
    filter = request.GET.get('filter')
    if filter is None:
        filter = ''
    current = food.objects.filter(name__contains=filter)[:10].all()
    unit = unittype.objects.values_list('name', flat=True).all()
    for item in current:
        list.append({"id": item.id, "unitid": item.unit,
                    "unit": unit.get(id=item.unit), "name": item.name})
    return JsonResponse(list, safe=False)


@api_view(['GET'])
def GetRecipeList(request):
    list = []
    current = recipe.objects.filter(blog=request.GET.get('blog'))
    _food = food.objects.values_list('name', flat=True).all()
    _unit = unit.objects.values_list('name', flat=True).all()
    for item in current:
        list.append({"food": _food.get(id=item.food), "unit": _unit.get(id=item.unit), "unitid": item.unit, "amount": item.amount,
                    "metricamount": item.metricamount, "metricunit": _unit.get(id=item.metricunit), "metricunitid": item.metricunit})
    return JsonResponse(list, safe=False)


@api_view(['GET'])
def GetUnitList(request):
    return JsonResponse(list(unit.objects.all().values("id", "name", "type")), safe=False)


@api_view(['GET'])
def GetUnitType(request):
    return JsonResponse(model_to_dict(unittype.objects.get(id=request.GET.get('id'))), safe=False)


@api_view(['GET'])
def GetUnitTypeList(request):
    return JsonResponse(list(unittype.objects.all().values("id", "name")), safe=False)


@api_view(['GET'])
def GetUnitItem(request):
    return JsonResponse(model_to_dict(unititem.objects.get(id=request.GET.get('id'))), safe=False)


@api_view(['GET'])
def GetUnitItemList(request):
    return JsonResponse(list(unititem.objects.filter(unit=request.GET.get('unit')).values("id", "imperial", "metric", "unit")), safe=False)


@api_view(['GET'])
def GetUnitConversionList(request):
    return JsonResponse(list(unitconversion.objects.filter(unittype=request.GET.get('unit')).values("id", "imperial", "metric", "mvalue", "ivalue", "unittype")), safe=False)


'''
@api_view(['GET'])
def GetGoals(request):
    user_id = request.query_params.get('id', '1')
    userProfile = UserProfile.objects.get(id=user_id)
    goals = CalculateGoals(userProfile)
    serializer_class = UserProfileForFrontEndSerializer
    return Response(serializer_class(queryset).data)
'''


def CalculateGoals(userProfile):
    calorie = CalculateGoalCalorie()
    fat = CalculateGoalFat()
    sodium = CalculateGoalSodium()
    calcium = CalculateGoalCalcium(
        age=userProfile.age, gender=userProfile.gender)  # miligrams
    protein = CalculateGoalProtein()
    iron = CalculateGoalIron()
    carbonhydrates = CalculateGoalCarbonhydrates()
    sugars = CalculateGoalSugars()
    fiber = CalculateGoalFiber()
    vitamina = CalculateGoalVitamina()
    vitaminb = CalculateGoalVitaminb()
    vitamind = CalculateGoalVitamind()


def CalculateGoalCalorie():
    return 0


def CalculateGoalFat():
    return 0


def CalculateGoalSodium():
    return 0


def CalculateGoalCalcium(age, gender):
    # https://ods.od.nih.gov/factsheets/Calcium-HealthProfessionalnths*	200 mg	200 mg
    necessaryCalciumIntake = 0
    if (gender == "M" or "m"):
        if (age <= 1):
            necessaryCalciumIntake = 260

        elif (age > 1 and age <= 3):

            necessaryCalciumIntake = 700

        elif (age > 3 and age <= 8):
            necessaryCalciumIntake = 1000

        elif (age > 8 and age <= 13):
            necessaryCalciumIntake = 1300

        elif (age > 13 and age <= 18):
            necessaryCalciumIntake = 1300

        elif (age > 18 and age <= 50):
            necessaryCalciumIntake = 1000

        elif (age > 50 and age <= 70):
            necessaryCalciumIntake = 1000

        elif (age > 70):
            necessaryCalciumIntake = 1200

    elif (gender == "F" or "f"):
        if (age <= 1):
            necessaryCalciumIntake = 260

        elif (age > 1 and age <= 3):

            necessaryCalciumIntake = 700

        elif (age > 3 and age <= 8):
            necessaryCalciumIntake = 1000

        elif (age > 8 and age <= 13):
            necessaryCalciumIntake = 1300

        elif (age > 13 and age <= 18):
            necessaryCalciumIntake = 1300

        elif (age > 18 and age <= 50):
            necessaryCalciumIntake = 1000

        elif (age > 50 and age <= 70):
            necessaryCalciumIntake = 1200

        elif (age > 70):
            necessaryCalciumIntake = 1200
    return necessaryCalciumIntake


def CalculateGoalProtein():
    return 0


def CalculateGoalIron():
    return 0


def CalculateGoalCarbonhydrates():
    return 0


def CalculateGoalSugars():
    return 0


def CalculateGoalFiber():
    return 0


def CalculateGoalVitamina():
    return 0


def CalculateGoalVitaminb():
    return 0


def CalculateGoalVitamind():
    return 0


@api_view(['GET'])
def GetNutrition(request):
    _blog = blog.objects.get(id=request.GET.get('blog'))
    _nutrition = nutrition.objects.all()
    _recipe = recipe.objects.filter(blog=_blog.id)
    calorie = 0
    fat = 0
    sodium = 0
    calcium = 0
    protein = 0
    iron = 0
    carbonhydrates = 0
    sugars = 0
    fiber = 0
    vitamina = 0
    vitaminb = 0
    vitamind = 0
    for i in _recipe:
        __nutrition = _nutrition.filter(food=i.food).first()
        if __nutrition:
            calorie += __nutrition.calorie * i.metricamount
            fat += __nutrition.fat * i.metricamount
            sodium += __nutrition.sodium * i.metricamount
            calcium += __nutrition.calcium * i.metricamount
            protein += __nutrition.protein * i.metricamount
            iron += __nutrition.iron * i.metricamount
            carbonhydrates += __nutrition.carbonhydrates * i.metricamount
            sugars += __nutrition.sugars * i.metricamount
            fiber += __nutrition.fiber * i.metricamount
            vitamina += __nutrition.vitamina * i.metricamount
            vitaminb += __nutrition.vitaminb * i.metricamount
            vitamind += __nutrition.vitamind * i.metricamount
    return JsonResponse(json.loads('{"blog":"' + str(_blog.title) + '","blogid":' + str(_blog.id) + ',"calorie":' + str(calorie) + ',"vitamind":' + str(vitamind) + ',"vitaminb":' + str(vitaminb) + ',"vitamina":' + str(vitamina) + ',"fiber":' + str(fiber) + ',"sugars":' + str(sugars) + ',"fat":' + str(fat) + ',"sodium":' + str(sodium) + ',"calcium":' + str(calcium) + ',"protein":' + str(protein) + ',"iron":' + str(iron) + ',"carbonhydrates":' + str(carbonhydrates) + '}'), safe=False)


@api_view(['GET'])
def GetCommentList(request):
    list = []
    _user = User.objects.all()
    _list = comment.objects.filter(blog=request.GET.get('blog'))
    for i in _list:
        __user = _user.filter(id=i.user).first()
        list.append({"id": i.id, "name": __user.first_name, "lastname": __user.last_name,
                    "userid": __user.id, "blogid": i.blog, "text": i.text})
    return JsonResponse(list, safe=False)


@api_view(['POST'])
def CreateComment(request):
    _id = request.data.get('id')
    if _id is None:
        _comment = comment.objects.create(user=request.data.get(
            'user'), blog=request.data.get('blog'), text=request.data.get('text'))
    else:
        _comment = comment.objects.filter(id=_id).first()
        if _comment is None:
            return JsonResponse("id not found", safe=False)
        _comment.user = request.data.get('user')
        _comment.blog = request.data.get('blog')
        _comment.text = request.data.get('text')
        _comment.save()
        return JsonResponse(_comment.id, safe=False)

    return JsonResponse(_comment.id, safe=False)


@api_view(['POST'])
# @authentication_classes([])
# @permission_classes([])
def Login(request):
    username = request.data.get('user')
    password = request.data.get('pass')
    user = authenticate(username=username, password=password)
    if user is not None:
        return JsonResponse(json.loads('{"token":"' + base64.b64encode(bytes(username + ":" + password, 'utf-8')).decode('utf-8') + '", "id":' + str(user.id) + ',"name":"' + user.username + '"}'), safe=False)
    return JsonResponse("Wrong User or Password", safe=False, status=401)


# NEW VIEWS
# ---------------------------------------------------------------------------------------

@api_view(['GET'])
def bookmark_toggle(request):
    try:
        user_id = request.GET.get('user_id')
        user = get_object_or_404(User, pk=user_id)
        blog_id = request.GET.get('blog_id')
        blog_ = get_object_or_404(blog, pk=blog_id)

        user_bookmark = UserBookmark.objects.filter(user=user, blog=blog_)

        if user_bookmark.exists():
            user_bookmark.delete()
            is_bookmarked = False
            message = "Bookmark deleted"
        else:
            UserBookmark.objects.create(user=user, blog=blog_)
            is_bookmarked = True
            message = "Bookmark created"

        bookmark_data = {
            "success": True,
            "is_bookmarked": is_bookmarked,
            "message": message
        }
        return Response(bookmark_data)
    except Exception as e:
        error_message = f"Error toggling bookmark: {str(e)}"
        return Response({"success": False, "error": error_message})


@api_view(['GET'])
def recommend_items(request):
    user_id = request.GET.get('user_id')
    request.user = User.objects.get(id=user_id)
    recommendations = get_recommendations(request.user)
    recommendationSerializer = blogSerializer(recommendations, many=True)
    return Response(recommendationSerializer.data)


@api_view(['GET'])
def add_rating(request):
    try:
        user_id = request.GET.get('user_id')
        user = get_object_or_404(User, pk=user_id)
        recipe_id = request.GET.get('recipe_id')
        recipe = get_object_or_404(blog, pk=recipe_id)
        value = request.GET.get('value')

        # Check if the user has already rated the recipe
        existing_rating = UserRating.objects.filter(
            user=user, recipe=recipe).first()

        if existing_rating:
            # Update the existing rating
            existing_rating.value = value
            existing_rating.save()
        else:
            # Create a new rating
            UserRating.objects.create(user=user, recipe=recipe, value=value)

        # Recalculate the average rating
        recipe.calculate_avg_rating()

        return Response({'avg_rating': recipe.avg_rating, 'success': True})
    except Exception as e:
        print(f"Error submitting rating: {e}")
        return Response({"success": False, "error": str(e)})



def GetNutritionOfSingleRecipe(eaten_recipe_Id, eatenServing):
    _nutrition = nutrition.objects.all()
    _recipe = recipe.objects.filter(blog=eaten_recipe_Id)
    calorie = 0
    fat = 0
    sodium = 0
    calcium = 0
    protein = 0
    iron = 0
    carbonhydrates = 0
    sugars = 0
    fiber = 0
    vitamina = 0
    vitaminb = 0
    vitamind = 0
    for i in _recipe:
        __nutrition = _nutrition.filter(food=i.food).first()
        if __nutrition:
            calorie += __nutrition.calorie * i.metricamount
            fat += __nutrition.fat * i.metricamount
            sodium += __nutrition.sodium * i.metricamount
            calcium += __nutrition.calcium * i.metricamount
            protein += __nutrition.protein * i.metricamount
            iron += __nutrition.iron * i.metricamount
            carbonhydrates += __nutrition.carbonhydrates * i.metricamount
            sugars += __nutrition.sugars * i.metricamount
            fiber += __nutrition.fiber * i.metricamount
            vitamina += __nutrition.vitamina * i.metricamount
            vitaminb += __nutrition.vitaminb * i.metricamount
            vitamind += __nutrition.vitamind * i.metricamount
    calorie = (calorie/_recipe.servings)*eatenServing
    fat = (fat/_recipe.servings)*eatenServing
    sodium = (sodium/_recipe.servings)*eatenServing
    calcium = (calcium/_recipe.servings)*eatenServing
    protein = (protein/_recipe.servings)*eatenServing
    iron = (iron/_recipe.servings)*eatenServing
    carbonhydrates = (carbonhydrates/_recipe.servings)*eatenServing
    sugars = (sugars/_recipe.servings)*eatenServing
    fiber = (fiber/_recipe.servings)*eatenServing
    vitamina = (vitamina/_recipe.servings)*eatenServing
    vitaminb = (vitaminb/_recipe.servings)*eatenServing
    vitamind = (vitamind/_recipe.servings)*eatenServing
    return [calorie, fat, sodium, calcium, protein, iron, carbonhydrates, sugars, fiber, vitamina, vitaminb, vitamind]


def GetNutritionsOfRecipeList(eaten):
    calorie = 0
    fat = 0
    sodium = 0
    calcium = 0
    protein = 0
    iron = 0
    carbonhydrates = 0
    sugars = 0
    fiber = 0
    vitamina = 0
    vitaminb = 0
    vitamind = 0
    for recipe in eaten:
        nutritionList = GetNutritionOfSingleRecipe(
            recipe.blogId, recipe.eaten_serving)
        calorie += nutritionList[0]
        fat += nutritionList[1]
        sodium += nutritionList[2]
        calcium += nutritionList[3]
        protein += nutritionList[4]
        iron += nutritionList[5]
        carbonhydrates += nutritionList[6]
        sugars += nutritionList[7]
        fiber += nutritionList[8]
        vitamina += nutritionList[9]
        vitaminb += nutritionList[10]
        vitamind += nutritionList[11]
    return [calorie, fat, sodium, calcium, protein, iron, carbonhydrates, sugars, fiber, vitamina, vitaminb, vitamind]



@api_view(['GET'])
def GetNutritionDaily(request):
    requestedDate = request.GET.get('date')
    user = request.GET.get('user')
    eaten = Eaten.objects.filter(userId=user, date=requestedDate)
    calorie = 0
    fat = 0
    sodium = 0
    calcium = 0
    protein = 0
    iron = 0
    carbonhydrates = 0
    sugars = 0
    fiber = 0
    vitamina = 0
    vitaminb = 0
    vitamind = 0
    nutritionList = GetNutritionsOfRecipeList(eaten)
    calorie += nutritionList[0]
    fat += nutritionList[1]
    sodium += nutritionList[2]
    calcium += nutritionList[3]
    protein += nutritionList[4]
    iron += nutritionList[5]
    carbonhydrates += nutritionList[6]
    sugars += nutritionList[7]
    fiber += nutritionList[8]
    vitamina += nutritionList[9]
    vitaminb += nutritionList[10]
    vitamind += nutritionList[11]
    return JsonResponse(json.loads('{"calorie":' + str(calorie) + ',"vitamind":' + str(vitamind) + ',"vitaminb":' + str(vitaminb) + ',"vitamina":' + str(vitamina) + ',"fiber":' + str(fiber) + ',"sugars":' + str(sugars) + ',"fat":' + str(fat) + ',"sodium":' + str(sodium) + ',"calcium":' + str(calcium) + ',"protein":' + str(protein) + ',"iron":' + str(iron) + ',"carbonhydrates":' + str(carbonhydrates) + '}'),safe=False)


class UserProfileView(views.APIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer


class InputFoodView(views.APIView):
    queryset = InputFood.objects.all()
    serializer_class = InputFoodSerializer


class RegisterAPIView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, format=None):
        fixed_data = {
            "username": request.data.get('user'),
            "email": request.data.get('mail'),
            "password": request.data.get('pass'),
        }
        serializer = UserSerializer(data=fixed_data)
        print(request.data)

        if serializer.is_valid():
            user = serializer.save()
            if user:
                return Response({"message": "Kullanıcı oluşturuldu", "user_id": user.id}, status=status.HTTP_201_CREATED)
            else:
                return Response({"message": "Kullanıcı oluşturulamadı"}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AllergyView(views.APIView):
    serializer_class = AllergySerializer

    def post(self, request, *args, **kwargs):
        user_id = request.data.get('user_id')
        food_ids = request.data.get('food_ids')
        user = User.objects.get(id=user_id)

        allergies = []
        for food_id in food_ids:
            foods = food.objects.get(id=food_id)
            allergy = Allergy(user=user, food=foods)
            allergies.append(allergy)

        Allergy.objects.bulk_create(allergies)
        return Response({"message": "Allergies saved successfully"}, status=status.HTTP_201_CREATED)