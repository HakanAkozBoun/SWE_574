"""
poweshell
dir: SWE_574\backend> Get-Content blog_api\models\populate_data.py | python manage.py shell
"""

from django.contrib.auth.models import User
from blog_api.models import Recipe, Ingredient, Unit, Category

# Delete existing records
# Recipe.objects.all().delete()
# Ingredient.objects.all().delete()
# Unit.objects.all().delete()
# Category.objects.all().delete()
# User.objects.all().delete()

# Create dummy users
users = [
    User.objects.create(username='user1', email='user1@example.com', password='password1'),
    User.objects.create(username='user2', email='user2@example.com', password='password2'),
    User.objects.create(username='user3', email='user3@example.com', password='password3'),
]

# Create dummy categories
categories = [
    Category.objects.create(name='Breakfast'),
    Category.objects.create(name='Lunch'),
    Category.objects.create(name='Dinner'),
]

# Create dummy units
units = [
    Unit.objects.create(name='Cup', abbreviation='cup'),
    Unit.objects.create(name='Teaspoon', abbreviation='tsp'),
    Unit.objects.create(name='Tablespoon', abbreviation='tbsp'),
    Unit.objects.create(name='Gram', abbreviation='g'),
    Unit.objects.create(name='Kilogram', abbreviation='kg'),
]

# Get user IDs from the database
user_ids = list(User.objects.values_list('id', flat=True))

# Get category IDs from the database
category_ids = list(Category.objects.values_list('id', flat=True))

# Get unit IDs from the database
unit_ids = list(Unit.objects.values_list('id', flat=True))

# Example recipes data post it in POSTMAN
"""
{
    "creator": 156,  //change id of auth_user
    "title": "Delicious Pasta",
    "categories": [160, 160], //change id of categories based on the ones in db
    "description": "A mouth-watering pasta dish.",
    "ingredients": [
        {
        "name": "Pasta",
        "amount": 250,
        "unit": 266  //change id of unit based on the ones in db
        },
        {
        "name": "Tomato Sauce",
        "amount": 200,
        "unit": 267  //change id of unit based on the ones in db
        },
        {
        "name": "Parmesan Cheese",
        "amount": 50,
        "unit": 267 //change id of unit based on the ones in db
        }
    ],
    "instructions": ["Boil pasta until al dente.", "Mix with tomato sauce.", "Sprinkle Parmesan cheese on top."],
    "nutrition_facts": {
        "protein": 10,
        "carbohydrates": 30,
        "fat": 8
    },
    "preparation_time": 15,
    "cooking_time": 20
}
"""