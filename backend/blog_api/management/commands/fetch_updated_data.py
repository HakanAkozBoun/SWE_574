import pandas as pd
from django.core.management.base import BaseCommand
from blog_api.models import nutrition


class Command(BaseCommand):
    help = "Save the data from the Excel file to the database. Change the path and save."

    def handle(self, *args, **kwargs):
        print('Food Nutrient Data')

        excel_filepath = 'C:\\Users\\FA5685\\Desktop\\BOUN_SWE\\Semester3\\SWE574\\SWE_574\\updated_food_data.xlsx'
        save_sample_food_data_from_excel(excel_filepath)


def save_sample_food_data_from_excel(excel_filepath):

    df = pd.read_excel(excel_filepath)

    for index, row in df.iterrows():
        nutrition.objects.create(
            food=int(row['food']),
            calorie=float(row['calorie']),
            fat=float(row['fat']),
            sodium=float(row['sodium']),
            calcium=float(row['calcium']),
            protein=float(row['protein']),
            iron=float(row['iron']),
            carbonhydrates=float(row['carbonhydrates']),
            sugars=float(row['Sugars']),
            fiber=float(row['Fiber']),
            vitamina=float(row['Vitamin A']),
            vitaminb=float(row['Vitamin B']),
            vitamind=float(row['Vitamin D']),
        )