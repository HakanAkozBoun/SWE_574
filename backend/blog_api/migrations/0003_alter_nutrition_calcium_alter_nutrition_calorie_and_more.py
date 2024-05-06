# Generated by Django 4.2.7 on 2024-04-30 11:46

import datetime
from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('blog_api', '0002_allergy'),
    ]

    operations = [
        migrations.AlterField(
            model_name='nutrition',
            name='calcium',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='calorie',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='carbonhydrates',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='fat',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='fiber',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='iron',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='protein',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='sodium',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='sugars',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='vitamina',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='vitaminb',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='nutrition',
            name='vitamind',
            field=models.FloatField(null=True),
        ),
        migrations.AlterField(
            model_name='userprofile',
            name='image',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
        migrations.CreateModel(
            name='Eaten',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('eatenPercentage', models.IntegerField(default=100)),
                ('eatenDate', models.DateTimeField(default=datetime.datetime.today)),
                ('is_active', models.BooleanField(default=True)),
                ('blogId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='blog_api.blog')),
                ('userId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]