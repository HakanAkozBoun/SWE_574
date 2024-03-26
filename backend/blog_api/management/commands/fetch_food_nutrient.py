from django.core.management.base import BaseCommand
import csv
from blog_api.models import FoodNutrient
from django.utils.dateparse import parse_date


class Command(BaseCommand):
    help = "Save the data from the API to the database. Change the path and save."

    def handle(self, *args, **kwargs):
        print('Food Nutrient Data')
        
        save_food_nutrient_data_from_csv('/Users/metin/Documents/GitHub/SWE_574/nutrient.csv')

def save_food_nutrient_data_from_csv(csv_filepath):
    with open(csv_filepath, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            FoodNutrient.objects.create(
                name=row['name'],
                unit_name=row['unit_name'],
                nutrient_nbr=(row['nutrient_nbr']),
              )