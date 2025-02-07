from django import forms
from django.contrib.auth.forms import AuthenticationForm
from .models import DOE, ArchivoFase, Comentario
from .models import DOE_Fase, TurnoComentario, Material
from .models import DataMining, InfrastructureMaterial, Execution, ResultFinal, Unidad, Status, ExecutionLink, ExecutiveSummary, PPTFile



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

class DOEForm(forms.ModelForm):
    fases = forms.ModelMultipleChoiceField(
        queryset=DOE_Fase.objects.all(),
        widget=forms.CheckboxSelectMultiple,
        required=True
    )

    class Meta:
        model = DOE
        fields = ['titulo', 'descripcion', 'fases']

class TurnoComentarioForm(forms.ModelForm):
    class Meta:
        model = TurnoComentario
        fields = ['comentario']

class ComentarioForm(forms.ModelForm):
    class Meta:
        model = Comentario
        fields = ['contenido']

class DataMiningForm(forms.ModelForm):
    class Meta:
        model = DataMining
        fields = ['issue', 'excel_data', 'dr']
        widgets = {
            'issue': forms.Textarea(attrs={'class': 'form-control', 'rows': 3, 'placeholder': 'Describe el issue...'}),
            'excel_data': forms.ClearableFileInput(attrs={'class': 'form-control'}),
            'dr': forms.Textarea(attrs={'class': 'form-control', 'rows': 3, 'placeholder': 'Detalles del DR...'}),
        }

class InfrastructureMaterialForm(forms.ModelForm):
    class Meta:
        model = InfrastructureMaterial
        fields = ['collect_material', 'material_name', 'material_sn', 'material_pn', 'rack', 'test_list', 'bay']
        widgets = {
            'collect_material': forms.Select(attrs={'class': 'form-select small-input rounded-pill border-primary shadow-sm'}),
            'material_name': forms.TextInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
            'material_sn': forms.TextInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
            'material_pn': forms.TextInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
            'rack': forms.TextInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
            'test_list': forms.Textarea(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
            'bay': forms.TextInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
        }

class ExecutionForm(forms.ModelForm):
    class Meta:
        model = Execution
        fields = ['link', 'pic', 'executive_summary']

class StatusForm(forms.ModelForm):
    class Meta:
        model = Status
        fields = ['status']
        widgets = {
            'status': forms.Textarea(attrs={'class': 'form-control', 'rows': 3, 'placeholder': 'Escribe el estado aquí...'}),
        }

class ResultFinalForm(forms.ModelForm):
    class Meta:
        model = ResultFinal
        fields = ['conclusion']
        widgets = {
            'conclusion': forms.Textarea(attrs={'class': 'form-control', 'rows': 3, 'placeholder': 'Escribe la conclusión aquí...'}),
        }

class PPTFileForm(forms.ModelForm):
    class Meta:
        model = PPTFile
        fields = ['file']

class MaterialForm(forms.ModelForm):
    class Meta:
        model = Material
        fields = ['material_name', 'material_sn', 'material_pn']
        widgets = {
            'material_name': forms.TextInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
            'material_sn': forms.TextInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
            'material_pn': forms.TextInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm'}),
        }

class UnidadForm(forms.ModelForm):
    class Meta:
        model = Unidad
        fields = ['rack_sn', 'rn_number', 'unit_sn', 'bay']
        widgets = {
            'rack_sn': forms.TextInput(attrs={'class': 'form-control'}),
            'rn_number': forms.TextInput(attrs={'class': 'form-control'}),
            'unit_sn': forms.TextInput(attrs={'class': 'form-control'}),
            'bay': forms.TextInput(attrs={'class': 'form-control'}),
        }

class ExecutiveSummaryForm(forms.ModelForm):
    class Meta:
        model = ExecutiveSummary
        fields = ['file']
    
class LinkForm(forms.ModelForm):
    class Meta:
        model = ExecutionLink
        fields = ['url']
        widgets = {
            'url': forms.URLInput(attrs={'class': 'form-control small-input rounded-pill border-primary shadow-sm', 'placeholder': 'Agregar nuevo link...'})
        }