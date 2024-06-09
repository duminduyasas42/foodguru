from django.db import models

# Create your models here.




class User(models.Model):
    username = models.CharField(max_length=200,unique=True)
    password = models.CharField(max_length=200)
    sexType = models.TextChoices("sexType", "Male Female")
    sex = models.CharField(choices=sexType.choices,max_length=7)
    weight=models.IntegerField()
    height = models.IntegerField()
    dob = models.DateField()
    activityLevelType = models.TextChoices("activityLevelType", "Sedentary Lightly Moderately Very Extremely")
    activityLevel=models.CharField(choices=activityLevelType.choices,max_length=20)

    class Meta:
        app_label = 'MyApp'

class Food(models.Model):
    FoodCategory = models.CharField(max_length=200)
    FoodItem = models.CharField(max_length=200)
    per100grams = models.CharField(max_length=200)
    Cals_per100grams = models.CharField(max_length=200)
    KJ_per100grams = models.CharField(max_length=200)

    class Meta:
        app_label = 'MyApp'

class FoodDetails(models.Model):
    name = models.CharField(max_length=200)
    details = models.CharField(max_length=600)
    units = models.CharField(max_length=200)
    cals = models.IntegerField()
    protein = models.DecimalField(max_digits=5, decimal_places=2)
    carbs = models.DecimalField(max_digits=5, decimal_places=2)
    suger = models.DecimalField(max_digits=5, decimal_places=2)
    fats = models.DecimalField(max_digits=5, decimal_places=2)
    fats_saturated = models.DecimalField(max_digits=5, decimal_places=2)
    fats_monounsaturated = models.DecimalField(max_digits=5, decimal_places=2)
    fats_polyunsaturated = models.DecimalField(max_digits=5, decimal_places=2)
    fibre = models.DecimalField(max_digits=5, decimal_places=2)
    salt = models.DecimalField(max_digits=5, decimal_places=2)
    cholesterol_mg = models.DecimalField(max_digits=5, decimal_places=2)
    potassium_mg = models.DecimalField(max_digits=5, decimal_places=2)
    image=models.ImageField(upload_to='images/',null=True)



    class Meta:
        app_label = 'MyApp'


class DailyNutritionalData(models.Model):
    user_id = models.CharField(max_length=200)
    date = models.DateField()
    cals = models.IntegerField()
    protein =  models.DecimalField(max_digits=5, decimal_places=2)
    fats = models.DecimalField(max_digits=5, decimal_places=2)
    carbs =  models.DecimalField(max_digits=5, decimal_places=2)

    class Meta:
        app_label = 'MyApp'

class HistoryFood(models.Model):
    user_id = models.CharField(max_length=200)
    date = models.DateField()
    food_id = models.CharField(max_length=200)
    food_name = models.CharField(max_length=200)
    food_weight = models.IntegerField()
    cals = models.IntegerField()
    protein =  models.DecimalField(max_digits=10, decimal_places=2)
    fats = models.DecimalField(max_digits=10, decimal_places=2)
    carbs =  models.DecimalField(max_digits=10, decimal_places=2)
    image = models.CharField(max_length=200)

    class Meta:
        app_label = 'MyApp'