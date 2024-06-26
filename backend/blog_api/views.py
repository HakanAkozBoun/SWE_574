from django.utils import timezone
import json

from .models import blog, category, food, recipe, unit, unittype, unititem, unitconversion, nutrition, Follower, comment, UserBookmark, UserRating, UserProfile, InputFood, Eaten, image, Goal
from .serializers import GoalSerializer, UserForProfileFrontEndSerializer, blogSerializer, categorySerializer, UserProfileSerializer, InputFoodSerializer, UserSerializer, AllergySerializer, UserProfileForFrontEndSerializer, SearchSerializer

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
from django.utils import timezone


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


# class PopularPostsApiView(viewsets.ViewSet):
#     def list(self, request, pk=None):
#         queryset = blog.objects.filter(
#             postlabel__iexact='POPULAR').order_by('-id')[0:4]
#         serializer = blogSerializer(queryset, many=True)
#         return Response(serializer.data)

@api_view(['GET'])
def PopularPostsApiView(request):
    all = blog.objects.all().values()
    imagelist = image.objects.filter(
        id__in=all.values_list('image', flat=True))
    response = []
    for blog_ in all:
        json = {'base64': None, 'image': None, 'type': None}
        if blog_.get('image') is not None:
            image_ = imagelist.filter(id=blog_.get('image')).first()
            if image_ is not None:
                json['base64'] = image_.data
                json['image'] = image_.name
                json['type'] = image_.type
        json['id'] = blog_.get('id')
        json['title'] = blog_.get('title')
        json['slug'] = blog_.get('slug')
        json['excerpt'] = blog_.get('excerpt')
        json['content'] = blog_.get('content')
        json['contentTwo'] = blog_.get('contentTwo')
        json['ingredients'] = blog_.get('ingredients')
        json['postlabel'] = blog_.get('postlabel')
        json['category_id'] = blog_.get('category_id')
        json['preparationtime'] = blog_.get('preparationtime')
        json['cookingtime'] = blog_.get('cookingtime')
        json['rate'] = blog_.get('rate')
        json['bookmark'] = blog_.get('bookmark')
        json['avg_rating'] = blog_.get('avg_rating')
        json['userid'] = blog_.get('userid')
        json['serving'] = blog_.get('serving')
        response.append(json)
    return JsonResponse(response, safe=False)


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

    user_id = request.query_params.get('id', '1')
    bookmarks = UserBookmark.objects.filter(
        user=user_id).select_related('blog')

    bookmarked_recipes_list = [{
        'id': bookmark.blog.id,
        'title': bookmark.blog.title,

    } for bookmark in bookmarks]

    return JsonResponse(bookmarked_recipes_list, safe=False)


@api_view(['GET'])
def GetSelfRecipes(request):

    user_id = request.query_params.get('id', '1')

    queryset = blog.objects.filter(userid=user_id)
    # serializer = blogSerializer(queryset, many=True)
    # return Response(serializer.data)
    my_recipes_list = [{
        'id': recipe.id,
        'title': recipe.title,

    } for recipe in queryset]

    return JsonResponse(my_recipes_list, safe=False)


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


@api_view(['GET'])
def check_following(request):
    logged_in_user_id = request.GET.get('logged_in_user_id', None)
    other_user_id = request.GET.get('other_user_id', None)
    logged_in_user = User.objects.get(id=logged_in_user_id)
    other_user = User.objects.get(id=other_user_id)
    exists = Follower.objects.filter(
        follower_user=logged_in_user, following_user=other_user).exists()
    if (exists):
        return JsonResponse({'exists': True})
    else:
        return JsonResponse({'exists': False})


@api_view(['GET'])
def FollowUser(request):
    logged_in_user_id = request.GET.get('logged_in_user_id', None)
    other_user_id = request.GET.get('other_user_id', None)
    try:
        logged_in_user = User.objects.get(id=logged_in_user_id)
        other_user = User.objects.get(id=other_user_id)
        isSuccess = False
        exists = Follower.objects.filter(
            follower_user=logged_in_user, following_user=other_user).exists()

        if exists == False:
            Follower.objects.create(
                follower_user=logged_in_user, following_user=other_user)
            exists = Follower.objects.filter(
                follower_user=logged_in_user, following_user=other_user).exists()

        isSuccess = exists
    except User.DoesNotExist:
        isSuccess = False
    return JsonResponse({'followed': isSuccess})


