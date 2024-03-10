# Generated by Django 4.2.7 on 2024-03-09 18:53

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('blog_api', '0004_rename_category_recipe_categories'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='ingredient',
            name='unit',
        ),
        migrations.AddField(
            model_name='ingredient',
            name='unit',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='blog_api.unit'),
        ),
    ]
