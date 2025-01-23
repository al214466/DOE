from django import forms
from django.contrib.auth.forms import AuthenticationForm
from .models import DOE, ArchivoFase

class DOEForm(forms.ModelForm):
    class Meta:
        model = DOE
        fields = ['titulo', 'descripcion']  # Campos comunes

    def __init__(self, *args, **kwargs):
        fase_actual = kwargs.pop('fase_actual', None)
        super().__init__(*args, **kwargs)

        # Configurar campos específicos según la fase
        if fase_actual == 'data_mining':
            self.fields['archivo_historial'] = forms.FileField(required=False, label="Archivo Histórico")
        elif fase_actual == 'infrastructure':
            self.fields['materiales'] = forms.CharField(required=True, label="Materiales utilizados")
        elif fase_actual == 'execution':
            self.fields['datos_experimentales'] = forms.CharField(required=True, label="Datos Experimentales")
        elif fase_actual == 'result_final':
            self.fields['conclusiones'] = forms.CharField(required=True, widget=forms.Textarea, label="Conclusiones")

class LoginForm(AuthenticationForm):
    username = forms.CharField(label='Nombre de Usuario', max_length=150)
    password = forms.CharField(label='Contraseña', widget=forms.PasswordInput)

class ArchivoFaseForm(forms.ModelForm):
    class Meta:
        model = ArchivoFase
        fields = ['archivo']