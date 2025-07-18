from .views import UserViewSet, health_check
from django.urls import path
from rest_framework import routers

router = routers.DefaultRouter()
router.register('users', UserViewSet, 'users')

urlpatterns = router.urls + [
    path('health/', health_check),
]
