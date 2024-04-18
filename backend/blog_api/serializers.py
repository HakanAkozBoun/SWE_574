from rest_framework import serializers
from .models import blog, category, UserProfile
from django.contrib.auth.models import User
from django.contrib.auth.password_validation import validate_password


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
        fields = ('age', 'weight', 'height', 'description', 'experience', 'story')

class UserSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer()
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    email = serializers.EmailField(required=True)

    class Meta:
        model = User
        fields = ('username', 'password', 'email', 'profile')

    def create(self, validated_data):
        profile_data = validated_data.pop('profile', None)
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        UserProfile.objects.create(user=user, **profile_data)
        return user