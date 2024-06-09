from django.contrib import admin

# Register your models here.
from .models import User
from .models import Food
from .models import FoodDetails
from .models import DailyNutritionalData
from .models import HistoryFood


admin.site.register(User)
admin.site.register(Food)
admin.site.register(FoodDetails)
admin.site.register(DailyNutritionalData)
admin.site.register(HistoryFood)