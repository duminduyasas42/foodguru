from rest_framework import serializers
from .models import DailyNutritionalData, HistoryFood, User
from .models import Food
from .models import FoodDetails

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields=['id','username','sex','weight','height','dob','activityLevel','password']

class FoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Food
        fields=['id','FoodCategory','FoodItem','per100grams','Cals_per100grams','KJ_per100grams']

class FoodDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodDetails
        fields=['id','name','details','units','cals','protein','carbs','suger','fats','fats_saturated','fats_monounsaturated','fats_polyunsaturated','fibre','salt','cholesterol_mg','potassium_mg','image']

class FoodDetailsSerializerGetAllFoodDetails(serializers.ModelSerializer):
    class Meta:
        model = FoodDetails
        fields=['id','name','cals','image']

class DailyNutritionalDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = DailyNutritionalData
        fields=['id','user_id','date','cals','protein','fats','carbs']

class HistoryFoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = HistoryFood
        fields=['user_id','date','food_name','food_id','food_weight','cals','protein','fats','carbs','image']
class FoodRecommendationSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodDetails
        fields=['id','name','cals','image','protein','fats','carbs','units']
