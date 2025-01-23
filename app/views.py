from django.shortcuts import render
from django.shortcuts import redirect
from django.http import HttpResponse
from django.shortcuts import render, redirect, get_object_or_404
from .models import DOE, Material
from .forms import DOEForm
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login
from .forms import LoginForm
from django.contrib.auth.decorators import user_passes_test
from django.contrib.auth.forms import UserCreationForm
from django.utils.timezone import now
from datetime import timedelta
from .models import ArchivoFase
from .forms import ArchivoFaseForm



def listar_doe(request):
    does = DOE.objects.all()  # Consulta todos los DOE
    return render(request, 'app/listar_doe.html', {'does': does})

def inicio(request):
    return HttpResponse("¡Bienvenido a DOE!")

def agregar_doe(request):
    if request.method == 'POST':
        form = DOEForm(request.POST, request.FILES)
        if form.is_valid():
            doe = form.save(commit=False)  # Guarda sin enviar aún al DB
            doe.creado_por = request.user  # Usuario logueado
            doe.save()  # Ahora guarda en la base de datos
            return redirect('listar_doe')  # Redirige al dashboard
    else:
        form = DOEForm()
    return render(request, 'app/agregar_doe.html', {'form': form})

def iniciar_sesion(request):
    if request.method == 'POST':
        form = LoginForm(data=request.POST)
        if form.is_valid():
            usuario = form.get_user()
            login(request, usuario)
            if usuario.rol == 'Sr':  # Redirigir a página de ingenieros
                return redirect('registrar_usuario')
            return redirect('listar_doe')
    else:
        form = LoginForm()
    return render(request, 'app/login.html', {'form': form})

@user_passes_test(lambda u: u.is_authenticated and u.rol == 'Sr')
def registrar_usuario(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('listar_doe')
    else:
        form = UserCreationForm()
    return render(request, 'app/registrar_usuario.html', {'form': form})

@login_required
def editar_doe(request, pk):
    doe = get_object_or_404(DOE, pk=pk)

    # Obtener los archivos asociados a la fase actual
    archivos = ArchivoFase.objects.filter(doe=doe, fase=doe.fase_actual)

    # Progreso de fases
    fases = [fase[0] for fase in DOE.FASES]
    progreso = int((fases.index(doe.fase_actual) + 1) / len(fases) * 100)

    # Verificar fase actual
    campos_infrastructure = doe.fase_actual == 'infrastructure_and_material'
    permitir_subir_archivos = doe.fase_actual == 'data_mining'

    if request.method == 'POST':
        form = DOEForm(request.POST, request.FILES, instance=doe)
        archivo_form = ArchivoFaseForm(request.POST, request.FILES) if permitir_subir_archivos else None

        if campos_infrastructure:
            # Guardar datos específicos de "Infrastructure and Material"
            doe.rk_sn = request.POST.get('rk_sn')
            doe.rn_number = request.POST.get('rn_number')
            doe.unit_sn = request.POST.get('unit_sn')
            doe.bay = request.POST.get('bay')

            # Guardar lista de materiales
            materiales = request.POST.getlist('material')
            seriales = request.POST.getlist('material_sn')
            pns = request.POST.getlist('material_pn')

            for material, sn, pn in zip(materiales, seriales, pns):
                # Crear materiales (esto asume que hay un modelo Material relacionado con DOE)
                Material.objects.create(doe=doe, material=material, serial_number=sn, pn=pn)

        if form.is_valid():
            # Avanzar de fase
            if 'avance_fase' in request.POST:
                indice_actual = fases.index(doe.fase_actual)
                if indice_actual < len(fases) - 1:
                    doe.fase_actual = fases[indice_actual + 1]
                    doe.fecha_ultima_modificacion = now()
            form.save()

        # Guardar archivos solo si está permitido
        if permitir_subir_archivos and archivo_form and archivo_form.is_valid():
            archivo = archivo_form.save(commit=False)
            archivo.doe = doe
            archivo.fase = doe.fase_actual
            archivo.subido_por = request.user
            archivo.save()
            return redirect('editar_doe', pk=pk)

    else:
        form = DOEForm(instance=doe)
        archivo_form = ArchivoFaseForm() if permitir_subir_archivos else None

    fases = [fase[0] for fase in DOE.FASES]
    progreso = int((fases.index(doe.fase_actual) + 1) / len(fases) * 100)


    return render(request, 'app/editar_doe.html', {
        'form': form,
        'archivo_form': archivo_form,
        'archivos': archivos,
        'doe': doe,
        'progreso': progreso,
        'permitir_subir_archivos': permitir_subir_archivos,
        'campos_infrastructure': campos_infrastructure,
    })
