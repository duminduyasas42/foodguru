from decimal import Decimal
from django.shortcuts import render

# Create your views here.

from django.http import JsonResponse
from .models import DailyNutritionalData, FoodDetails, HistoryFood, User, DailyNutritionalData
from .serializers import DailyNutritionalDataSerializer, FoodDetailsSerializerGetAllFoodDetails, FoodRecommendationSerializer, HistoryFoodSerializer, UserSerializer
from .serializers import FoodDetailsSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

import tensorflow as tf
from tensorflow.keras.models import load_model
import numpy as np
import os
from io import BytesIO
from django.core.files.uploadedfile import InMemoryUploadedFile


@api_view(['POST'])
def users(request, format=None):
    if request.method == 'POST':
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def user_detail(request, id, format=None):
    try:
        user = User.objects.get(pk=id)
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = UserSerializer(user)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = UserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['GET'])
def food_detail(request, id, format=None):
    try:
        food = FoodDetails.objects.get(pk=id)
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        # print("===================")
        # print(vars(food))
        serializer = FoodDetailsSerializer(food)
        return Response(serializer.data)


@api_view(['GET'])
def food_list(request, format=None):
    if request.method == 'GET':
        # get drinks all
        food = FoodDetails.objects.all()
        # serialize them
        serializer = FoodDetailsSerializerGetAllFoodDetails(food, many=True)
        # return as json
        return Response(serializer.data)


@api_view(['POST'])
def verifyUser(request, format=None):
    if request.method == 'POST':
        try:
            user = User.objects.get(username=request.data["username"])
        except User.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        if (user.password == request.data["password"]):
            serializer = UserSerializer(user)
            return Response(serializer.data)
        else:
            return Response(status=status.HTTP_403_FORBIDDEN)

    # if request.method=='GET':
    #     serializer=UserSerializer(user)
    #     return Response(serializer.data)


@api_view(['POST'])
def food_detail_for_image(request):
    if request.method == 'POST':
        class_names = ['Apple Pie', 'baby_back_ribs', 'baklava', 'beef_carpaccio', 'beef_tartare', 'beet_salad', 'beignets', 'bibimbap', 'bread_pudding', 'breakfast_burrito', 'bruschetta', 'caesar_salad', 'cannoli', 'caprese_salad', 'carrot_cake', 'ceviche', 'cheese_plate', 'cheesecake', 'chicken_curry', 'chicken_quesadilla', 'chicken_wings', 'chocolate_cake', 'chocolate_mousse', 'churros', 'clam_chowder', 'club_sandwich', 'crab_cakes', 'creme_brulee', 'croque_madame', 'cup_cakes', 'deviled_eggs', 'donuts', 'dumplings', 'edamame', 'eggs_benedict', 'escargots', 'falafel', 'filet_mignon', 'fish_and_chips', 'foie_gras', 'french_fries', 'french_onion_soup', 'french_toast', 'fried_calamari', 'fried_rice', 'frozen_yogurt', 'garlic_bread', 'gnocchi',
                       'greek_salad', 'grilled_cheese_sandwich', 'grilled_salmon', 'guacamole', 'gyoza', 'hamburger', 'hot_and_sour_soup', 'hot_dog', 'huevos_rancheros', 'hummus', 'ice_cream', 'lasagna', 'lobster_bisque', 'lobster_roll_sandwich', 'macaroni_and_cheese', 'macarons', 'miso_soup', 'mussels', 'nachos', 'omelette', 'onion_rings', 'oysters', 'pad_thai', 'paella', 'pancakes', 'panna_cotta', 'peking_duck', 'pho', 'pizza', 'pork_chop', 'poutine', 'prime_rib', 'pulled_pork_sandwich', 'ramen', 'ravioli', 'red_velvet_cake', 'risotto', 'samosa', 'sashimi', 'scallops', 'seaweed_salad', 'shrimp_and_grits', 'spaghetti_bolognese', 'spaghetti_carbonara', 'spring_rolls', 'steak', 'strawberry_shortcake', 'sushi', 'tacos', 'takoyaki', 'tiramisu', 'tuna_tartare', 'waffles']
        image_file = request.FILES['image'].read()
        if image_file:
            print("ddddddddddddddddddddddddddddddddd")
            image_stream = BytesIO(image_file)
            image = tf.keras.preprocessing.image.load_img(
                image_stream, target_size=(256, 256))
            image_array = tf.keras.preprocessing.image.img_to_array(image)
            image_array = tf.expand_dims(image_array, 0)
            BASE_DIR = os.path.dirname(
                os.path.dirname(os.path.abspath(__file__)))
            file_path = os.path.join(
                BASE_DIR, 'MyApp', 'models1', 'imageclassifier.h5')
            print(file_path)
            model = load_model(file_path)
            score = model.predict(image_array)
            print("============================================================")

            try:
                Food = FoodDetails.objects.get(
                    name=class_names[np.argmax(score)])

            except FoodDetails.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)

            if request.method == 'POST':
                print(Food)
                serializer = FoodDetailsSerializer(Food)
               #  print(serializer.data)
                print(class_names[np.argmax(score)], 100 * np.max(score))
                return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(status=status.HTTP_403_FORBIDDEN)


