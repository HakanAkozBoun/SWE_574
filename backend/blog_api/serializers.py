from rest_framework import serializers
from .models import blog, category, UserProfile, InputFood

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