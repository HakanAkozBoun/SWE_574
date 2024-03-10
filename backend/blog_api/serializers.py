from rest_framework import serializers
from .models import *
# from .models import blog, category

# class blogSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = blog
#         fields = '__all__'

# class categorySerializer(serializers.ModelSerializer):
#     class Meta:
#         model = category
#         fields = '__all__'

# recipe model serializers
class RecipeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recipe
        fields = '__all__'
        
        def create(self, validated_data):
            categories_data = validated_data.pop('categories', [])
            ingredients_data = validated_data.pop('ingredients', [])

            recipe = Recipe.objects.create(**validated_data)

            for category_data in categories_data:
                category, _ = Category.objects.get_or_create(**category_data)
                recipe.categories.add(category)

            for ingredient_data in ingredients_data:
                unit_data = ingredient_data.pop('unit', {})
                unit, _ = Unit.objects.get_or_create(**unit_data)
                ingredient = Ingredient.objects.create(unit=unit, **ingredient_data)
                recipe.ingredients.add(ingredient)

            return recipe

class ingredientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ingredient
        fields = '__all__'

class UnitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Unit
        fields = '__all__'

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

# user_interaction model serializers
class UserCommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserComment
        fields = '__all__'

class UserRatingSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserRating
        fields = '__all__'

class UserBookmarkSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserBookmark
        fields = '__all__'

# user_profile model serializers
class UserProfile(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = '__all__'

class foodAllergySerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodAllergens
        fields = '__all__'

class dietgoalsSerializer(serializers.ModelSerializer):
    class Meta:
        model = DietGoals
        fields = '__all__'

