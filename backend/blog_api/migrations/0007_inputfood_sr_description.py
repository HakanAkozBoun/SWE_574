# Generated by Django 3.2.16 on 2024-04-18 09:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('blog_api', '0006_merge_0002_userbookmark_0005_inputfood'),
    ]

    operations = [
        migrations.AddField(
            model_name='inputfood',
            name='sr_description',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]