@api_view(['GET'])
def UnfollowUser(request):
    logged_in_user_id = request.GET.get('logged_in_user_id', None)
    other_user_id = request.GET.get('other_user_id', None)
    isSuccess = False
    try:
        logged_in_user = User.objects.get(id=logged_in_user_id)
        other_user = User.objects.get(id=other_user_id)

        exists = Follower.objects.filter(
            follower_user=logged_in_user, following_user=other_user).exists()

        if exists:
            Follower.objects.filter(
                follower_user=logged_in_user, following_user=other_user).delete()
            exists = Follower.objects.filter(
                follower_user=logged_in_user, following_user=other_user).exists()

        isSuccess = not exists

    except User.DoesNotExist:
        isSuccess = False

    return JsonResponse({'unfollowed': isSuccess})


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
    imagelist = image.objects.filter(
        id__in=all.values_list('image', flat=True))
    response = []
    for category_ in all:
        json = {'base64': None, 'image': None, 'type': None}
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
    image_ = image.objects.create(name=file.name, data=base64.b64encode(
        file.read()).decode('ascii'), type=file.content_type)
    return JsonResponse({'id': image_.id, 'name': image_.name}, safe=False)


@api_view(['POST'])
def CreateBlog(request):
    # EE user id None olarak sabitlendi
    _id = request.data.get('id')
    # _id = None
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


def CalculateGoals(age, gender):
    calorie = CalculateGoalCalorie(age, gender)
    fat = CalculateGoalFat(age, gender)
    sodium = CalculateGoalSodium()
    calcium = CalculateGoalCalcium(age, gender)
    protein = CalculateGoalProtein(age, gender)
    iron = CalculateGoalIron(age, gender)
    carbonhydrates = CalculateGoalCarbonhydrates()
    sugars = CalculateGoalSugars(gender)
    fiber = CalculateGoalFiber()
    vitamina = CalculateGoalVitamina(age, gender)
    vitaminb = CalculateGoalVitaminb(gender)
    vitamind = CalculateGoalVitamind(age)
    return calorie, fat, sodium, calcium, protein, iron, carbonhydrates, sugars, fiber, vitamina, vitaminb, vitamind


def CalculateGoalCalorie(age, gender):
    # https://www.healthline.com/nutrition/how-many-calories-per-day#average-needs
    necessaryCalorieIntake = 0
    if (gender == "M" or "m"):
        if (age <= 3):
            necessaryCalorieIntake = 1300
        elif (age > 3 and age <= 8):
            necessaryCalorieIntake = 1600
        elif (age > 8 and age <= 13):
            necessaryCalorieIntake = 2100
        elif (age > 13 and age <= 18):
            necessaryCalorieIntake = 2600
        elif (age > 18 and age <= 30):
            necessaryCalorieIntake = 2700
        elif (age > 30 and age <= 50):
            necessaryCalorieIntake = 2600
        elif (age > 50):
            necessaryCalorieIntake = 2300
    elif (gender == "F" or "f"):
        if (age <= 3):
            necessaryCalorieIntake = 1200
        elif (age > 3 and age <= 8):
            necessaryCalorieIntake = 1500
        elif (age > 8 and age <= 13):
            necessaryCalorieIntake = 1800
        elif (age > 13 and age <= 18):
            necessaryCalorieIntake = 2100
        elif (age > 18 and age <= 30):
            necessaryCalorieIntake = 2200
        elif (age > 30 and age <= 50):
            necessaryCalorieIntake = 1900
        elif (age > 50):
            necessaryCalorieIntake = 1900

    return necessaryCalorieIntake


