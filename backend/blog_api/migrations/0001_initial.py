# Generated by Django 4.2.7 on 2024-05-07 14:41

import datetime
from django.conf import settings
import django.core.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='blog',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('excerpt', models.CharField(default='', max_length=255)),
                ('content', models.TextField(blank=True, null=True)),
                ('contentTwo', models.TextField(blank=True, null=True)),
                ('preparationtime', models.TextField(blank=True, null=True)),
                ('cookingtime', models.TextField(blank=True, null=True)),
                ('avg_rating', models.FloatField(default=0)),
                ('image', models.ImageField(blank=True, null=True, upload_to='image')),
                ('ingredients', models.TextField(blank=True, null=True)),
                ('postlabel', models.CharField(blank=True, choices=[('POPULAR', 'Popular')], max_length=100, null=True)),
                ('userid', models.IntegerField(default=1)),
                ('serving', models.IntegerField(default=4)),
            ],
        ),
        migrations.CreateModel(
            name='category',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('image', models.ImageField(blank=True, null=True, upload_to='image')),
            ],
        ),
        migrations.CreateModel(
            name='comment',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('blog', models.IntegerField()),
                ('user', models.IntegerField()),
                ('text', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='food',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('unit', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='FoodNutrient',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(blank=True, max_length=255, null=True)),
                ('unit_name', models.CharField(blank=True, max_length=255, null=True)),
                ('nutrient_nbr', models.CharField(blank=True, max_length=255, null=True)),
                ('rank', models.IntegerField(blank=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='FoodNutrientTable',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fdc_id', models.IntegerField(blank=True, default=0, null=True)),
                ('nutrient_id', models.IntegerField()),
                ('amount', models.FloatField()),
                ('data_points', models.CharField(blank=True, max_length=255, null=True)),
                ('derivation_id', models.IntegerField()),
                ('min', models.CharField(blank=True, max_length=255, null=True)),
                ('max', models.CharField(blank=True, max_length=255, null=True)),
                ('median', models.CharField(blank=True, max_length=255, null=True)),
                ('loq', models.CharField(blank=True, max_length=255, null=True)),
                ('footnote', models.CharField(blank=True, max_length=255, null=True)),
                ('min_year_acquired', models.CharField(blank=True, max_length=255, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='FoodTable',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fdc_id', models.IntegerField()),
                ('data_type', models.CharField(max_length=255)),
                ('description', models.CharField(max_length=255)),
                ('food_category_id', models.CharField(blank=True, max_length=255, null=True)),
                ('publication_date', models.DateField()),
            ],
        ),
        migrations.CreateModel(
            name='FoundationFood',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fdc_id', models.IntegerField()),
                ('NDB_number', models.IntegerField()),
                ('footnote', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='InputFood',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fdc_id', models.IntegerField(blank=True, null=True)),
                ('seq_num', models.IntegerField(blank=True, null=True)),
                ('amount', models.FloatField(blank=True, null=True)),
                ('sr_description', models.CharField(blank=True, max_length=255, null=True)),
                ('unit', models.CharField(blank=True, max_length=255, null=True)),
                ('portion_description', models.CharField(blank=True, max_length=255, null=True)),
                ('gram_weight', models.FloatField(blank=True, null=True)),
                ('retention_code', models.CharField(blank=True, max_length=255, null=True)),
                ('survey_flag', models.CharField(blank=True, max_length=255, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='nutrition',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('calorie', models.FloatField(null=True)),
                ('fat', models.FloatField(null=True)),
                ('sodium', models.FloatField(null=True)),
                ('calcium', models.FloatField(null=True)),
                ('protein', models.FloatField(null=True)),
                ('iron', models.FloatField(null=True)),
                ('carbonhydrates', models.FloatField(null=True)),
                ('sugars', models.FloatField(null=True)),
                ('fiber', models.FloatField(null=True)),
                ('vitamina', models.FloatField(null=True)),
                ('vitaminb', models.FloatField(null=True)),
                ('vitamind', models.FloatField(null=True)),
                ('food', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='recipe',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('food', models.IntegerField()),
                ('unit', models.IntegerField()),
                ('amount', models.FloatField()),
                ('blog', models.IntegerField()),
                ('metricamount', models.IntegerField()),
                ('metricunit', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='SampleFood',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fdc_id', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='unit',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('type', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='unitconversion',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('imperial', models.FloatField()),
                ('metric', models.FloatField()),
                ('mvalue', models.FloatField()),
                ('ivalue', models.FloatField()),
                ('unittype', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='unititem',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('imperial', models.CharField(max_length=255)),
                ('metric', models.CharField(max_length=255)),
                ('unit', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='unittype',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='UserRating',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('value', models.PositiveIntegerField(default=0, validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(5)])),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('recipe', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='blog_api.blog')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='UserProfile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('age', models.IntegerField(blank=True, null=True)),
                ('weight', models.FloatField(blank=True, null=True)),
                ('height', models.FloatField(blank=True, null=True)),
                ('description', models.CharField(blank=True, max_length=255, null=True)),
                ('image', models.CharField(blank=True, max_length=255, null=True)),
                ('experience', models.IntegerField(blank=True, null=True)),
                ('gender', models.CharField(blank=True, max_length=255, null=True)),
                ('graduated_from', models.CharField(blank=True, max_length=255, null=True)),
                ('cuisines_of_expertise', models.CharField(blank=True, max_length=255, null=True)),
                ('working_at', models.CharField(blank=True, max_length=255, null=True)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='UserBookmark',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('blog', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='blog_api.blog')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Follower',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('follower_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='following', to=settings.AUTH_USER_MODEL)),
                ('following_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='followers', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Eaten',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('eaten_serving', models.FloatField(blank=True, default=1, null=True)),
                ('eatenDate', models.DateTimeField(default=datetime.datetime.today)),
                ('is_active', models.BooleanField(default=True)),
                ('blogId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='blog_api.blog')),
                ('userId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.AddField(
            model_name='blog',
            name='category',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='blog_api.category'),
        ),
        migrations.CreateModel(
            name='Allergy',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('food', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='blog_api.food')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
