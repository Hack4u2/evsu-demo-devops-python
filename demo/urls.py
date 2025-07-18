from django.urls import path
from django.http import JsonResponse

# Vista de healthcheck
def healthcheck(request):
    return JsonResponse({"status": "ok"})

urlpatterns = [
    path('health/', healthcheck),
    # tus otras rutas...
]
