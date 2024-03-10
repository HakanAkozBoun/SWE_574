from django.db import models
from django.contrib.auth.models import User

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    description = models.TextField(null=True, blank=True)
    height = models.PositiveIntegerField(null=True, blank=True)  # Height in centimeters
    weight = models.PositiveIntegerField(null=True, blank=True)  # Weight in kilograms
    food_allergens = models.ManyToManyField('FoodAllergens', null=True, blank=True) #'Gluten', 'Dairy', 'Egg', 'Peanut', 'Soy', 'Tree Nut', 'Fish', 'Shellfish', etc
    diet_goals = models.ManyToManyField('DietGoals', null=True, blank=True) #'Gain Weight', 'Lose Weight', 'Maintain Weight', 'Build Muscle', etc
    food_prefrences = models.ManyToManyField('FoodPrefrences', null=True, blank=True) # 'Vegan', 'Vegetarian', 'Keto', 'Paleo', 'Low Carb', 'Low Fat', 'High Protein', etc

    GENDER_CHOICES = [
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other'),
    ]
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES, null=True, blank=True)

    def __str__(self):
        return f'UserProfile for {self.user.username}'

class FoodAllergens(models.Model):
    name = models.CharField(max_length=100)
    
    def __str__(self):
        return self.name


"""
The models below allow users to set their diet goals.
User will choose the name of the goal from the list of available options like 'Gain Weight', 'Lose Weight'.
The specified goal will be associated with a dictionary of nutritions and their amounts specified by the system.
For example, for gaining weight recipes for high protein and high calorie meals and etc. will be recommended.
"""
class DietGoals(models.Model):
    name = models.CharField(max_length=100)
    nutrition = models.JSONField(null=True, blank=True) #Dictionary {Nutrition(example: protein) : Amount}

    def __str__(self):
        return self.name   
    

""""
The models below allow users to set their food preferences.
User will choose the name of the preference from the list of available options like 'Vegan', 'Vegetarian', 'Keto', 'Paleo'.
The specified preference will be associated with a list of ingredients that are not allowed in the diet.
For example, for vegan recipes, the system will not recommend recipes that contain meat, dairy, and etc.
"""
class FoodPrefrences(models.Model):
    name = models.CharField(max_length=100)
    nutrition = models.JSONField(null=True, blank=True) #Dictionary {Nutrition(example: protein) : Amount}

    def __str__(self):
        return self.name