# Generated by Django 4.2.7 on 2024-04-24 07:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blog_api', '0003_alter_foodnutrienttable_fdc_id'),
    ]

    operations = [
        migrations.AddField(
            model_name='blog',
            name='serving',
            field=models.IntegerField(default=4),
        ),
        migrations.AddField(
            model_name='blog',
            name='userid',
            field=models.IntegerField(default=1),
        ),
    ]