def CalculateGoalFat(age, gender):
    # https://www.calculator.net/fat-intake-calculator.html
    # https://www.verywellhealth.com/how-many-grams-of-fat-per-day-8421874#:~:text=For%20most%20people%2C%20it%20is,and%20omega-6%20polyunsaturated%20fats.
    necessaryFatIntake = 0
    if (age <= 3):
        necessaryFatIntake = 30
    elif (age > 3 and age <= 8):
        if (gender == "M" or "m"):
            necessaryFatIntake = 46
        elif (gender == "F" or "f"):
            necessaryFatIntake = 40
    elif (age > 8 and age <= 13):
        if (gender == "M" or "m"):
            necessaryFatIntake = 60
        elif (gender == "F" or "f"):
            necessaryFatIntake = 53
    elif (age > 13):
        if (gender == "M" or "m"):
            necessaryFatIntake = 69
        elif (gender == "F" or "f"):
            necessaryFatIntake = 60
    return necessaryFatIntake


def CalculateGoalSodium():
    # https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/sodium/sodium-and-salt
    necessarySodiumIntake = 500
    return necessarySodiumIntake


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


def CalculateGoalProtein(age, gender):
    # https://www.calculator.net/protein-calculator.html
    necessaryProteinIntake = 0
    if (age <= 3):
        necessaryProteinIntake = 13
    elif (age > 3 and age <= 8):
        necessaryProteinIntake = 19
    elif (age > 8 and age <= 13):
        necessaryProteinIntake = 34
    elif (age > 13 and age <= 18):
        if (gender == "M" or "m"):
            necessaryProteinIntake = 52
        elif (gender == "F" or "f"):
            necessaryProteinIntake = 46
    elif (age > 19):
        if (gender == "M" or "m"):
            necessaryProteinIntake = 56
        elif (gender == "F" or "f"):
            necessaryProteinIntake = 46
    return necessaryProteinIntake


def CalculateGoalIron(age, gender):
    # https://ods.od.nih.gov/factsheets/Iron-Consumer/
    necessaryIronIntake = 0
    if (age <= 3):
        necessaryIronIntake = 7
    elif (age > 3 and age <= 8):
        necessaryIronIntake = 10
    elif (age > 8 and age <= 13):
        necessaryIronIntake = 8
    elif (age > 13 and age <= 18):
        if (gender == "M" or "m"):
            necessaryIronIntake = 11
        else:
            necessaryIronIntake = 15
    elif (age > 18 and age <= 50):
        if (gender == "M" or "m"):
            necessaryIronIntake = 8
        else:
            necessaryIronIntake = 18
    elif (age > 50):
        necessaryIronIntake = 8
    return necessaryIronIntake


def CalculateGoalCarbonhydrates():
    # https://www.medicalnewstoday.com/articles/318617#amount
    # (325+225) / 2 = 275
    necessaryCarbonhydrateIntake = 275
    return necessaryCarbonhydrateIntake


def CalculateGoalSugars(gender):
    # https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/sugar/how-much-sugar-is-too-much#:~:text=Men%20should%20consume%20no%20more,day%27s%20allotment%20in%20one%20slurp.
    necessarySugarIntake = 0
    if (gender == "M" or "m"):
        necessarySugarIntake = 36
    elif (gender == "F" or "f"):
        necessarySugarIntake = 25
    return necessarySugarIntake


def CalculateGoalFiber():
    # https://www.ucsfhealth.org/education/increasing-fiber-intake#:~:text=Although%20there%20is%20no%20dietary,day%20—%20coming%20from%20soluble%20fiber.
    necessaryFiberIntake = 28
    return necessaryFiberIntake


def CalculateGoalVitamina(age, gender):
    # https://ods.od.nih.gov/factsheets/VitaminA-HealthProfessional/
    # IU
    necessaryVitaminaIntake = 0
    if (age <= 3):
        necessaryVitaminaIntake = 300
    elif (age > 3 and age <= 8):
        necessaryVitaminaIntake = 400
    elif (age > 8 and age <= 13):
        necessaryVitaminaIntake = 600
    elif (age > 13):
        if (gender == "M" or "m"):
            necessaryVitaminaIntake = 900
        elif (gender == "F" or "f"):
            necessaryVitaminaIntake = 700
    necessaryVitaminaIntake = (necessaryVitaminaIntake/3)*10
    # mcg RAE to IU
    return necessaryVitaminaIntake


