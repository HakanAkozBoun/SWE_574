from rest_framework import serializers
from .models import blog, category, UserProfile, InputFood
from .models import blog, category, UserProfile
from django.contrib.auth.models import User
from django.contrib.auth.password_validation import validate_password
from .models import blog, category, UserProfile, InputFood, Allergy

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
        
class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ('user', 'age', 'weight', 'height', 'description', 'experience', 'story', 'image', 'diet_goals', 'food_allergies', 'gender', 'graduated_from', 'cuisines_of_expertise', 'working_at')

class UserSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer(read_only=True)
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    email = serializers.EmailField(required=True)

    class Meta:
        model = User
        fields = ('username', 'password', 'email', 'profile')

    def create(self, validated_data):
        profile_data = validated_data.pop('profile', {})
        user = User.objects.create_user(
            username=validated_data.get('username'),
            email=validated_data.get('email'),
            password=validated_data.get('password')
        )
        UserProfile.objects.create(user=user, **profile_data)
        return user
class AllergySerializer(serializers.ModelSerializer):
    class Meta:
        model = Allergy
        fields = '__all__'
