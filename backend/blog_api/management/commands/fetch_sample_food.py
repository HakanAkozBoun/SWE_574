from django.core.management.base import BaseCommand
import csv
from blog_api.models import SampleFood
from django.utils.dateparse import parse_date


class Command(BaseCommand):
    help = "Save the data from the API to the database. Change the path and save."

    def handle(self, *args, **kwargs):
        print('Sample Food Data')
        
        save_sample_food_data_from_csv('/Users/metin/Documents/GitHub/SWE_574/sample_food.csv')

def save_sample_food_data_from_csv(csv_filepath):
    with open(csv_filepath, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            SampleFood.objects.create(
                fdc_id=int(row['fdc_id'])
           )