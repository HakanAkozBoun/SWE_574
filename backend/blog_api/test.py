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

class RecipeDeriveTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.blog = blog.objects.get(id=1)
        cls.recipelist = []
        recipe = {}
        recipe.food = 1
        recipe.unit = 1
        recipe.blog = 1
        recipe.metricamount = 1
        recipe.metricunit = 1
        recipe.amount = 1

        cls.recipelist.append(recipe)
        
        cls.parameter = {}
        cls.parameter.title = 'hakan'

    def setUp(self):
        if self.parameter.category is not None:
            self.blog.category = self.parameter.category
        if self.parameter.title is not None:
            self.blog.title = self.parameter.title
        if self.parameter.slug is not None:
            self.blog.slug = self.parameter.slug
        if self.parameter.excerpt is not None:
            self.blog.excerpt = self.parameter.excerpt
        if self.parameter.content is not None:
            self.blog.content = self.parameter.content
        if self.parameter.contentTwo is not None:
            self.blog.contentTwo = self.parameter.contentTwo
        if self.parameter.preparationtime is not None:
            self.blog.preparationtime = self.parameter.preparationtime
        if self.parameter.cookingtime is not None:
            self.blog.cookingtime = self.parameter.cookingtime
        if self.parameter.avg_rating is not None:
            self.blog.avg_rating = self.parameter.avg_rating
        if self.parameter.image is not None:
            self.blog.image = self.parameter.image
        if self.parameter.ingredients is not None:
            self.blog.ingredients = self.parameter.ingredients
        if self.parameter.postlabel is not None:
            self.blog.postlabel = self.parameter.postlabel
        if self.parameter.userid is not None:
            self.blog.userid = self.parameter.userid
        if self.parameter.serving is not None:
            self.blog.serving = self.parameter.serving

        self.blognew = blog.objects.create(
            category = self.blog.category, 
            title = self.blog.title,
            slug = self.blog.slug,
            excerpt = self.blog.excerpt,
            content = self.blog.content,
            contentTwo = self.blog.contentTwo,
            preparationtime = self.blog.preparationtime,
            cookingtime = self.blog.cookingtime,
            avg_rating = self.blog.avg_rating,
            image = self.blog.image,
            ingredients = self.blog.ingredients,
            postlabel = self.blog.postlabel,
            userid = self.blog.userid,
            serving = self.blog.serving)
        
        conversion = unitconversion.objects.all()
        for item in self.recipelist:
            metricamount = item.get('amount') # ya da item.amount
            metricunit = item.get('unit')
            _conversion = conversion.filter(imperial=item.get('unit'))
            if _conversion:
                metricamount /= _conversion.first().ivalue
                metricunit = _conversion.first().metric
            recipe.objects.create(food=item.get('food'), unit=item.get('unit'), amount=item.get('amount'), blog=self.blognew.id, metricamount=metricamount, metricunit=metricunit)
 
    def test_blog_fields(self):
        self.assertEqual(self.blognew.category, 1)
        self.assertEqual(self.blognew.title, 1)
        self.assertEqual(self.blognew.slug, 1)
        self.assertEqual(self.blognew.excerpt, 1)
        self.assertEqual(self.blognew.content, 1)
        self.assertEqual(self.blognew.contentTwo, 1)
        self.assertEqual(self.blognew.preparationtime, 1)
        self.assertEqual(self.blognew.cookingtime, 1)
        self.assertEqual(self.blognew.avg_rating, 1)
        self.assertEqual(self.blognew.image, 1)
        self.assertEqual(self.blognew.ingredients, 1)
        self.assertEqual(self.blognew.postlabel, 1)
        self.assertEqual(self.blognew.userid, 1)
        self.assertEqual(self.blognew.serving, 1)
