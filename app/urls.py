from django.urls import path
from . import views

urlpatterns = [
    path('', views.inicio, name='inicio'),
    path('listar/', views.listar_doe, name='listar_doe'),
    path('agregar/', views.agregar_doe, name='agregar_doe'),
    path('login/', views.iniciar_sesion, name='iniciar_sesion'),
    path('registrar/', views.registrar_usuario, name='registrar_usuario'),
    path('doe/<int:pk>/editar/', views.editar_doe, name='editar_doe'),


]
