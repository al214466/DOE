from django.shortcuts import render
from django.shortcuts import redirect
from django.http import HttpResponse
from django.shortcuts import render, redirect, get_object_or_404
from .models import DOE, Material, HistorialFase
from django.contrib.auth import authenticate, login
from .forms import LoginForm
from django.contrib.auth import logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from django.utils.timezone import now
from datetime import timedelta
from .models import ArchivoFase, ChatMessage
from .forms import ArchivoFaseForm, ComentarioForm
from .models import DOE, DOE_Fase, TurnoComentario
from .forms import DOEForm, TurnoComentarioForm
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .models import DOE, Comentario
from django.contrib.auth.decorators import user_passes_test
from django.contrib import messages
from django.contrib.auth.forms import AuthenticationForm
from app.models import Equipo, Usuario 
from .models import DOE, DataMining, InfrastructureMaterial, Execution, ResultFinal, ExecutionLink, Status, ExecutiveSummary, PPTFile
from .forms import DataMiningForm, InfrastructureMaterialForm, ExecutionForm, ResultFinalForm, MaterialForm, ExecutiveSummaryForm, UnidadForm, StatusForm, LinkForm, PPTFileForm


@csrf_exempt
def actualizar_turno(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            usuario_id = data.get("usuario_id")
            turno = data.get("turno")

            usuario = Usuario.objects.get(id=usuario_id)
            usuario.turno = turno
            usuario.save()

            return JsonResponse({"success": True, "message": "Turno actualizado correctamente."})
        except Usuario.DoesNotExist:
            return JsonResponse({"success": False, "message": "Usuario no encontrado."}, status=404)
    
    return JsonResponse({"success": False, "message": "Método no permitido."}, status=400)



@login_required
def cerrar_sesion(request):
    logout(request)
    return redirect('app/login.html') 

@login_required
def listar_doe(request):
    does = DOE.objects.select_related('equipo').all()  # Optimizar consulta para traer equipos
    equipos_usuario = Equipo.objects.filter(miembros=request.user)  # Obtener el equipo del usuario

    return render(request, 'app/listar_doe.html', {
        'does': does,
        'user': request.user,
        'equipos_usuario': equipos_usuario
    })

def inicio(request):
    return HttpResponse("¡Bienvenido a DOE!")

@login_required
def agregar_doe(request):
    if request.user.rol != 'Sr':
        messages.error(request, "No tienes permisos para crear un DOE.")
        return redirect('listar_doe')

    if request.method == 'POST':
        titulo = request.POST['titulo']
        descripcion = request.POST['descripcion']
        archivo_te = request.FILES.get('archivo_te', None)
        prioridad = request.POST.get('prioridad', 'Medium')
        equipo_id = request.POST.get('equipo', None)

        doe = DOE.objects.create(
            titulo=titulo,
            descripcion=descripcion,
            creado_por=request.user,
            archivo_te=archivo_te,
            prioridad=prioridad,
            equipo_id=equipo_id if equipo_id else None
        )

        fases_predeterminadas = [
            ('infrastructure_and_material', 'Infrastructure and Material'),
            ('data_mining', 'Data Mining'),
            ('final_review', 'Final Review'),
            ('completed', 'Completed'),
        ]

        for fase_key, _ in fases_predeterminadas:
            DOE_Fase.objects.create(
                doe=doe,
                nombre_fase=fase_key
            )

        return redirect('listar_doe')

    equipos = Equipo.objects.all()

    # 🔎 Agregar una impresión en consola para depuración
    print(f"🔎 Equipos disponibles: {[equipo.nombre for equipo in equipos]}")

    return render(request, 'app/agregar_doe.html', {'equipos': equipos})

@login_required
def eliminar_doe(request, doe_id):
    if request.user.rol != 'Sr':  # Solo los Ingenieros pueden eliminar
        messages.error(request, "No tienes permisos para eliminar un DOE.")
        return redirect('listar_doe')

    doe = get_object_or_404(DOE, id=doe_id)
    doe.delete()
    messages.success(request, "DOE eliminado correctamente.")
    return redirect('listar_doe')

@csrf_exempt
def iniciar_sesion(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            return redirect("listar_doe")  # Redirigir después del login
        else:
            return render(request, "app/login.html", {"error": "Usuario o contraseña incorrectos."})
    
    return render(request, "app/login.html")


@login_required
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

@csrf_exempt  # Permite solicitudes AJAX sin error de CSRF
@login_required
def agregar_comentario(request, doe_id):
    if request.method == "POST":
        try:
            data = json.loads(request.body)
            comentario_texto = data.get("comentario", "").strip()
            if not comentario_texto:
                return JsonResponse({"success": False, "error": "El comentario no puede estar vacío."})

            # Buscar el DOE
            doe = DOE.objects.get(id=doe_id)

            # Borrar el comentario anterior del DOE (porque solo debe haber uno por turno)
            Comentario.objects.filter(doe=doe).delete()

            # Guardar el nuevo comentario
            Comentario.objects.create(doe=doe, texto=comentario_texto, autor=request.user)

            return JsonResponse({"success": True})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)})
    return JsonResponse({"success": False, "error": "Método no permitido."})