class RecipeCreateTest(TestCase):
    def setUp(self):
     self.recipe = recipe.objects.create(food=1, unit=1, amount=1, blog=1, metricamount=1, metricunit=1)

    def setUp(self):

            self.blog.category = 1
            self.blog.title = 'Manti'
            self.blog.slug = 'manti'
            self.blog.excerpt = 'manti'
            self.blog.content = 'manti is an turkish culturel food'
            self.blog.contentTwo = 'manti is an turkish culturel food'
            self.blog.preparationtime = 15
            self.blog.cookingtime = 20
            self.blog.avg_rating = 5
            self.blog.image = 1
            self.blog.ingredients = '1-meat, 2- flour'
            self.blog.postlabel = 1
            self.blog.userid = self.parameter.userid
            self.blog.serving = self.parameter.serving

    self.blognew = blog.objects.create(
            category = self.blog.category, 
            title = self.blog.title,
            slug = self.blog.slug,
            excerpt = self.blog.excerpt,
            content = self.blog.content,
            contentTwo = self.blog.contentTwo,
            preparationtime = self.blog.preparationtime,
            cookingtime = self.blog.cookingtime,
            avg_rating = self.blog.avg_rating,
            image = self.blog.image,
            ingredients = self.blog.ingredients,
            postlabel = self.blog.postlabel,
            userid = self.blog.userid,
            serving = self.blog.serving)
                
    def test_recipe_int_fields(self):
        self.assertEqual(self.recipe.food, 1)
        self.assertEqual(self.recipe.unit, 1)
        self.assertEqual(self.recipe.blog, 1)
        self.assertEqual(self.recipe.metricamount, 1)
        self.assertEqual(self.recipe.metricunit, 1)
    
    def test_recipe_float_fields(self):
        self.assertEqual(self.recipe.amount, 1)

class RecipeEditTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.recipe = recipe.objects.get(id=1)
        cls.recipe.food = 1
        cls.recipe.unit = 1
        cls.recipe.blog = 1
        cls.recipe.metricamount = 1
        cls.recipe.metricunit = 1
        cls.recipe.amount
        cls.recipe.save()

    def setUp(self):
        self.recipeupdated = recipe.objects.get(id=1)
 
    def test_recipe_int_fields(self):
        self.assertEqual(self.recipeupdated.food, 1)
        self.assertEqual(self.recipeupdated.unit, 1)
        self.assertEqual(self.recipeupdated.blog, 1)
        self.assertEqual(self.recipeupdated.metricamount, 1)
        self.assertEqual(self.recipeupdated.metricunit, 1)
    
    def test_recipe_float_fields(self):
        self.assertEqual(self.recipeupdated.amount, 1)

class NutritionCalculateTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.blog = blog.objects.get(id=1)
        cls.nutrition = nutrition.objects.all()
        cls.recipe = recipe.objects.filter(blog=cls.blog.id)

    def setUp(self):
        self.calorie = 0
        self.fat = 0
        self.sodium = 0
        self.calcium = 0
        self.protein = 0
        self.iron = 0
        self.carbonhydrates = 0
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
                self.carbonhydrates += __nutrition.carbonhydrates * i.metricamount
                self.sugars += __nutrition.sugars * i.metricamount
                self.fiber += __nutrition.fiber * i.metricamount
                self.vitamina += __nutrition.vitamina * i.metricamount
                self.vitaminb += __nutrition.vitaminb * i.metricamount
                self.vitamind += __nutrition.vitamind * i.metricamount
 
    def test_nutrition_int_fields(self):
        self.assertEqual(self.calorie, 1)
        self.assertEqual(self.fat, 1)
        self.assertEqual(self.sodium, 1)
        self.assertEqual(self.calcium, 1)
        self.assertEqual(self.protein, 1)
        self.assertEqual(self.iron, 1)
        self.assertEqual(self.carbonhydrates, 1)
        self.assertEqual(self.sugars, 1)
        self.assertEqual(self.fiber, 1)
        self.assertEqual(self.vitamina, 1)
        self.assertEqual(self.vitaminb, 1)
        self.assertEqual(self.vitamind, 1)     
