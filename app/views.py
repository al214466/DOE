from django.shortcuts import render
from django.shortcuts import redirect
from django.http import HttpResponse
from .models import DOE
from .forms import DOEForm
from django.contrib.auth import authenticate, login
from .forms import LoginForm
from django.contrib.auth.decorators import user_passes_test
from django.contrib.auth.forms import UserCreationForm


def listar_doe(request):
    doe_list = DOE.objects.all()  # Obtener todos los DOE
    return render(request, 'app/listar_doe.html', {'doe_list': doe_list})

def inicio(request):
    return HttpResponse("¡Bienvenido a DOE!")

def agregar_doe(request):
    if request.method == 'POST':
        form = DOEForm(request.POST)
        if form.is_valid():
            form.save()  # Guardar el nuevo DOE
            return redirect('listar_doe')  # Redirigir a la lista de DOE
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