def CalculateGoalVitaminb(gender):
    # https://www.medicalnewstoday.com/articles/324856#dosage
    # b1
    necessaryVitaminbIntake = 0
    if (gender == "M" or "m"):
        necessaryVitaminbIntake = 1.2
    elif (gender == "F" or "f"):
        necessaryVitaminbIntake = 1.1
    return necessaryVitaminbIntake


def CalculateGoalVitamind(age):
    # https://ods.od.nih.gov/factsheets/VitaminD-HealthProfessional/
    necessaryVitamindIntake = 0
    if (age < 70):
        necessaryVitamindIntake = 600
    else:
        necessaryVitamindIntake = 800

    return necessaryVitamindIntake


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
def bookmark_exist(request):
    user_id = request.GET.get('user_id')
    user = get_object_or_404(User, pk=user_id)
    blog_id = request.GET.get('blog_id')
    blog_ = get_object_or_404(blog, pk=blog_id)
    user_bookmark = UserBookmark.objects.filter(user=user, blog=blog_)
    if user_bookmark.exists():
        return Response({"is_bookmarked": True})
    return Response({"is_bookmarked": False})


@api_view(['GET'])
def eaten_toggle(request):
    try:
        user_id = request.GET.get('user_id')
        user = get_object_or_404(User, pk=user_id)
        blog_id = request.GET.get('blog_id')
        blog_ = get_object_or_404(blog, pk=blog_id)
        serving = float(request.GET.get('serving'))
        current_date = timezone.datetime.today().date()

        # Check if an Eaten entry exists for the user, blog, and current date
        user_eaten = Eaten.objects.filter(
            userId=user, blogId=blog_, eatenDate=current_date)

        if user_eaten.exists():
            eaten_entry = user_eaten.first()
            if eaten_entry.eaten_serving == serving:
                user_eaten.delete()
                is_eaten = False
            else:
                eaten_entry.eaten_serving = serving
                eaten_entry.save()
                is_eaten = True
        else:
            Eaten.objects.create(userId=user, blogId=blog_,
                                 eaten_serving=serving, eatenDate=current_date)
            is_eaten = True

        eaten_data = {
            "success": True,
            "is_eaten": is_eaten,
        }
        return Response(eaten_data)
    except Exception as e:
        error_message = f"Error toggling eaten: {str(e)}"
        return Response({"success": False, "error": error_message})


@api_view(['GET'])
def eaten_exist(request):
    user_id = request.GET.get('user_id')
    user = get_object_or_404(User, pk=user_id)
    blog_id = request.GET.get('blog_id')
    blog_ = get_object_or_404(blog, pk=blog_id)
    user_eaten = Eaten.objects.filter(userId=user, blogId=blog_)
    if user_eaten.exists():
        return Response({"is_eaten": True, "serving": user_eaten.first().eaten_serving})
    return Response({"is_eaten": False})


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


@api_view(['PATCH'])
def UpdateGoal(request):
    user_id = request.GET.get('id', '1')
    goalName = request.data.get('goal_name')
    amount = request.data.get('amount')
    user = User.objects.get(id=user_id)
    goal = Goal.objects.get(user=user, goal_nutrition=goalName)
    goal.goal_amount = amount
    goal.save()
    return JsonResponse(True, safe=False)


@api_view(['POST'])
def CreateGoal(request):
    user_id = request.GET.get('id', '1')
    user = User.objects.get(id=user_id)
    goalName = request.data.get('goal_name')
    amount = request.data.get('amount')
    goal = Goal.objects.create(
        user=user, goal_nutrition=goalName, goal_amount=amount)
    goal.save()
    return JsonResponse(True, safe=False)


@api_view(['GET'])
def GetAverageGoals(request):
    user_id = request.query_params.get('id', '1')
    userProfile = UserProfile.objects.get(id=user_id)
    if (userProfile.age is None or userProfile.gender is None):
        return JsonResponse({"message": "You must enter age and gender first."}, safe=False)
    goals = CalculateGoals(userProfile.age, userProfile.gender)
    formattedGoals = {
        "calorie": goals[0],
        "fat": goals[1],
        "sodium": goals[2],
        "calcium": goals[3],
        "protein": goals[4],
        "iron": goals[5],
        "carbonhydrates": goals[6],
        "sugars": goals[7],
        "fiber": goals[8],
        "vitamina": goals[9],
        "vitaminb": goals[10],
        "vitamind": goals[11]
    }
    return JsonResponse(formattedGoals, safe=False)


