from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
from django.utils.timezone import now

class Equipo(models.Model):
    nombre = models.CharField(max_length=100)
    creado_por = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)  # Ingeniero que crea el equipo
    miembros = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name="equipos")

    def __str__(self):
        return self.nombre

class Usuario(AbstractUser):
    TURNOS = [
        (1, "1er Turno"),
        (2, "2do Turno"),
        (3, "3er Turno"),
        (4, "4to Turno"),
    ]
    turno = models.IntegerField(choices=TURNOS, null=True, blank=True)
    ROLES = [
        ('Jr', 'Ingeniero Jr'),
        ('Sr', 'Ingeniero'),
    ]
    numero_reloj = models.CharField(max_length=10, unique=False)
    nombre = models.CharField(max_length=100)
    rol = models.CharField(max_length=2, choices=ROLES, default='Jr')

    def __str__(self):
        return self.nombre

class DOE(models.Model):
    FASES = [
        ('infrastructure_and_material', 'Infrastructure and Material'),
        ('data_mining', 'Data Mining'),
        ('analysis', 'Analysis'),
        ('result_final', 'Result Final'),
    ]

    titulo = models.CharField(max_length=255)
    descripcion = models.TextField()
    creado_por = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    fase_actual = models.CharField(max_length=50, choices=FASES, default='infrastructure_and_material')
    ejecucion_completed = models.BooleanField(default=False)
    fases = models.ManyToManyField('DOE_Fase', related_name="does")
    archivo_te = models.FileField(upload_to="archivos_te/", null=True, blank=True)  # Debe existir este campo
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_ultima_modificacion = models.DateTimeField(auto_now=True)
    finalizado = models.BooleanField(default=False)
    data_mining_completed = models.BooleanField(default=False)
    infrastructure_completed = models.BooleanField(default=False)
    execution_completed = models.BooleanField(default=False)
    result_final_completed = models.BooleanField(default=False)
    PRIORIDAD_CHOICES = [
    ('High', 'High'),
    ('Medium', 'Medium'),
    ('Low', 'Low'),
    ]

    prioridad = models.CharField(max_length=10, choices=PRIORIDAD_CHOICES, default="Medium")
    equipo = models.ForeignKey(Equipo, on_delete=models.SET_NULL, null=True, blank=True)  # Nuevo campo

    def __str__(self):
        return self.titulo

class ArchivoFase(models.Model):
    doe = models.ForeignKey('DOE', on_delete=models.CASCADE)
    fase = models.CharField(max_length=100, choices=DOE.FASES)
    archivo = models.FileField(upload_to='archivos_fases/')
    subido_por = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True)
    fecha_subida = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.archivo.name} ({self.fase})"

class HistorialFase(models.Model):
    doe = models.ForeignKey(DOE, on_delete=models.CASCADE)
    fase = models.CharField(max_length=100, choices=DOE.FASES)
    cambiado_por = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True)
    fecha_cambio = models.DateTimeField(auto_now_add=True)
    comentario = models.TextField(blank=True)
    tiempo_transcurrido = models.DurationField(null=True, blank=True)



class DOE_Fase(models.Model):
    NOMBRES_FASES = [
        ('infrastructure_and_material', 'Infrastructure and Material'),
        ('data_mining', 'Data Mining'),
        ('final_review', 'Final Review'),
        ('completed', 'Completed'),
    ]
    doe = models.ForeignKey(DOE, on_delete=models.CASCADE, related_name="fases_relacionadas")
    nombre_fase = models.CharField(max_length=50, choices=NOMBRES_FASES)
    estado = models.CharField(max_length=20, default="En progreso")
    fecha_inicio = models.DateTimeField(auto_now_add=True)
    fecha_finalizacion = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"{self.doe.titulo} - {self.get_nombre_fase_display()}"
    
class TurnoComentario(models.Model):
    doe = models.ForeignKey(DOE, on_delete=models.CASCADE)
    usuario = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    comentario = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ['doe', 'usuario']  # Un comentario por usuario en cada DOE

    def __str__(self):
        return f"Comentario de {self.usuario} en {self.doe.titulo}"

