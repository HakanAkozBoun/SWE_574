from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone

from django.core.validators import MinValueValidator, MaxValueValidator
from django.db.models import Avg


class food(models.Model):
    name = models.CharField(max_length=255)
    unit = models.IntegerField()

    def _str_(self):
        return self.name


class comment(models.Model):
    blog = models.IntegerField()
    user = models.IntegerField()
    text = models.CharField(max_length=255)

    def _str_(self):
        return self.recipe


class nutrition(models.Model):
    calorie = models.FloatField(null=True)
    fat = models.FloatField(null=True)
    sodium = models.FloatField(null=True)
    calcium = models.FloatField(null=True)
    protein = models.FloatField(null=True)
    iron = models.FloatField(null=True)
    carbonhydrates = models.FloatField(null=True)
    sugars = models.FloatField(null=True)
    fiber = models.FloatField(null=True)
    vitamina = models.FloatField(null=True)
    vitaminb = models.FloatField(null=True)
    vitamind = models.FloatField(null=True)
    food = models.IntegerField()

    def _str_(self):
        return self.unit


class recipe(models.Model):
    food = models.IntegerField()
    unit = models.IntegerField()
    amount = models.FloatField()
    blog = models.IntegerField()
    metricamount = models.IntegerField()
    metricunit = models.IntegerField()

    def _str_(self):
        return self.food


class unit(models.Model):
    name = models.CharField(max_length=255)
    type = models.IntegerField()

    def _str_(self):
        return self.name


class unittype(models.Model):
    name = models.CharField(max_length=255)

    def _str_(self):
        return self.name


class unititem(models.Model):
    imperial = models.CharField(max_length=255)
    metric = models.CharField(max_length=255)
    unit = models.IntegerField()

    def _str_(self):
        return self.metric


class unitconversion(models.Model):
    imperial = models.FloatField()
    metric = models.FloatField()
    mvalue = models.FloatField()
    ivalue = models.FloatField()
    unittype = models.IntegerField()

    def _str_(self):
        return self.metric


class category(models.Model):
    name = models.CharField(max_length=255)
    image = models.IntegerField(null=True, blank=True)

    def _str_(self):
        return self.name


class blog(models.Model):
    POST_CHOICES = [
        ('POPULAR', 'Popular')
    ]
    category = models.ForeignKey(category, on_delete=models.CASCADE, null=True)
    title = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255)
    excerpt = models.CharField(max_length=255, default='')
    content = models.TextField(null=True, blank=True)
    contentTwo = models.TextField(null=True, blank=True)
    preparationtime = models.TextField(null=True, blank=True)
    cookingtime = models.TextField(null=True, blank=True)
    avg_rating = models.FloatField(default=0)
    image = models.IntegerField(null=True, blank=True)
    ingredients = models.TextField(null=True, blank=True)

    postlabel = models.CharField(
        max_length=100, choices=POST_CHOICES, null=True, blank=True)
    userid = models.IntegerField(default=1)
    serving = models.IntegerField(default=4)

    def _str_(self):
        return self.title

    def calculate_avg_rating(self):
        ratings = UserRating.objects.filter(recipe=self)
        avg_rating = ratings.aggregate(Avg('value'))['value__avg']

        if avg_rating is not None:
            self.avg_rating = avg_rating
        else:
            self.avg_rating = 0

        self.save()


class Follower(models.Model):
    follower_user = models.ForeignKey(
        User,
        related_name='following',
        on_delete=models.CASCADE
    )
    following_user = models.ForeignKey(
        User,
        related_name='followers',
        on_delete=models.CASCADE
    )
    # is_active eklenebilir


'''
class Bookmark(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='user_bookmarks')
    bookmarked_recipe = models.ForeignKey(
        recipe, on_delete=models.CASCADE, related_name='bookmarked_by')

'''


