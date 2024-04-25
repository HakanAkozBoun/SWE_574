from django.utils import timezone
import json

from .models import Eaten, blog, category, food, recipe, unit, unittype, unititem, unitconversion, nutrition, Follower, comment, UserBookmark, UserRating, UserProfile, InputFood
from .serializers import blogSerializer, categorySerializer, UserProfileSerializer, InputFoodSerializer

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
def GetFollowingUserList(request):

    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)

    following_users = Follower.objects.filter(
        follower_user=request.user).select_related('following_user')

    user_list = [{
        'id': follow.following_user.id,
        'username': follow.following_user.username,
        # user modele karar vermemiz lazım
        # 'description': follow.following_user.description,
        # 'image': follow.following_user.image
    } for follow in following_users]

    return JsonResponse(user_list, safe=False)


@api_view(['GET'])
def GetBookmarkedRecipes(request):

   # if not request.user.is_authenticated:
    #    return JsonResponse({'error': 'Authentication required'}, status=401)
    user = get_object_or_404(User, pk=1)
   # bookmarks = UserBookmark.objects.filter(
    #    user=request.user).select_related('blog')
    bookmarks = UserBookmark.objects.filter(user=user).select_related('blog')

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
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Authentication required'}, status=401)

    self_recipes = recipe.objects.filter(user=request.user)

    recipes_list = [{
        'id': recipe.id,
        'food': recipe.food,
        'unit': recipe.unit,
        'amount': recipe.amount,
        'blog': recipe.blog,
        'metricamount': recipe.metricamount,
        'metricunit': recipe.metricunit
    } for recipe in self_recipes]

    return JsonResponse(recipes_list, safe=False)


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
def GetCurrentUserProfile(request):
    return JsonResponse(model_to_dict(UserProfile.objects.get(id=1)), safe=False)
    # return JsonResponse(model_to_dict(UserProfile.objects.get(id=request.GET.get('id'))), safe=False)


@api_view(['GET'])
def GetCategoryList(request):
    all_users = category.objects.all().values("id", "name", "image")
    user_list = list(all_users)
    return JsonResponse(user_list, safe=False)


@api_view(['POST'])
def CreateUser(request):
    _id = request.data.get('id')
    if _id is None:
        User.objects.create_user(username=request.data.get('user'), email=request.data.get(
            'mail'), first_name="hakan", last_name="akoz", password=request.data.get('pass'))
    else:
        user = User.objects.get(id=request.data.get('id'))
        if user is None:
            return JsonResponse("id not found", safe=False)
        user.username = request.data.get('user')
        user.email = request.data.get('mail')
        user.save()
    return JsonResponse("OK", safe=False)


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
    file_name = default_storage.save('image\\' + file.name, file)
    return JsonResponse(file_name, safe=False)


@api_view(['POST'])
def CreateBlog(request):
    _id = request.data.get('id')
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
    return JsonResponse("Wrong User or Password", safe=False)


# NEW VIEWS
# ---------------------------------------------------------------------------------------

@api_view(['POST'])
def bookmark_toggle(request):
    try:
        # user = request.user
        user = get_object_or_404(User, pk=3)
        blog_id = request.data.get('id')
        blog_ = get_object_or_404(blog, pk=blog_id)
        print(blog_)

        user_bookmark = UserBookmark.objects.filter(user=user, blog=blog_)

        if user_bookmark.exists():
            user_bookmark.delete()
            is_bookmarked = False
            message = "Bookmark deleted successfully"
        else:
            UserBookmark.objects.create(user=user, blog=blog_)
            is_bookmarked = True
            message = "Bookmark created successfully"

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
    request.user = User.objects.get(id=3)
    recommendations = get_recommendations(request.user)
    recommendationSerializer = blogSerializer(recommendations, many=True)
    return Response(recommendationSerializer.data)


@api_view(['POST'])
def add_rating(request):
    try:
        # Load JSON data from the request body
        data = json.loads(request.body.decode('utf-8'))
        print("data", data)
        user_id = request.user.id
        user = get_object_or_404(User, pk=3)
        recipe_id = data.get('recipe_id')
        recipe = get_object_or_404(blog, pk=2)
        value = data.get('value')

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


@api_view(['GET'])
def GetNutritionDaily(request):
    today = timezone.now().date()
    _eaten = Eaten.objects.filter(userId=request.GET.get(
        'user'), date=request.GET.get(eatenDate=today))
    _calorie = 0
    _fat = 0
    _sodium = 0
    _calcium = 0
    _protein = 0
    _iron = 0
    _carbonhydrates = 0
    _sugars = 0
    _fiber = 0
    _vitamina = 0
    _vitaminb = 0
    _vitamind = 0
    for singleRecipe in _eaten:
        _blog = blog.objects.get(id=singleRecipe.blogId)
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
        _calorie += (calorie * singleRecipe.eatenPercentage)/100
        _fat += (fat * singleRecipe.eatenPercentage)/100
        _sodium += (sodium * singleRecipe.eatenPercentage)/100
        _calcium += (calcium * singleRecipe.eatenPercentage)/100
        _protein += (protein * singleRecipe.eatenPercentage)/100
        _iron += (iron * singleRecipe.eatenPercentage)/100
        _carbonhydrates += (carbonhydrates * singleRecipe.eatenPercentage)/100
        _sugars += (sugars * singleRecipe.eatenPercentage)/100
        _fiber += (fiber * singleRecipe.eatenPercentage)/100
        _vitamina += (vitamina * singleRecipe.eatenPercentage)/100
        _vitaminb += (vitaminb * singleRecipe.eatenPercentage)/100
        _vitamind += (vitamind * singleRecipe.eatenPercentage)/100
        return JsonResponse(json.loads('{"Date":"' + str(today) +
                                       ',"calorie":' + str(_calorie) +
                                       ',"vitamind":' + str(_vitamind) +
                                       ',"vitaminb":' + str(_vitaminb) +
                                       ',"vitamina":' + str(_vitamina) +
                                       ',"fiber":' + str(_fiber) +
                                       ',"sugars":' + str(_sugars) +
                                       ',"fat":' + str(_fat) +
                                       ',"sodium":' + str(_sodium) +
                                       ',"calcium":' + str(_calcium) +
                                       ',"protein":' + str(_protein) +
                                       ',"iron":' + str(_iron) +
                                       ',"carbonhydrates":' + str(_carbonhydrates) +
                                       '}'), safe=False)


class UserProfileView(views.APIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer


class InputFoodView(views.APIView):
    queryset = InputFood.objects.all()
    serializer_class = InputFoodSerializer