class Comentario(models.Model):
    doe = models.ForeignKey('DOE', on_delete=models.CASCADE, related_name='comentarios')
    autor = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    contenido = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Comentario de {self.autor} en {self.doe}"
    
class ChatMessage(models.Model):
    doe = models.ForeignKey("DOE", on_delete=models.CASCADE, related_name="mensajes")
    usuario = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    mensaje = models.TextField(blank=True, null=True)
    imagen = models.ImageField(upload_to="chat_images/", blank=True, null=True)
    fecha_envio = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.usuario} - {self.mensaje[:30]}"
    
# 1. Data Mining
class DataMining(models.Model):
    doe = models.OneToOneField(DOE, on_delete=models.CASCADE, related_name="data_mining")
    issue = models.TextField()
    excel_data = models.FileField(upload_to='data_mining/')
    dr = models.TextField()

# 2. Infrastructure and Material
class InfrastructureMaterial(models.Model):
    doe = models.OneToOneField(DOE, on_delete=models.CASCADE, related_name="infrastructure")
    collect_material = models.CharField(
        max_length=10, 
        choices=[('material', 'Material'), ('unidad', 'Unidad')], 
        default='material'  # 🔹 Valor por defecto
    )    
    # Campos para Material
    material_name = models.CharField(max_length=255, blank=True, null=True)
    material_sn = models.CharField(max_length=255, blank=True, null=True)
    material_pn = models.CharField(max_length=255, blank=True, null=True)
    
    # Campos para Unidad
    rack = models.CharField(max_length=255, blank=True, null=True)
    test_list = models.TextField(blank=True, null=True)
    bay = models.CharField(max_length=255, blank=True, null=True)

# 3. Execution
class Execution(models.Model):
    doe = models.OneToOneField('DOE', on_delete=models.CASCADE, related_name="execution")
    link = models.URLField(blank=True, null=True)
    pic = models.CharField(max_length=255)
    executive_summary = models.FileField(upload_to='executive_summaries/', blank=True, null=True)
    status_per_pic = models.TextField(blank=True, null=True)


    def __str__(self):
        return f"Ejecución - {self.doe.nombre}"
    
class ExecutionLink(models.Model):
    execution = models.ForeignKey(Execution, on_delete=models.CASCADE, related_name="links")
    url = models.URLField()
    created_at = models.DateTimeField(auto_now_add=True)

class ExecutiveSummary(models.Model):
    execution = models.ForeignKey(Execution, on_delete=models.CASCADE, related_name="summaries")
    file = models.FileField(upload_to="executive_summaries/")
    uploaded_at = models.DateTimeField(auto_now_add=True)

class Status(models.Model):
    execution = models.ForeignKey(Execution, on_delete=models.CASCADE, related_name="statuses")
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    status = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.created_at.strftime('%Y-%m-%d %H:%M')}"

# 4. Result Final
class ResultFinal(models.Model):
    doe = models.OneToOneField('DOE', on_delete=models.CASCADE, related_name="result_final")
    conclusion = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"Resultado Final de {self.doe.nombre}"

class PPTFile(models.Model):
    doe = models.ForeignKey('DOE', on_delete=models.CASCADE, related_name="ppt_files")
    file = models.FileField(upload_to="ppt_files/")
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"PPT de {self.doe.nombre} - {self.uploaded_at}"
class Material(models.Model):
    infrastructure = models.ForeignKey(InfrastructureMaterial, on_delete=models.CASCADE, related_name="materials")
    material_name = models.CharField(max_length=255, blank=True, null=True)
    material_sn = models.CharField(max_length=255, blank=True, null=True)
    material_pn = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return f"{self.material_name} - SN: {self.material_sn} - PN: {self.material_pn}"

class Unidad(models.Model):
    infrastructure = models.ForeignKey(InfrastructureMaterial, on_delete=models.CASCADE, related_name="unidades")
    rack_sn = models.CharField(max_length=255, blank=True, null=True)
    rn_number = models.CharField(max_length=255, blank=True, null=True)
    unit_sn = models.CharField(max_length=255, blank=True, null=True)
    bay = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return f"Unidad: {self.rack_sn} - RN: {self.rn_number} - SN: {self.unit_sn} - 📍 {self.bay}"
