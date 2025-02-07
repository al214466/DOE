from django.urls import path
from . import views
from app.views import ver_archivos, ver_estadisticas, agregar_comentario, obtener_comentario, crear_equipo
from .views import obtener_mensajes_chat, guardar_mensaje_chat, cerrar_sesion
from django.conf import settings
from django.conf.urls.static import static
from .views import eliminar_equipo, listar_equipos



urlpatterns = [
    path('', views.inicio, name='inicio'),
    path('listar/', views.listar_doe, name='listar_doe'),
    path('agregar/', views.agregar_doe, name='agregar_doe'),
    path('login/', views.iniciar_sesion, name='iniciar_sesion'),
    path('registrar/', views.registrar_usuario, name='registrar_usuario'),
    path('doe/<int:pk>/editar/', views.editar_doe, name='editar_doe'),
    path('doe/<int:pk>/archivos/', ver_archivos, name='ver_archivos'),
    path('doe/<int:pk>/estadisticas/', ver_estadisticas, name='ver_estadisticas'),
    path('chat/<int:doe_id>/', views.chat_doe, name='chat_doe'), 
    path('obtener_mensajes_chat/<int:doe_id>/', obtener_mensajes_chat, name="obtener_mensajes_chat"),
    path('guardar_mensaje_chat/', guardar_mensaje_chat, name="guardar_mensaje_chat"),
    path('logout/', cerrar_sesion, name='logout'),
    path('eliminar_doe/<int:doe_id>/', views.eliminar_doe, name='eliminar_doe'),
    path('crear_equipo/', crear_equipo, name='crear_equipo'),
    path('eliminar_equipo/<int:equipo_id>/', eliminar_equipo, name='eliminar_equipo'),
    path('listar_equipos/', listar_equipos, name='listar_equipos'),
    path('doe/<int:doe_id>/fase_infraestructura/', views.fase_infraestructura, name='fase_infraestructura'),
    path('doe/<int:doe_id>/data_mining/', views.fase_data_mining, name='fase_data_mining'),
    path('doe/<int:doe_id>/infraestructura/', views.fase_infraestructura, name='fase_infraestructura'),
    path('doe/<int:doe_id>/ejecucion/', views.fase_ejecucion, name='fase_ejecucion'),
    path('doe/<int:doe_id>/result_final/', views.fase_result_final, name='fase_result_final'),
    path('doe/<int:doe_id>/completar_data_mining/', views.completar_fase_data_mining, name='completar_fase_data_mining'),
    path('doe/<int:doe_id>/completar_infraestructura/', views.completar_fase_infraestructura, name='completar_fase_infraestructura'),
    path('doe/<int:doe_id>/completar_ejecucion/', views.completar_fase_ejecucion, name='completar_fase_ejecucion'),
    path('doe/<int:doe_id>/completar_result_final/', views.completar_fase_result_final, name='completar_fase_result_final'),





    



]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
