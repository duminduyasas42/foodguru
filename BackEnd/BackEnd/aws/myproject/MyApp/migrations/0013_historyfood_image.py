# Generated by Django 4.1.6 on 2023-05-05 14:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('MyApp', '0012_historyfood'),
    ]

    operations = [
        migrations.AddField(
            model_name='historyfood',
            name='image',
            field=models.CharField(default=-1, max_length=200),
            preserve_default=False,
        ),
    ]
