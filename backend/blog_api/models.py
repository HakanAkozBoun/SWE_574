from django.db import models
from django.contrib.auth.models import User

class food(models.Model):
    name = models.CharField(max_length=255)
    unit = models.IntegerField()

    def __str__(self):
        return self.name
    
class comment(models.Model):
    blog =  models.IntegerField()
    user = models.IntegerField()
    text = models.CharField(max_length=255)
 
    def __str__(self):
        return self.recipe
    
class nutrition(models.Model):
    calorie = models.FloatField()
    fat = models.FloatField()
    sodium = models.FloatField()
    calcium = models.FloatField()
    protein = models.FloatField()
    iron = models.FloatField()
    carbonhydrates = models.FloatField()
    food = models.IntegerField()
 
    def __str__(self):
        return self.unit
 
class recipe(models.Model):
    food = models.IntegerField()
    unit = models.IntegerField()
    amount = models.FloatField()
    blog =  models.IntegerField()
    metricamount = models.IntegerField()
    metricunit = models.IntegerField()
 
    def __str__(self):
        return self.food
    
class unit(models.Model):
    name = models.CharField(max_length=255)
    type = models.IntegerField()
    
    def __str__(self):
        return self.name
 
class unittype(models.Model):
    name = models.CharField(max_length=255)
 
    def __str__(self):
        return self.name
 
class unititem(models.Model):
    imperial = models.CharField(max_length=255)
    metric = models.CharField(max_length=255)
    unit = models.IntegerField()
 
    def __str__(self):
        return self.metric
 
class unitconversion(models.Model):
    imperial = models.FloatField()
    metric = models.FloatField()
    mvalue = models.FloatField()
    ivalue = models.FloatField()
    unittype = models.IntegerField()
 
    def __str__(self):
        return self.metric

class category(models.Model):
    name = models.CharField(max_length=255)
    image = models.ImageField(upload_to='image', null=True, blank=True)

    def __str__(self):
        return self.name

class blog(models.Model):
    POST_CHOICES = [
        ('POPULAR', 'Popular')
    ]
    category = models.ForeignKey(category, on_delete=models.CASCADE, null=True)
    title = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255)
    excerpt = models.CharField(max_length=255, default='')
    content = models.TextField(null=True, blank=True)
    contentTwo = models.TextField(null=True, blank=True)
    image = models.ImageField(upload_to='image', null=True, blank=True)
    ingredients = models.TextField(null=True, blank=True)
    postlabel = models.CharField(max_length=100, choices=POST_CHOICES,null=True, blank=True)

    def __str__(self):
        return self.title

class FoodTable(models.Model):

    fdc_id = models.IntegerField()
    data_type = models.CharField(max_length=255)
    description = models.CharField(max_length=255)
    food_category_id = models.CharField(null=True, blank=True, max_length=255)
    publication_date = models.DateField()
    
    def __str__(self):
        return self.description
    
class FoodNutrient(models.Model):

    name = models.CharField(max_length=255, null=True, blank=True)
    unit_name = models.CharField(max_length=255, null=True, blank=True)
    nutrient_nbr = models.CharField(null=True, blank=True, max_length=255)
    rank = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return self.name
    
class FoundationFood(models.Model):

    fdc_id = models.IntegerField()
    NDB_number = models.IntegerField()
    footnote = models.CharField(max_length=255) 

class SampleFood(models.Model):

    fdc_id = models.IntegerField()

class InputFood(models.Model):

    fdc_id = models.IntegerField(null=True, blank=True)
    seq_num = models.IntegerField(null=True, blank=True)
    amount = models.FloatField(null=True, blank=True)
    sr_description = models.CharField(null=True, blank=True, max_length=255)
    unit = models.CharField(null=True, blank=True, max_length=255)
    portion_description = models.CharField(null=True, blank=True, max_length=255)
    gram_weight = models.FloatField(null=True, blank=True)
    retention_code = models.CharField(null=True, blank=True, max_length=255)
    survey_flag = models.CharField(null=True, blank=True, max_length=255)


# NEW MODELS
# -------------------------------------------------------------------------------------------
class UserBookmark(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    blog = models.ForeignKey(blog, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
