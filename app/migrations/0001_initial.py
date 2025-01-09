# Generated by Django 5.1.4 on 2025-01-08 22:45

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Usuario',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('numero_reloj', models.CharField(max_length=10, unique=True)),
                ('nombre', models.CharField(max_length=100)),
                ('contrasena', models.CharField(max_length=100)),
                ('rol', models.CharField(choices=[('Jr', 'Ingeniero Jr'), ('Sr', 'Ingeniero')], max_length=2)),
            ],
        ),
        migrations.CreateModel(
            name='DOE',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('titulo', models.CharField(max_length=200)),
                ('descripcion', models.TextField()),
                ('fecha_creacion', models.DateTimeField(auto_now_add=True)),
                ('creado_por', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='app.usuario')),
            ],
        ),
    ]
