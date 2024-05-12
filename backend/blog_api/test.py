from django.test import TestCase
from django.core.exceptions import ValidationError
import time
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
    def setUp(self):
        self.nutrition = nutrition.objects.create(
            calorie=100,
            fat=10,
            sodium=500,
            calcium=200,
            protein=20,
            iron=5,
            carbonhydrates=30,
            sugars=15,
            fiber=5,
            vitamina=100,
            vitaminb=50,
            vitamind=25,
            food=1
        )
        self.nutrition2 = nutrition.objects.create(
            calorie=200,
            fat=20,
            sodium=1000,
            calcium=400,
            protein=40,
            iron=10,
            carbonhydrates=60,
            sugars=30,
            fiber=10,
            vitamina=200,
            vitaminb=100,
            vitamind=50,
            food=1
        )
        self.nutrition3 = nutrition.objects.create(
            calorie=300,
            fat=30,
            sodium=1500,
            calcium=600,
            protein=60,
            iron=15,
            carbonhydrates=90,
            sugars=45,
            fiber=15,
            vitamina=300,
            vitaminb=150,
            vitamind=75,
            food=1
        )
    def test_sum_nutrition_values(self):
        total_calorie = nutrition.objects.aggregate(total_calorie=models.Sum('calorie'))['total_calorie']
        total_fat = nutrition.objects.aggregate(total_fat=models.Sum('fat'))['total_fat']
        total_sodium = nutrition.objects.aggregate(total_sodium=models.Sum('sodium'))['total_sodium']
        total_calcium = nutrition.objects.aggregate(total_calcium=models.Sum('calcium'))['total_calcium']
        total_protein = nutrition.objects.aggregate(total_protein=models.Sum('protein'))['total_protein']
        total_iron = nutrition.objects.aggregate(total_iron=models.Sum('iron'))['total_iron']
        total_carbonhydrates = nutrition.objects.aggregate(total_carbonhydrates=models.Sum('carbonhydrates'))['total_carbonhydrates']
        total_sugars = nutrition.objects.aggregate(total_sugars=models.Sum('sugars'))['total_sugars']
        total_fiber = nutrition.objects.aggregate(total_fiber=models.Sum('fiber'))['total_fiber']
        total_vitamina = nutrition.objects.aggregate(total_vitamina=models.Sum('vitamina'))['total_vitamina']
        total_vitaminb = nutrition.objects.aggregate(total_vitaminb=models.Sum('vitaminb'))['total_vitaminb']
        total_vitamind = nutrition.objects.aggregate(total_vitamind=models.Sum('vitamind'))['total_vitamind']

        self.assertEqual(total_calorie, 600)
        self.assertEqual(total_fat, 60)
        self.assertEqual(total_sodium, 3000)
        self.assertEqual(total_calcium, 1200)
        self.assertEqual(total_protein, 120)
        self.assertEqual(total_iron, 30)
        self.assertEqual(total_carbonhydrates, 180)
        self.assertEqual(total_sugars, 90)
        self.assertEqual(total_fiber, 30)
        self.assertEqual(total_vitamina, 600)
        self.assertEqual(total_vitaminb, 300)
        self.assertEqual(total_vitamind, 150)

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
