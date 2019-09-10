from django.db import models

# Create your models here.


class Category(models.Model):
    count = models.IntegerField()
    name = models.CharField(max_length=255, null=False)

    def __str__(self):
        return "Category name: {}, Category count: ".format(self.name, self.count)


class Images(models.Model):
    english_definition = models.CharField(max_length=255, null=False)
    foreign_definition = models.CharField(max_length=255, null=False)
    foreign_language = models.CharField(max_length=255, null=False)
    category = models.CharField(max_length=255, null=False)

    def __str__(self):
        return "English definition: {}. Foreign language definition: {}. Foreign language: ".format(self.english_definition, self.foreign_definition, self.foreign_language)
