from django.db import models
from django.contrib.auth.models import AbstractUser


# Modelo para usuarios
class Usuario(AbstractUser):
    ROLES = [
        ('Jr', 'Ingeniero Jr'),
        ('Sr', 'Ingeniero'),
    ]
    numero_reloj = models.CharField(max_length=10, unique=True)
    nombre = models.CharField(max_length=100)
    contrasena = models.CharField(max_length=100)
    rol = models.CharField(max_length=2, choices=ROLES, default='Jr')

    def __str__(self):
        return self.nombre

# Modelo para los DOE
class DOE(models.Model):
    titulo = models.CharField(max_length=200)
    descripcion = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    creado_por = models.ForeignKey(Usuario, on_delete=models.CASCADE)

    def __str__(self):
        return self.titulo
