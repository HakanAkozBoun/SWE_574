# Generated by Django 3.2.16 on 2024-03-19 14:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blog_api', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='FoodNutrient',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('unit_name', models.CharField(max_length=255)),
                ('nutrient_nbr', models.IntegerField()),
                ('rank', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='FoodTable',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fdc_id', models.IntegerField()),
                ('data_type', models.CharField(max_length=255)),
                ('description', models.CharField(max_length=255)),
                ('food_category_id', models.CharField(blank=True, null=True)),
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
            name='SampleFood',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fdc_id', models.IntegerField()),
            ],
        ),
    ]
