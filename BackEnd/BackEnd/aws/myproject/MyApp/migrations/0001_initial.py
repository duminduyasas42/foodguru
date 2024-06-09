# Generated by Django 4.1.6 on 2023-04-27 14:12

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Food',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('FoodCategory', models.CharField(max_length=200)),
                ('FoodItem', models.CharField(max_length=200)),
                ('per100grams', models.CharField(max_length=200)),
                ('Cals_per100grams', models.CharField(max_length=200)),
                ('KJ_per100grams', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='FoodDetails',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200)),
                ('details', models.CharField(max_length=500)),
                ('cals_per100grams', models.IntegerField()),
                ('protein_per100grams', models.IntegerField()),
                ('carbs_per100grams', models.IntegerField()),
                ('fats_per100grams', models.IntegerField()),
                ('image', models.ImageField(upload_to='images/')),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(max_length=200, unique=True)),
                ('password', models.CharField(max_length=200)),
                ('sex', models.CharField(choices=[('Male', 'Male'), ('Female', 'Female')], max_length=7)),
                ('weight', models.IntegerField()),
                ('height', models.IntegerField()),
                ('dob', models.DateField()),
                ('activityLevel', models.CharField(choices=[('Sedentary', 'Sedentary'), ('Lightly', 'Lightly'), ('Moderately', 'Moderately'), ('Very', 'Very'), ('Extremely', 'Extremely')], max_length=20)),
            ],
        ),
    ]
