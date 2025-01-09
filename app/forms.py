from django import forms
from django.contrib.auth.forms import AuthenticationForm
from .models import DOE

class DOEForm(forms.ModelForm):
    class Meta:
        model = DOE
        fields = ['titulo', 'descripcion', 'creado_por']
        widgets = {
            'descripcion': forms.Textarea(attrs={'rows': 4}),
        }

class LoginForm(AuthenticationForm):
    username = forms.CharField(label='Nombre de Usuario', max_length=150)
    password = forms.CharField(label='Contraseña', widget=forms.PasswordInput)