class FoodTable(models.Model):

    fdc_id = models.IntegerField()
    data_type = models.CharField(max_length=255)
    description = models.CharField(max_length=255)
    food_category_id = models.CharField(null=True, blank=True, max_length=255)
    publication_date = models.DateField()

    def _str_(self):
        return self.description


class FoodNutrient(models.Model):

    name = models.CharField(max_length=255, null=True, blank=True)
    unit_name = models.CharField(max_length=255, null=True, blank=True)
    nutrient_nbr = models.CharField(null=True, blank=True, max_length=255)
    rank = models.IntegerField(null=True, blank=True)

    def _str_(self):
        return self.name


class FoundationFood(models.Model):

    fdc_id = models.IntegerField()
    NDB_number = models.IntegerField()
    footnote = models.CharField(max_length=255)


class SampleFood(models.Model):

    fdc_id = models.IntegerField()


class UserBookmark(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    blog = models.ForeignKey(blog, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)


class UserRating(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    recipe = models.ForeignKey(blog, on_delete=models.CASCADE)
    value = models.PositiveIntegerField(
        default=0, validators=[MinValueValidator(1), MaxValueValidator(5)])
    created_at = models.DateTimeField(auto_now_add=True)


class FoodNutrientTable(models.Model):
    fdc_id = models.IntegerField(null=True, blank=True, default=0)
    nutrient_id = models.IntegerField()
    amount = models.FloatField()
    data_points = models.CharField(max_length=255)
    data_points = models.CharField(max_length=255, blank=True, null=True)
    derivation_id = models.IntegerField()
    min = models.CharField(blank=True, null=True, max_length=255)
    max = models.CharField(blank=True, null=True, max_length=255)
    median = models.CharField(blank=True, null=True, max_length=255)
    loq = models.CharField(blank=True, null=True, max_length=255)
    footnote = models.CharField(max_length=255, blank=True, null=True)
    min_year_acquired = models.CharField(blank=True, null=True, max_length=255)


class InputFood(models.Model):

    fdc_id = models.IntegerField(null=True, blank=True)
    seq_num = models.IntegerField(null=True, blank=True)
    amount = models.FloatField(null=True, blank=True)
    sr_description = models.CharField(null=True, blank=True, max_length=255)
    unit = models.CharField(null=True, blank=True, max_length=255)
    portion_description = models.CharField(
        null=True, blank=True, max_length=255)
    gram_weight = models.FloatField(null=True, blank=True)
    retention_code = models.CharField(null=True, blank=True, max_length=255)
    survey_flag = models.CharField(null=True, blank=True, max_length=255)


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    age = models.IntegerField(null=True, blank=True)
    weight = models.FloatField(null=True, blank=True)
    height = models.FloatField(null=True, blank=True)
    description = models.CharField(max_length=255, null=True, blank=True)
    image = models.CharField(max_length=255, null=True, blank=True)
    experience = models.IntegerField(null=True, blank=True)
    gender = models.CharField(max_length=255, null=True, blank=True)
    graduated_from = models.CharField(max_length=255, null=True, blank=True)
    cuisines_of_expertise = models.CharField(
        max_length=255, null=True, blank=True)
    working_at = models.CharField(max_length=255, null=True, blank=True)


class Eaten(models.Model):
    userId = models.ForeignKey(User, on_delete=models.CASCADE)
    blogId = models.ForeignKey(blog, on_delete=models.CASCADE)
    eaten_serving = models.FloatField(null=True, default=1, blank=True)
    eatenDate = models.DateField(default=timezone.datetime.today)
    is_active = models.BooleanField(default=True)


class Allergy(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    food = models.ForeignKey(food, on_delete=models.CASCADE)


class image(models.Model):
    # id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255, null=True, blank=True)
    data = models.TextField(max_length=255, null=True, blank=True)
    type = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return self.name


class Goal(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    goal_nutrition = models.CharField(max_length=255, null=True, blank=True)
    goal_amount = models.FloatField(null=True, blank=True)
