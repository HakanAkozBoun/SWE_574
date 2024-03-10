from rest_framework import serializers
from ..models import *

class UnitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Unit
        fields = '__all__'
        
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ingredientCreateSerializer(serializers.ModelSerializer):
    unit = serializers.PrimaryKeyRelatedField(queryset=Unit.objects.all())
    class Meta:
        model = Ingredient
        fields = '__all__'
        
class ingredientlistSerializer(serializers.ModelSerializer):
    unit = UnitSerializer()
    class Meta:
        model = Ingredient
        fields = '__all__'

class RecipeListSerializer(serializers.ModelSerializer):
    categories = CategorySerializer(many=True)
    ingredients = ingredientlistSerializer(many=True)

    class Meta:
        model = Recipe
        fields = '__all__'

class RecipeCreateSerializer(serializers.ModelSerializer):
    categories = serializers.PrimaryKeyRelatedField(queryset=Category.objects.all(), many=True)
    ingredients = ingredientCreateSerializer(many=True, required=True)

    class Meta:
        model = Recipe
        fields = '__all__'
        
    def create(self, validated_data):
        ingredients_data = validated_data.pop('ingredients', [])
        categories_data = validated_data.pop('categories', [])

        recipe = Recipe.objects.create(**validated_data)

        for ingredient_data in ingredients_data:
            unit_data = ingredient_data.pop('unit', {})
            ingredient = Ingredient.objects.create(recipe=recipe, **ingredient_data, unit=unit_data)
            recipe.ingredients.add(ingredient)
            
        for category_data in categories_data:
            recipe.categories.add(category_data)

        return recipe