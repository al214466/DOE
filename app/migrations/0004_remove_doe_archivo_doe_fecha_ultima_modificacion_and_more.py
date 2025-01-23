# Generated by Django 5.1.4 on 2025-01-23 01:17

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0003_doe_fase_actual'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='doe',
            name='archivo',
        ),
        migrations.AddField(
            model_name='doe',
            name='fecha_ultima_modificacion',
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.CreateModel(
            name='ArchivoFase',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fase', models.CharField(choices=[('data_mining', 'Data Mining'), ('infrastructure', 'Infrastructure and Material'), ('execution', 'Execution'), ('result_final', 'Result Final')], max_length=20)),
                ('archivo', models.FileField(upload_to='archivos_fases/')),
                ('fecha_subida', models.DateTimeField(auto_now_add=True)),
                ('doe', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='app.doe')),
                ('subido_por', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='HistorialFase',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fase', models.CharField(choices=[('data_mining', 'Data Mining'), ('infrastructure', 'Infrastructure and Material'), ('execution', 'Execution'), ('result_final', 'Result Final')], max_length=20)),
                ('fecha_cambio', models.DateTimeField(auto_now_add=True)),
                ('comentario', models.TextField(blank=True)),
                ('tiempo_transcurrido', models.DurationField(blank=True, null=True)),
                ('cambiado_por', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL)),
                ('doe', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='app.doe')),
            ],
        ),
    ]