@api_view(['GET'])
def GetGoals(request):
    user_id = request.GET.get('user_id')
    goals = Goals(user_id)
    if (not goals.exists()):
        return JsonResponse({"message": "No goals found."}, safe=False)

    serializer = GoalSerializer(goals, many=True)
    return Response(serializer.data)


def Goals(userId):
    user = User.objects.get(id=userId)
    goals = Goal.objects.filter(user=user)
    return goals


def GetNutritionOfSingleRecipe(eaten_recipe_Id, eatenServing):
    _nutrition = nutrition.objects.all()
    _recipe = recipe.objects.filter(blog=eaten_recipe_Id)
    _blog = blog.objects.get(id=eaten_recipe_Id)
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
    calorie = (calorie/_blog.serving)*eatenServing
    fat = (fat/_blog.serving)*eatenServing
    sodium = (sodium/_blog.serving)*eatenServing
    calcium = (calcium/_blog.serving)*eatenServing
    protein = (protein/_blog.serving)*eatenServing
    iron = (iron/_blog.serving)*eatenServing
    carbonhydrates = (carbonhydrates/_blog.serving)*eatenServing
    sugars = (sugars/_blog.serving)*eatenServing
    fiber = (fiber/_blog.serving)*eatenServing
    vitamina = (vitamina/_blog.serving)*eatenServing
    vitaminb = (vitaminb/_blog.serving)*eatenServing
    vitamind = (vitamind/_blog.serving)*eatenServing
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
            recipe.blogId_id, recipe.eaten_serving)
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


def NutritionDaily(user, date):
    eaten = Eaten.objects.filter(userId=user, eatenDate=date)
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
    return [calorie, fat, sodium, calcium, protein, iron, carbonhydrates, sugars, fiber, vitamina, vitaminb, vitamind]


def NutritionDailyWithGoals(requestedDate, user):
    nutritionList = NutritionDaily(user, requestedDate)
    NutritionNameList = ["calorie", "fat", "sodium", "calcium", "protein", "iron",
                         "carbonhydrates", "sugars", "fiber", "vitamina", "vitaminb", "vitamind"]
    nutritionUnitList = ["(kcal)", "(g)",  "(mg)", "(mg)", "(g)",
                         "(mg)", "(g)", "(g)", "(g)", "(IU)", "(mg)", "(IU)"]
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
    goals = Goals(user)
    goals_list = []

    for g in goals:
        index = NutritionNameList.index(g.goal_nutrition)
        if g.goal_nutrition in NutritionNameList:
            rounded_intake = round(nutritionList[index], 2)
            goal_info = {
                "nutritionName": g.goal_nutrition + " " + nutritionUnitList[index],
                "goal": g.goal_amount,
                "currentIntake": rounded_intake
            }
        goals_list.append(goal_info)

    return goals_list


@api_view(['GET'])
def GetWeeklyNutritions(request):
    user = request.GET.get('user')
    eatenNutritionsNameSet = WeeklyNutritionNames(user)
    eatenNutritionsNameList = list(eatenNutritionsNameSet)

    return JsonResponse(eatenNutritionsNameList, safe=False)


def WeeklyNutritionNames(user):
    current_datetime = timezone.now()
    current_date = current_datetime.date()
    last_week_date = current_date - timezone.timedelta(days=7)
    eatenNutritionsNameList = []
    for i in range(7):
        eaten_date = last_week_date + timezone.timedelta(days=i)
        singleDayNutritionList = DailyNutritionNames(user, eaten_date)
        eatenNutritionsNameList.extend(singleDayNutritionList)
    eatenNutritionsNameSet = set(eatenNutritionsNameList)
    return eatenNutritionsNameSet


