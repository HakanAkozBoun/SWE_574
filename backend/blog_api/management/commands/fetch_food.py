from django.core.management.base import BaseCommand
import csv
from blog_api.models import FoodTable
from django.utils.dateparse import parse_date


class Command(BaseCommand):
    help = "Save the data from the API to the database. Change the path and save."

    def handle(self, *args, **kwargs):
        print('Test')
        
        save_food_data_from_csv('/Users/metin/Documents/GitHub/SWE_574/food.csv')

def save_food_data_from_csv(csv_filepath):
    with open(csv_filepath, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            food_category_id = int(row['food_category_id']) if row['food_category_id'] else None
            publication_date = parse_date(row['publication_date'])
            FoodTable.objects.create(
                fdc_id=int(row['fdc_id']),
                data_type=row['data_type'],
                description=row['description'],
                food_category_id=food_category_id,
                publication_date=publication_date
            )
