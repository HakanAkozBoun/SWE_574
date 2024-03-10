from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from ..models import Recipe
from ..serializers import *


class RecipeListView(APIView):
    #api/recipes/
    def get(self, request):
        recipes = Recipe.objects.all()
        serializer = RecipeListSerializer(recipes, many=True)
        return Response(serializer.data)

class RecipeDetailView(APIView):
    #api/recipes/<int:id>/
    def get(self, request, pk):
        try:
            recipe = Recipe.objects.get(pk=pk)
        except Recipe.DoesNotExist:
            return Response({"error": "Recipe not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = RecipeListSerializer(recipe)
        return Response(serializer.data)
    
class RecipeCreateView(APIView):
    #api/recipes/create/
    def post(self, request):
        serializer = RecipeCreateSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class RecipeUpdateView(APIView):
    #api/recipe/45/update/
    def put(self, request, pk):
        try:
            recipe = Recipe.objects.get(pk=pk)
        except Recipe.DoesNotExist:
            return Response({"error": "Recipe not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = RecipeSerializer(recipe, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class RecipeDeleteView(APIView):
    #api/recipe/45/delete/
    def delete(self, request, pk):
        try:
            recipe = Recipe.objects.get(pk=pk)
        except Recipe.DoesNotExist:
            return Response({"error": "Recipe not found"}, status=status.HTTP_404_NOT_FOUND)

        recipe.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
