import json
from channels.generic.websocket import AsyncWebsocketConsumer
from .models import ChatMessage, DOE
from django.contrib.auth.models import User

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.doe_id = self.scope["url_route"]["kwargs"]["doe_id"]
        self.room_group_name = f"chat_{self.doe_id}"

        # Unir la sala de chat
        await self.channel_layer.group_add(self.room_group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        # Salir de la sala
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def receive(self, text_data):
        data = json.loads(text_data)
        usuario = self.scope["user"]
        mensaje = data["mensaje"]
        imagen = data.get("imagen", None)

        # Guardar mensaje en la base de datos
        chat_message = ChatMessage.objects.create(
            doe_id=self.doe_id, usuario=usuario, mensaje=mensaje, imagen=imagen
        )

        # Enviar mensaje a la sala
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                "type": "chat_message",
                "usuario": usuario.username,
                "mensaje": mensaje,
                "imagen": imagen,
                "fecha": chat_message.fecha_envio.strftime("%Y-%m-%d %H:%M:%S"),
            },
        )

    async def chat_message(self, event):
        await self.send(text_data=json.dumps(event))