@api_view(['POST'])
def dailyNutritionforUser(request, format=None):
    if request.method == 'POST':
        print("=========================================================")
        try:
            dailyNutritionalData = DailyNutritionalData.objects.get(
                user_id=request.data["user_id"], date=request.data["date"])

        except DailyNutritionalData.DoesNotExist:
            print(request.data)
            serializer1 = DailyNutritionalDataSerializer(
                data={'user_id': request.data["user_id"], 'date': request.data["date"], 'cals': '0', 'protein': '0', 'carbs': '0', 'fats': '0'})
            if serializer1.is_valid():
                serializer1.save()
                return Response(serializer1.data, status=status.HTTP_201_CREATED)
            else:
                return Response(serializer1.errors, status=status.HTTP_400_BAD_REQUEST)

        serializer = DailyNutritionalDataSerializer(dailyNutritionalData)
        return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['POST'])
def addFoodUser(request, format=None):
    if request.method == 'POST':
        print("=========================================================")
        try:
            dailyNutritionalData = DailyNutritionalData.objects.get(
                user_id=request.data["user_id"], date=request.data["date"])
            data = {'user_id': request.data["user_id"], 'date': request.data["date"], 'cals': dailyNutritionalData.cals + Decimal(request.data['cals']), 'protein': dailyNutritionalData.protein + Decimal(
                request.data['protein']), 'carbs': dailyNutritionalData.carbs + Decimal(request.data['carbs']), 'fats': dailyNutritionalData.fats + Decimal(request.data['fats'])}
            print(dailyNutritionalData.protein, dailyNutritionalData.carbs, dailyNutritionalData.fats,
                  dailyNutritionalData.cals, dailyNutritionalData.user_id, dailyNutritionalData.date)
            serializer1 = DailyNutritionalDataSerializer(
                dailyNutritionalData, data=data)
            food = FoodDetails.objects.get(pk=request.data["food_id"])
            print(food.image.name)
            data2 = {'user_id': request.data["user_id"],
                     'date': request.data["date"],
                     'food_id': request.data["food_id"],
                     'food_name': request.data["food_name"],
                     'food_weight': request.data["food_weight"],
                     'cals': request.data["cals"],
                     'protein': request.data["protein"],
                     'fats': request.data["fats"],
                     'carbs': request.data["carbs"],
                     'image': food.image.name}
            serializer2 = HistoryFoodSerializer(data=data2)
            if serializer2.is_valid():
                serializer2.save()
            else:
                return Response(serializer1.errors, status=status.HTTP_400_BAD_REQUEST)

            if serializer1.is_valid():
                serializer1.save()
                return Response(serializer1.data, status=status.HTTP_201_CREATED)
            else:
                return Response(serializer1.errors, status=status.HTTP_400_BAD_REQUEST)

        except DailyNutritionalData.DoesNotExist:
            return Response(status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def food_history_list(request, format=None):
    if request.method == 'POST':
        # get drinks all
        foodHistory = HistoryFood.objects.filter(
            user_id=request.data["user_id"], date=request.data["date"])
        # serialize them
        serializer = HistoryFoodSerializer(foodHistory, many=True)
        # return as json
        return Response(serializer.data)


@api_view(['POST'])
def food_Recommendation(request, format=None):
    if request.method == 'POST':
        # get drinks all
        food = FoodDetails.objects.filter(
            cals__lt=request.data["cals"], protein__lt=request.data["protein"], carbs__lt=request.data["carbs"], fats__lt=request.data["fats"])
        # serialize them
        if (food.exists()):
            serializer = FoodRecommendationSerializer(food, many=True)
            return Response(serializer.data)
        else:
            food = FoodDetails.objects.order_by('cals')[:10]
            serializer = FoodRecommendationSerializer(food, many=True)
            return Response(serializer.data)