@login_required
def obtener_comentario(request, doe_id):
    try:
        doe = DOE.objects.get(id=doe_id)
        comentario = Comentario.objects.filter(doe=doe).first()
        return JsonResponse({"comentario": comentario.texto if comentario else ""})
    except DOE.DoesNotExist:
        return JsonResponse({"error": "El DOE no existe"}, status=404)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    
@login_required
def obtener_comentario(request, pk):
    try:
        doe = DOE.objects.get(pk=pk)
        comentario = Comentario.objects.filter(doe=doe).last()
        return JsonResponse({"comentario": comentario.contenido if comentario else ""})
    except DOE.DoesNotExist:
        return JsonResponse({"comentario": ""})
    
@login_required
def ver_archivos(request, pk):
    doe = get_object_or_404(DOE, pk=pk)
    archivos = ArchivoFase.objects.filter(doe=doe)
    return render(request, 'app/ver_archivos.html', {'doe': doe, 'archivos': archivos})

@login_required
def ver_estadisticas(request, pk):
    doe = get_object_or_404(DOE, pk=pk)
    historial = HistorialFase.objects.filter(doe=doe).order_by('-fecha')

    return render(request, 'app/ver_estadisticas.html', {
        'doe': doe,
        'historial': historial
    })

@login_required
def chat_doe(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    return render(request, 'app/chat.html', {'doe': doe})

@login_required
def obtener_mensajes_chat(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    mensajes = ChatMessage.objects.filter(doe=doe).order_by("fecha_envio")  # Cambio aquí: usamos MensajeChat en lugar de obtener_mensajes_chat
    
    data = [
        {
            "usuario": mensaje.usuario.username,
            "mensaje": mensaje.mensaje,
            "imagen": mensaje.imagen.url if mensaje.imagen else None,
            "fecha_envio": mensaje.fecha_envio.strftime("%Y-%m-%d %H:%M:%S")
        }
        for mensaje in mensajes
    ]
    
    return JsonResponse(data, safe=False)
    
    return JsonResponse(data, safe=False)
@csrf_exempt
@login_required
def guardar_mensaje_chat(request):
    if request.method == "POST":
        data = json.loads(request.body)
        doe = DOE.objects.get(id=data["doe_id"])
        mensaje = ChatMessage.objects.create(
            doe=doe,
            usuario=request.user,
            mensaje=data.get("mensaje", ""),
        )

        if data.get("imagen"):
            from django.core.files.base import ContentFile
            import base64

            format, imgstr = data["imagen"].split(";base64,")
            ext = format.split("/")[-1]
            mensaje.imagen.save(f"chat_{mensaje.id}.{ext}", ContentFile(base64.b64decode(imgstr)))

        mensaje.save()
        return JsonResponse({"success": True})

    return JsonResponse({"success": False}, status=400)

@login_required
def eliminar_mensaje(request, mensaje_id):
    if request.method == "POST":
        mensaje = get_object_or_404(ChatMessage, id=mensaje_id)

        # Opcional: Validar que solo el usuario que envió el mensaje pueda borrarlo
        if request.user != mensaje.usuario:
            return JsonResponse({"success": False, "error": "No tienes permiso para eliminar este mensaje."}, status=403)

        mensaje.delete()
        return JsonResponse({"success": True})

    return JsonResponse({"success": False, "error": "Método no permitido."}, status=405)

@login_required
def crear_equipo(request):
    if request.user.rol != 'Sr':  # Solo los ingenieros pueden crear equipos
        messages.error(request, "No tienes permisos para crear un equipo.")
        return redirect('listar_doe')

    if request.method == 'POST':
        nombre = request.POST.get('nombre')
        miembros_ids = request.POST.getlist('miembros')  # Obtener IDs de los miembros seleccionados
        ingeniero_id = request.POST.get('ingeniero', None)  # Obtener el PIC

        if not nombre:
            messages.error(request, "El nombre del equipo es obligatorio.")
            return redirect('crear_equipo')

        equipo = Equipo.objects.create(nombre=nombre, creado_por=request.user)

        # Asignar los miembros al equipo (Jr e ingenieros seleccionados)
        if miembros_ids:
            equipo.miembros.set(Usuario.objects.filter(id__in=miembros_ids))
        
        if ingeniero_id:
            ingeniero = Usuario.objects.get(id=ingeniero_id)
            equipo.miembros.add(ingeniero)  # Agregar el ingeniero

        equipo.save()

        # Guardar turnos en la base de datos
        for usuario_id in miembros_ids:
            usuario = Usuario.objects.get(id=usuario_id)
            turno_asignado = request.POST.get(f"turno_{usuario_id}", None)
            if turno_asignado:
                usuario.turno = turno_asignado
                usuario.save()

        messages.success(request, "Equipo creado exitosamente.")
        return redirect('listar_equipos')

    # Obtener lista de ingenieros y usuarios Jr
    ingenieros = Usuario.objects.filter(rol="Sr")
    usuarios_jr = Usuario.objects.exclude(rol="Sr").order_by('first_name')

    # Lista de turnos predefinidos
    turnos = [
        {"id": 1, "nombre": "1er Turno"},
        {"id": 2, "nombre": "2do Turno"},
        {"id": 3, "nombre": "3er Turno"},
        {"id": 4, "nombre": "4to Turno"},
    ]

    return render(request, 'app/crear_equipo.html', {
        'usuarios_jr': usuarios_jr,
        'ingenieros': ingenieros,
        'turnos': turnos
    })



@login_required
def eliminar_equipo(request, equipo_id):
    if not isinstance(equipo_id, int):  # Verificar que sea un número válido
        messages.error(request, "ID de equipo no válido.")
        return redirect('listar_equipos')

    equipo = get_object_or_404(Equipo, id=equipo_id)

    if not equipo:
        messages.error(request, "El equipo no existe.")
        return redirect('listar_equipos')

    equipo.delete()
    messages.success(request, "Equipo eliminado correctamente.")
    return redirect('listar_equipos')

@login_required
def listar_equipos(request):
    equipos = Equipo.objects.prefetch_related('miembros').all()
    
    for equipo in equipos:
        print(f"Equipo: {equipo.nombre} - Miembros: {[m.username for m in equipo.miembros.all()]}")  # Verificación en consola

    return render(request, 'app/listar_equipos.html', {'equipos': equipos})


def fase_infraestructura(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    return render(request, 'app/fase_infraestructura.html', {'doe': doe})


def fase_data_mining(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    data_mining, created = DataMining.objects.get_or_create(doe=doe)

    if request.method == "POST":
        form = DataMiningForm(request.POST, request.FILES, instance=data_mining)
        if form.is_valid():
            form.save()
            doe.data_mining_completed = True  # Marcar Data Mining como completado
            doe.save()
            messages.success(request, "Fase Data Mining guardada correctamente.")
            return redirect('fase_infraestructura', doe_id=doe.id)
    else:
        form = DataMiningForm(instance=data_mining)

    return render(request, 'app/fase_data_mining.html', {'doe': doe, 'form': form})

def completar_fase_data_mining(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    doe.data_mining_completed = True
    doe.save()
    return redirect('editar', doe_id=doe.id)

def fase_infraestructura(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    infraestructura, created = InfrastructureMaterial.objects.get_or_create(doe=doe)

    material_form = MaterialForm()
    unidad_form = UnidadForm()

    if request.method == "POST":
        print("🚀 Request POST:", request.POST)

        if "add_material" in request.POST:
            print("🛠️ Agregando Material...")
            material_form = MaterialForm(request.POST)
            if material_form.is_valid():
                material = material_form.save(commit=False)
                material.infrastructure = infraestructura
                material.save()
                messages.success(request, "Material agregado correctamente.")
                return redirect('fase_infraestructura', doe_id=doe.id)
            else:
                print("❌ Error en el formulario de material:", material_form.errors)

        elif "add_unidad" in request.POST:
            print("🛠️ Agregando Unidad...")
            unidad_form = UnidadForm(request.POST)
            if unidad_form.is_valid():
                unidad = unidad_form.save(commit=False)
                unidad.infrastructure = infraestructura
                unidad.save()
                messages.success(request, "Unidad agregada correctamente.")
                return redirect('fase_infraestructura', doe_id=doe.id)
            else:
                print("❌ Error en el formulario de unidad:", unidad_form.errors)

        elif "save_and_continue" in request.POST:
            print("✅ Guardando y continuando...")
            form = InfrastructureMaterialForm(request.POST, instance=infraestructura)
            if form.is_valid():
                form.save()
                doe.infrastructure_completed = True
                doe.save()
                messages.success(request, "Fase Infraestructura guardada correctamente.")
                return redirect('fase_ejecucion', doe_id=doe.id)
            else:
                print("❌ Error en el formulario de infraestructura:", form.errors)

    else:
        form = InfrastructureMaterialForm(instance=infraestructura)

    return render(request, 'app/fase_infraestructura.html', {
        'doe': doe,
        'form': form,
        'material_form': material_form,
        'unidad_form': unidad_form,
        'materials': infraestructura.materials.all(),
        'unidades': infraestructura.unidades.all(),
    })





def completar_fase_infraestructura(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    if doe.data_mining_completed:  # Asegura que Data Mining esté completado antes de continuar
        doe.infrastructure_completed = True
        doe.save()
    return redirect('fase_ejecucion', doe_id=doe.id)

def fase_ejecucion(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    ejecucion, created = Execution.objects.get_or_create(doe=doe)

    if request.method == "POST":
        print("🚀 Request POST:", request.POST)

        if "save_and_continue" in request.POST:
            ejecucion.save()
            doe.ejecucion_completed = True  # 🔹 Marcar la fase como completada
            doe.save()
            messages.success(request, "Fase de ejecución completada. Avanzando a la siguiente fase.")
            return redirect('fase_result_final', doe_id=doe.id)

        elif "add_link" in request.POST:
            link_form = LinkForm(request.POST)
            if link_form.is_valid():
                link = link_form.save(commit=False)
                link.execution = ejecucion
                link.save()
                messages.success(request, "✅ Link agregado correctamente.")
                return redirect('fase_ejecucion', doe_id=doe.id)

        elif "add_summary" in request.POST:
            summary_form = ExecutiveSummaryForm(request.POST, request.FILES)
            if summary_form.is_valid():
                summary = summary_form.save(commit=False)
                summary.execution = ejecucion
                summary.save()
                messages.success(request, "📄 Archivo subido correctamente.")
                return redirect('fase_ejecucion', doe_id=doe.id)

        elif "add_status" in request.POST:
            status_form = StatusForm(request.POST)
            if status_form.is_valid():
                status = status_form.save(commit=False)
                status.execution = ejecucion
                status.user = request.user if request.user.is_authenticated else None
                status.save()
                messages.success(request, "📌 Status agregado correctamente.")
                return redirect('fase_ejecucion', doe_id=doe.id)

    else:
        link_form = LinkForm()
        summary_form = ExecutiveSummaryForm()
        status_form = StatusForm()

    links = ExecutionLink.objects.filter(execution=ejecucion)
    summaries = ExecutiveSummary.objects.filter(execution=ejecucion)
    statuses = Status.objects.filter(execution=ejecucion)

    return render(request, 'app/fase_ejecucion.html', {
        'doe': doe,
        'ejecucion': ejecucion,
        'link_form': link_form,
        'summary_form': summary_form,
        'status_form': status_form,
        'links': links,
        'summaries': summaries,
        'statuses': statuses,
    })



def completar_fase_ejecucion(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    
    if doe.infrastructure_completed:  # Asegura que Infraestructura esté completada antes de continuar
        doe.execution_completed = True
        doe.save()
    return redirect('fase_result_final', doe_id=doe.id)

def fase_result_final(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)

    if not doe.ejecucion_completed:  # 🔹 Validar que ejecución esté completa
        messages.error(request, "⚠️ No puedes acceder a Resultados sin completar Ejecución.")
        return redirect('fase_ejecucion', doe_id=doe.id)

    result_final, created = ResultFinal.objects.get_or_create(doe=doe)

    if request.method == "POST":
        print("🚀 Request POST:", request.POST)

        if "add_ppt" in request.POST:
            ppt_form = PPTFileForm(request.POST, request.FILES)
            if ppt_form.is_valid():
                ppt = ppt_form.save(commit=False)
                ppt.doe = doe
                ppt.save()
                messages.success(request, "📑 PPT subido correctamente.")
                return redirect('fase_result_final', doe_id=doe.id)
            else:
                print("❌ Error en formulario de PPT:", ppt_form.errors)

        elif "save_conclusion" in request.POST:
            form = ResultFinalForm(request.POST, instance=result_final)
            if form.is_valid():
                form.save()
                doe.finalizado = True  # 🔹 Marcar DOE como finalizado
                doe.save()
                messages.success(request, "🎉 DOE finalizado correctamente.")
                return redirect('listar_doe')
            else:
                print("❌ Error en formulario de conclusión:", form.errors)

    else:
        form = ResultFinalForm(instance=result_final)
        ppt_form = PPTFileForm()

    return render(request, 'app/fase_result_final.html', {
        'doe': doe,
        'form': form,
        'ppt_form': ppt_form,
        'ppts': PPTFile.objects.filter(doe=doe),
    })


def completar_fase_result_final(request, doe_id):
    doe = get_object_or_404(DOE, id=doe_id)
    if doe.execution_completed:  # Asegura que Ejecución esté completada antes de continuar
        doe.result_final_completed = True
        doe.save()
    return redirect('listar_doe')  # Redirige a la lista de DOEs o alguna vista final