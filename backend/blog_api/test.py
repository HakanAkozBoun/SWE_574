from django.test import TestCase
from django.core.exceptions import ValidationError
import time

from numpy import rec
from blog_api.models import *
from django.db.utils import IntegrityError

class BasicTest(TestCase):
    def test_entry(self):
        cat=category()
        cat.name="TestCategory"
        cat.save()


        record=category.objects.get(pk=cat.id)
        self.assertEqual(record,cat)

class BlogModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        category.objects.create(name='Test Category')

    def setUp(self):
        self.blog = blog.objects.create(
            category=category.objects.get(name='Test Category'),
            title='Test Title',
            slug='test-title',
            excerpt='Test Excerpt',
            content='Test Content',
            contentTwo='Test Content Two',
            preparationtime='Test Prep Time',
            cookingtime='Test Cooking Time',
            avg_rating=4.5,
            image=1,
            ingredients='Test Ingredients',
            postlabel='POPULAR',
            userid=1,
            serving=4
        )
        self.user = User.objects.create_user(id=1, username='testuser', password='testpassword')

    def test_str_representation(self):
        self.assertEqual(str(self.blog.title), 'Test Title')

    def test_default_avg_rating(self):
        blog_obj = blog.objects.create(
            category=category.objects.get(name='Test Category'),
            title='Another Test Title',
            slug='another-test-title'
        )
        self.assertEqual(blog_obj.avg_rating, 0)

    def test_integer_fields(self):
        self.assertEqual(self.blog.userid, 1)
        self.assertEqual(self.blog.serving, 4)
        self.assertEqual(self.blog.image, 1)

    def test_calculate_avg_rating(self):
        self.blog.calculate_avg_rating()
        self.assertEqual(self.blog.avg_rating, 0)
        
        UserRating.objects.create(user=self.user, recipe=self.blog, value=3)

        self.blog.calculate_avg_rating()
        self.assertEqual(self.blog.avg_rating, 3)

        UserRating.objects.create(user=self.user, recipe=self.blog, value=5)

        self.blog.calculate_avg_rating()
        self.assertEqual(self.blog.avg_rating, 4)


    def test_float_fields(self):
        assert self.blog.avg_rating == 4.5
    
    def test_text_fields(self):
        self.assertEqual(self.blog.title, 'Test Title')
        self.assertEqual(self.blog.slug, 'test-title')
        self.assertEqual(self.blog.excerpt, 'Test Excerpt')
        self.assertEqual(self.blog.content, 'Test Content')
        self.assertEqual(self.blog.contentTwo, 'Test Content Two')
        self.assertEqual(self.blog.preparationtime, 'Test Prep Time')
        self.assertEqual(self.blog.cookingtime, 'Test Cooking Time')
        self.assertEqual(self.blog.ingredients, 'Test Ingredients')
        
class NutritionModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.food1 = food.objects.create(id=2, name="Chicken breast")
        cls.food2 = food.objects.create(id=67, name="Pineapple")
        cls.food3 = food.objects.create(id=151, name="Rice")

        cls.nutrition1 = nutrition.objects.create(
            calorie=1.65,
            fat=0.036,
            sodium=0.74,
            calcium=0.12,
            protein=0.31,
            iron=0.01,
            carbonhydrates=0,
            sugars=0,
            fiber=0,
            vitamina=0.13,
            vitaminb=0.0013,
            vitamind=0,
            food=cls.food1
        )
        cls.nutrition2 = nutrition.objects.create(
            calorie=0.5,
            fat=0.001,
            sodium=0.01,
            calcium=0.13,
            protein=0.005,
            iron=0.003,
            carbonhydrates=0.13,
            sugars=0.1,
            fiber=0.014,
            vitamina=0.47,
            vitaminb=0.00079,
            vitamind=0,
            food=cls.food2
        )
        cls.nutrition3 = nutrition.objects.create(
            calorie=1.3,
            fat=0.003,
            sodium=0.01,
            calcium=0.1,
            protein=0.027,
            iron=0.002,
            carbonhydrates=0.28,
            sugars=0.001,
            fiber=0.004,
            vitamina=0,
            vitaminb=0.00014,
            vitamind=0,
            food=cls.food3
        )

    def test_sum_nutrition_values(self):
        total_calorie = nutrition.objects.aggregate(total_calorie=models.Sum('calorie'))['total_calorie']
        total_fat = nutrition.objects.aggregate(total_fat=models.Sum('fat'))['total_fat']
        total_sodium = nutrition.objects.aggregate(total_sodium=models.Sum('sodium'))['total_sodium']
        total_calcium = nutrition.objects.aggregate(total_calcium=models.Sum('calcium'))['total_calcium']
        total_protein = nutrition.objects.aggregate(total_protein=models.Sum('protein'))['total_protein']
        total_iron = nutrition.objects.aggregate(total_iron=models.Sum('iron'))['total_iron']
        total_carbs = nutrition.objects.aggregate(total_carbs=models.Sum('carbonhydrates'))['total_carbonhydrates']
        total_sugars = nutrition.objects.aggregate(total_sugars=models.Sum('sugars'))['total_sugars']
        total_fiber = nutrition.objects.aggregate(total_fiber=models.Sum('fiber'))['total_fiber']
        total_vitamina = nutrition.objects.aggregate(total_vitamina=models.Sum('vitamina'))['total_vitamina']
        total_vitaminb = nutrition.objects.aggregate(total_vitaminb=models.Sum('vitaminb'))['total_vitaminb']
        total_vitamind = nutrition.objects.aggregate(total_vitamind=models.Sum('vitamind'))['total_vitamind']

        self.assertAlmostEqual(total_calorie, 3.45)
        self.assertAlmostEqual(total_fat, 0.04)
        self.assertAlmostEqual(total_sodium, 0.76)
        self.assertAlmostEqual(total_calcium, 0.35)
        self.assertAlmostEqual(total_protein, 0.342)
        self.assertAlmostEqual(total_iron, 0.015)
        self.assertAlmostEqual(total_carbs, 0.41)
        self.assertAlmostEqual(total_sugars, 0.101)
        self.assertAlmostEqual(total_fiber, 0.018)
        self.assertAlmostEqual(total_vitamina, 0.6)
        self.assertAlmostEqual(total_vitaminb, 0.00223)
        self.assertAlmostEqual(total_vitamind, 0)

class UserProfileModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.user = User.objects.create_user(username='testuser', password='testpassword')

    def setUp(self):
        self.user_profile = UserProfile.objects.create(
            user=self.user,
            age=30,
            weight=70.5,
            height=175.0,
            description='Test description',
            image='test_image.jpg',
            experience=5,
            gender='Male',
            graduated_from='Test University',
            cuisines_of_expertise='Italian, French',
            working_at='Test Restaurant'
        )

    def test_str_representation(self):
        self.assertEqual(str(self.user_profile.user.username), "testuser")

    def test_user_profile_fields(self):
        self.assertEqual(self.user_profile.user, self.user)
        self.assertEqual(self.user_profile.age, 30)
        self.assertEqual(self.user_profile.weight, 70.5)
        self.assertEqual(self.user_profile.height, 175.0)
        self.assertEqual(self.user_profile.description, 'Test description')
        self.assertEqual(self.user_profile.image, 'test_image.jpg')
        self.assertEqual(self.user_profile.experience, 5)
        self.assertEqual(self.user_profile.gender, 'Male')
        self.assertEqual(self.user_profile.graduated_from, 'Test University')
        self.assertEqual(self.user_profile.cuisines_of_expertise, 'Italian, French')
        self.assertEqual(self.user_profile.working_at, 'Test Restaurant')
    
    def test_float_fields(self):
        assert self.user_profile.weight == 70.5
        assert self.user_profile.height == 175.0
    
    def test_text_fields(self):
        self.assertEqual(self.user_profile.description, 'Test description')
        self.assertEqual(self.user_profile.image, 'test_image.jpg')
        self.assertEqual(self.user_profile.graduated_from, 'Test University')
        self.assertEqual(self.user_profile.cuisines_of_expertise, 'Italian, French')
        self.assertEqual(self.user_profile.working_at, 'Test Restaurant')
        self.assertEqual(self.user_profile.user.username, 'testuser')
    
    def test_integer_fields(self):
        self.assertEqual(self.user_profile.age, 30)
        self.assertEqual(self.user_profile.experience, 5)

class AllergyModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.user = User.objects.create_user(username='testuser', password='testpassword')

    def setUp(self):
        self.food = food.objects.create(name='Test Food', unit=1)
        self.allergy = Allergy.objects.create(user=self.user, food=self.food)

    def test_str_representation(self):
        self.assertEqual(str(self.allergy.food.name), 'Test Food')

    def test_allergy_fields(self):
        self.assertEqual(self.allergy.user, self.user)
        self.assertEqual(self.allergy.food, self.food)

class FoodModelTest(TestCase):
    def setUp(self):
        self.food = food.objects.create(name='Test Food', unit=1)

    def test_str_representation(self):
        self.assertEqual(str(self.food.name), 'Test Food')

    def test_food_fields(self):
        self.assertEqual(self.food.name, 'Test Food')
        self.assertEqual(self.food.unit, 1)

class UserRatingModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.user = User.objects.create_user(username='testuser', password='testpassword')
        cls.recipe = blog.objects.create(title='Test Recipe', slug='test-recipe')

    def setUp(self):
        self.user_rating = UserRating.objects.create(user=self.user, recipe=self.recipe, value=4)

    def test_user_rating_fields(self):
        self.assertEqual(self.user_rating.user, self.user)
        self.assertEqual(self.user_rating.recipe, self.recipe)
        self.assertEqual(self.user_rating.value, 4)

    def test_invalid_value_more_than_five(self):
        with self.assertRaises(IntegrityError):
            UserRating.objects.create(user=self.user, recipe=self.recipe, value=6)

    def test_invalid_value_negative(self):
        with self.assertRaises(IntegrityError):
            UserRating.objects.create(user=self.user, recipe=self.recipe, value=-1)

class RecipeDeriveTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.blog = blog.objects.create(id=1)
        cls.recipelist = []

        recipe = {
            'food': 1,
            'unit': 1,
            'blog': 1,
            'metricamount': 1,
            'metricunit': 1,
            'amount': 1,
        }

        cls.recipelist.append(recipe)
        
        cls.parameter = {
            'title': 'hakan',
        }

    def setUp(self):
        for key, value in self.parameter.items():
            setattr(self.blog, key, value)

        self.blognew = blog.objects.create(
            category=self.blog.category,
            title=self.blog.title,
            slug=self.blog.slug,
            excerpt=self.blog.excerpt,
            content=self.blog.content,
            contentTwo=self.blog.contentTwo,
            preparationtime=self.blog.preparationtime,
            cookingtime=self.blog.cookingtime,
            avg_rating=self.blog.avg_rating,
            image=self.blog.image,
            ingredients=self.blog.ingredients,
            postlabel=self.blog.postlabel,
            userid=self.blog.userid,
            serving=self.blog.serving
        )
        
        conversion = unitconversion.objects.all()
        for item in self.recipelist:
            metricamount = item['amount']
            metricunit = item['unit']
            _conversion = conversion.filter(imperial=item['unit']).first()
            if _conversion:
                metricamount /= _conversion.ivalue
                metricunit = _conversion.metric
            recipe.objects.create(
                food=item['food'],
                unit=item['unit'],
                amount=item['amount'],
                blog=self.blognew,
                metricamount=metricamount,
                metricunit=metricunit
            )
 
    def test_blog_fields(self):
        self.assertEqual(self.blognew.category, self.blog.category)
        self.assertEqual(self.blognew.title, self.blog.title)
        self.assertEqual(self.blognew.slug, self.blog.slug)
        self.assertEqual(self.blognew.excerpt, self.blog.excerpt)
        self.assertEqual(self.blognew.content, self.blog.content)
        self.assertEqual(self.blognew.contentTwo, self.blog.contentTwo)
        self.assertEqual(self.blognew.preparationtime, self.blog.preparationtime)
        self.assertEqual(self.blognew.cookingtime, self.blog.cookingtime)
        self.assertEqual(self.blognew.avg_rating, self.blog.avg_rating)
        self.assertEqual(self.blognew.image, self.blog.image)
        self.assertEqual(self.blognew.ingredients, self.blog.ingredients)
        self.assertEqual(self.blognew.postlabel, self.blog.postlabel)
        self.assertEqual(self.blognew.userid, self.blog.userid)
        self.assertEqual(self.blognew.serving, self.blog.serving)


