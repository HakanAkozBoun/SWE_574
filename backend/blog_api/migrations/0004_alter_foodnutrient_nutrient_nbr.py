# Generated by Django 3.2.16 on 2024-03-26 11:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blog_api', '0003_auto_20240326_1114'),
    ]

    operations = [
        migrations.AlterField(
            model_name='foodnutrient',
            name='nutrient_nbr',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]