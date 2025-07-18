from django.urls import path, include
from rest_framework import routers
from .views import UserViewSet, healthcheck  # importa tu healthcheck también

router = routers.DefaultRouter()
router.register('users', UserViewSet, basename='users')

urlpatterns = [
    path('health/', healthcheck),
    path('', include(router.urls)),
]
