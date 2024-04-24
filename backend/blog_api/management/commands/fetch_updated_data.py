from django.core.management.base import BaseCommand
import csv
from blog_api.models import nutrition
from django.utils.dateparse import parse_date


class Command(BaseCommand):
    help = "Save the data from the API to the database. Change the path and save."

    def handle(self, *args, **kwargs):
        print('Food Nutrient Data')
        
        save_sample_food_data_from_csv('/Users/metin/Documents/GitHub/SWE_574/backend/blog_api/management/commands/updated_food_data (1).xlsx')

def save_sample_food_data_from_csv(csv_filepath):
    with open(csv_filepath, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            nutrition.objects.create(
                food = int(row['food']),
                calorie = float(row['calorie']),
                fat = float(row['fat']),
                sodium = float(row['sodium']),
                calcium = float(row['calcium']),
                protein = float(row['protein']),
                iron = float(row['iron']),
                carbonhydrates = float(row['carbonhydrates']),
                sugars = float(row['Sugars']),
                fiber = float(row['Fiber']),
                vitamina = float(row['Vitamin A']),
                vitaminb = float(row['Vitamin B']),
                vitamind = float(row['Vitamin D']),
           )