from rest_framework import serializers
from .models import blog, category, UserProfile, InputFood, User


class blogSerializer(serializers.ModelSerializer):
    class Meta:
        model = blog
        fields = '__all__'


class categorySerializer(serializers.ModelSerializer):
    class Meta:
        model = category
        fields = '__all__'


class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = '__all__'


class InputFoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = InputFood
        fields = '__all__'


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email']


class UserProfileForFrontEndSerializer(serializers.ModelSerializer):
    user = UserSerializer(
        many=False,
    )

    class Meta:
        model = UserProfile
        fields = ['id', 'user', 'age', 'weight', 'height', 'description', 'image', 'experience', 'story',
                  'diet_goals', 'food_allergies', 'working_at', 'gender', 'graduated_from', 'cuisines_of_expertise']
