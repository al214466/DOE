from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings



# Modelo para usuarios
class Usuario(AbstractUser):
    ROLES = [
        ('Jr', 'Ingeniero Jr'),
        ('Sr', 'Ingeniero'),
    ]
    numero_reloj = models.CharField(max_length=10, unique=True)
    nombre = models.CharField(max_length=100)
    rol = models.CharField(max_length=2, choices=ROLES, default='Jr')

    def __str__(self):
        return self.nombre
# Modelo para los DOE
class DOE(models.Model):
    FASES = [
        ('data_mining', 'Data Mining'),
        ('infrastructure', 'Infrastructure and Material'),
        ('execution', 'Execution'),
        ('result_final', 'Result Final'),
    ]
    titulo = models.CharField(max_length=100)
    descripcion = models.TextField()
    fase_actual = models.CharField(max_length=20, choices=FASES, default='data_mining')
    creado_por = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_ultima_modificacion = models.DateTimeField(auto_now=True)

class ArchivoFase(models.Model):
    doe = models.ForeignKey('DOE', on_delete=models.CASCADE)
    fase = models.CharField(max_length=20, choices=DOE.FASES)
    archivo = models.FileField(upload_to='archivos_fases/')
    subido_por = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True)
    fecha_subida = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.archivo.name} ({self.fase})"

class HistorialFase(models.Model):
    doe = models.ForeignKey(DOE, on_delete=models.CASCADE)
    fase = models.CharField(max_length=20, choices=DOE.FASES)
    cambiado_por = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True)
    fecha_cambio = models.DateTimeField(auto_now_add=True)
    comentario = models.TextField(blank=True)
    tiempo_transcurrido = models.DurationField(null=True, blank=True)

class Material(models.Model):
    doe = models.ForeignKey(DOE, on_delete=models.CASCADE)
    material = models.CharField(max_length=100)
    serial_number = models.CharField(max_length=100, null=True, blank=True)
    pn = models.CharField(max_length=100, null=True, blank=True)
    fecha_agregado = models.DateTimeField(auto_now_add=True)
    
