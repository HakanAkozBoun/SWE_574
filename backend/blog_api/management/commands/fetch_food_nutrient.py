from django.core.management.base import BaseCommand
import csv
from blog_api.models import FoodNutrientTable
from django.utils.dateparse import parse_date


class Command(BaseCommand):
    help = "Save the data from the API to the database. Change the path and save."

    def handle(self, *args, **kwargs):
        print('Test')
        
        save_food_nutrient_data_from_csv('C:\\Users\\FA5685\\Desktop\\BOUN_SWE\\Semester3\\SWE574\\SWE_574\\food_nutrient.csv')

def save_food_nutrient_data_from_csv(csv_filepath):
    with open(csv_filepath, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            FoodNutrientTable.objects.create(
                fdc_id=int(row['fdc_id']),
                nutrient_id=int(row['nutrient_id']),
                amount=float(row['amount']),
                data_points=row['data_points'],
                derivation_id=row['derivation_id'],
                min=row['min'],
                max=row['max'],
                median=row['median'],
                loq=row['loq'],
                footnote=row['footnote'],
                min_year_acquired=row['min_year_acquired'],
            )