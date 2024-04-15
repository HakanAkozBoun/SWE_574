from django.core.management.base import BaseCommand
import csv
from blog_api.models import InputFood
from django.utils.dateparse import parse_date


class Command(BaseCommand):
    help = "Save the data from the API to the database. Change the path and save."

    def handle(self, *args, **kwargs):
        
        save_food_data_from_csv('/Users/metin/Documents/GitHub/SWE_574/input_food.csv')

def save_food_data_from_csv(csv_filepath):
    with open(csv_filepath, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            InputFood.objects.create(
                fdc_id=row['fdc_id'],
                seq_num=row['seq_num'],
                amount=row['amount'],
                sr_description=row['sr_description'],
                unit=row['unit'],
                portion_description=row['portion_description'],
                gram_weight=row['gram_weight'],
                retention_code=row['retention_code'],
                survey_flag=row['survey_flag'],
            )