class RecipeCreateTest(TestCase):
    def setUp(self):
        self.blog = blog.objects.create(
            category=1,
            title='Manti',
            slug='manti',
            excerpt='manti',
            content='manti is a Turkish cultural food',
            contentTwo='manti is a Turkish cultural food',
            preparationtime=15,
            cookingtime=20,
            avg_rating=5,
            image=1,
            ingredients='1-meat, 2-flour',
            postlabel=1,
            userid=1,
            serving=1
        )
        self.recipe = recipe.objects.create(
            food=1,
            unit=1,
            amount=1,
            blog=self.blog,
            metricamount=1,
            metricunit=1
        )

    def test_recipe_int_fields(self):
        self.assertEqual(self.recipe.food, 1)
        self.assertEqual(self.recipe.unit, 1)
        self.assertEqual(self.recipe.blog.id, self.blog.id)
        self.assertEqual(self.recipe.metricamount, 1)
        self.assertEqual(self.recipe.metricunit, 1)
    
    def test_recipe_float_fields(self):
        self.assertEqual(self.recipe.amount, 1)


class RecipeEditTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.blog = blog.objects.create(id=1)
        cls.recipe = recipe.objects.create(
            id=1,
            food=1,
            unit=1,
            amount=1,
            blog=cls.blog,
            metricamount=1,
            metricunit=1
        )

    def setUp(self):
        self.recipe = recipe.objects.get(id=1)
        self.recipe.food = 1
        self.recipe.unit = 1
        self.recipe.blog = self.blog
        self.recipe.metricamount = 1
        self.recipe.metricunit = 1
        self.recipe.amount = 1
        self.recipe.save()

    def test_recipe_int_fields(self):
        self.assertEqual(self.recipe.food, 1)
        self.assertEqual(self.recipe.unit, 1)
        self.assertEqual(self.recipe.blog.id, self.blog.id)
        self.assertEqual(self.recipe.metricamount, 1)
        self.assertEqual(self.recipe.metricunit, 1)
    
    def test_recipe_float_fields(self):
        self.assertEqual(self.recipe.amount, 1)


class NutritionCalculateTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.blog = blog.objects.create(id=1)
        cls.nutrition = nutrition.objects.all()
        cls.recipe = recipe.objects.filter(blog=cls.blog.id)

    def setUp(self):
        self.calorie = 0
        self.fat = 0
        self.sodium = 0
        self.calcium = 0
        self.protein = 0
        self.iron = 0
        self.carbohydrates = 0
        self.sugars = 0
        self.fiber = 0
        self.vitamina = 0
        self.vitaminb = 0
        self.vitamind = 0

        for i in self.recipe:
            __nutrition = self.nutrition.filter(food=i.food).first()
            if __nutrition:
                self.calorie += __nutrition.calorie * i.metricamount
                self.fat += __nutrition.fat * i.metricamount
                self.sodium += __nutrition.sodium * i.metricamount
                self.calcium += __nutrition.calcium * i.metricamount
                self.protein += __nutrition.protein * i.metricamount
                self.iron += __nutrition.iron * i.metricamount
                self.carbohydrates += __nutrition.carbohydrates * i.metricamount
                self.sugars += __nutrition.sugars * i.metricamount
                self.fiber += __nutrition.fiber * i.metricamount
                self.vitamina += __nutrition.vitamina * i.metricamount
                self.vitaminb += __nutrition.vitaminb * i.metricamount
                self.vitamind += __nutrition.vitamind * i.metricamount
 
    def test_nutrition_int_fields(self):
        self.assertEqual(self.calorie, 0) 
        self.assertEqual(self.fat, 0)
        self.assertEqual(self.sodium, 0)
        self.assertEqual(self.calcium, 0)
        self.assertEqual(self.protein, 0)
        self.assertEqual(self.iron, 0)
        self.assertEqual(self.carbohydrates, 0)
        self.assertEqual(self.sugars, 0)
        self.assertEqual(self.fiber, 0)
        self.assertEqual(self.vitamina, 0)
        self.assertEqual(self.vitaminb, 0)
        self.assertEqual(self.vitamind, 0)
