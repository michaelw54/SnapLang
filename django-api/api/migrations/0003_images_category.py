# Generated by Django 2.1.5 on 2019-09-07 18:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_images_foreign_language'),
    ]

    operations = [
        migrations.AddField(
            model_name='images',
            name='category',
            field=models.CharField(default='gye', max_length=255),
            preserve_default=False,
        ),
    ]
