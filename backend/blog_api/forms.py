from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from .models import UserProfile


class SignUpForm(UserCreationForm):
    age = forms.IntegerField()
    weight = forms.FloatField()
    height = forms.FloatField()
    description = forms.CharField(max_length=255)
    experience = forms.IntegerField()
    story = forms.CharField(widget=forms.Textarea, required=False)

    class Meta:
        model = User
        fields = ('username', 'email', 'password1', 'password2', 'age', 'weight', 'height', 'description', 'experience', 'story')

    def save(self, commit=True):
        user = super().save(commit=False)
        if commit:
            user.save()
            UserProfile.objects.create(user=user, age=self.cleaned_data['age'], weight=self.cleaned_data['weight'],
                                       height=self.cleaned_data['height'], description=self.cleaned_data['description'],
                                       experience=self.cleaned_data['experience'], story=self.cleaned_data['story'])
        return user