def DailyNutritionNames(user, date):
    nutritionNamesList = ['calorie', 'fat', 'sodium', 'calcium', 'protein', 'iron',
                          'carbonhydrates', 'sugars', 'fiber', 'vitamina', 'vitaminb', 'vitamind']
    nutritionAmountList = NutritionDaily(user, date)
    print(nutritionAmountList)
    eatenNutritionList = []
    for index, eatenNutrition in enumerate(nutritionAmountList):
        if eatenNutrition > 0:
            nutritionName = nutritionNamesList[index]
            eatenNutritionList.append(nutritionName)
    return eatenNutritionList


def NutritionWeeklyWithGoal(user, goalName, goalAmount):
    current_datetime = timezone.now()
    current_date = current_datetime.date()
    last_week_date = current_date - timezone.timedelta(days=7)
    NutritionNameList = ["calorie", "fat", "sodium", "calcium", "protein", "iron",
                         "carbonhydrates", "sugars", "fiber", "vitamina", "vitaminb", "vitamind"]
    goals_list = []
    for i in range(7):
        eaten_date = last_week_date + timezone.timedelta(days=i)
        nutritionList = NutritionDaily(user, eaten_date)
        if goalName in NutritionNameList:
            rounded_intake = round(
                nutritionList[NutritionNameList.index(goalName)], 2)
            goal_info = {
                "date": eaten_date.isoformat(),
                "goal": goalAmount,
                "currentIntake": rounded_intake
            }

            goals_list.append(goal_info)
    return goals_list


@api_view(['GET'])
def GetNutritionWeeklyWithGoal(request):
    requestedGoal = request.query_params.get('selected_nutrition')
    user = request.GET.get('user')
    goal = Goal.objects.get(user=user, goal_nutrition=requestedGoal)
    goal_amount = goal.goal_amount
    goals_list = NutritionWeeklyWithGoal(
        user=user, goalName=requestedGoal, goalAmount=goal_amount)
    if (goals_list == []):
        return JsonResponse({"message": "No goals found."}, safe=False)

    return JsonResponse(goals_list, safe=False)


@api_view(['GET'])
def GetNutritionDailyWithGoals(request):
    requestedDate = request.query_params.get('selected_date')
    user = request.GET.get('user')
    _nutritionDailyWithGoals = NutritionDailyWithGoals(requestedDate, user)
    if (not _nutritionDailyWithGoals):
        return JsonResponse({"message": "No goals found."}, safe=False)

    return JsonResponse(_nutritionDailyWithGoals, safe=False)


@api_view(['GET'])
def GetNutritionDaily(request):
    requestedDate = request.query_params.get('selected_date')
    user = request.GET.get('user')
    nutritionList = NutritionDaily(user, requestedDate)
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
    return JsonResponse(json.loads('{"calorie":' + str(calorie) + ',"vitamind":' + str(vitamind) + ',"vitaminb":' + str(vitaminb) + ',"vitamina":' + str(vitamina) + ',"fiber":' + str(fiber) + ',"sugars":' + str(sugars) + ',"fat":' + str(fat) + ',"sodium":' + str(sodium) + ',"calcium":' + str(calcium) + ',"protein":' + str(protein) + ',"iron":' + str(iron) + ',"carbonhydrates":' + str(carbonhydrates) + '}'), safe=False)


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

    def get(self, request, *args, **kwargs):
        user_id = request.GET.get('user_id')
        user = User.objects.get(id=user_id)
        allergies = Allergy.objects.filter(user=user)
        serializer = AllergySerializer(allergies, many=True)
        return Response(serializer.data)

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


@api_view(['GET'])
def search_recipes(request):
    query = request.GET.get('query', '')
    user_id = request.GET.get('id')
    print(user_id, "USER ID")
    print(query)

    if user_id is None:
        blogs = blog.objects.filter(title__icontains=query)
    else:
        allergic_foods = Allergy.objects.filter(
            user_id=user_id).values_list('food_id', flat=True)
        allergic_blogs = recipe.objects.filter(
            food__in=allergic_foods).values_list('blog', flat=True)
        blogs = blog.objects \
            .filter(title__icontains=query) \
            .exclude(id__in=allergic_blogs)

    serializer = SearchSerializer(blogs, many=True)
    return JsonResponse(serializer.data, safe=False)
