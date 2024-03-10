from django.db import models
from django.contrib.auth.models import User

import uuid


def image_file_path(instance, filename):
    ext = filename.split('.')[-1]
    filename = f"{uuid.uuid4()}.{ext}"
    return f'images/{filename}'

class Recipe(models.Model):
    creator = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    title = models.CharField(max_length=255, null=True, blank=True)
    categories = models.ManyToManyField('Category', null=True, blank=True)
    description = models.TextField(null=True, blank=True)
    ingredients = models.ManyToManyField('Ingredient', null=True, blank=True)
    instructions = models.JSONField(null=True, blank=True) #List [step1, step2, step3, ...]
    images = models.ImageField(null=True, blank=True, upload_to=image_file_path)
    nutrition_facts = models.JSONField(null=True, blank=True) #Dictionary {Nutrition(example: protein) : Amount}
    preparation_time = models.PositiveIntegerField(null=True, blank=True)  #Time in minutes
    cooking_time = models.PositiveIntegerField(null=True, blank=True)  #Time in minutes
    created_at = models.DateTimeField(auto_now_add=True, null=True, blank=True)
    avg_rating = models.FloatField(default=0, null=True, blank=True)

    # def calculate_avg_rating(self):
    #     ratings = UserRating.objects.filter(recipe=self)
    #     avg_rating = ratings.aggregate(Avg('value'))['value__avg']

    #     if avg_rating is not None:
    #         self.avg_rating = avg_rating
    #     else:
    #         self.avg_rating = 0

    #     self.save() 

class Ingredient(models.Model):
    name = models.CharField(max_length=100, null=True, blank=True) #Egg, Milk, Flour, Sugar, Salt, Pepper, etc
    amount = models.FloatField(null=True, blank=True) 
    unit = models.ForeignKey('Unit', on_delete=models.SET_NULL, null=True, blank=True)
    
    def __str__(self):
        return self.name
    
class Unit(models.Model):
    name = models.CharField(max_length=100, null=True, blank=True) #Cup, Teaspoon, Tablespoon, Gram, Kilogram, Litre, Millilitre, etc
    abbreviation = models.CharField(max_length=10, null=True, blank=True) #Cup, Tsp, Tbsp, g, kg, L, mL, etc

    def __str__(self):
        return self.name

class Category(models.Model):
    name = models.CharField(max_length=100, null=True, blank=True) #Breakfast, lunch, dinner, ...
    image = models.ImageField(upload_to='image', null=True, blank=True)

    def __str__(self):
        return self.name