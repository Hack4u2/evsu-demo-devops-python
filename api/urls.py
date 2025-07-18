"""API URL configuration."""

from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import UserViewSet, health_check

router = DefaultRouter()
router.register('users', UserViewSet, basename='users')

urlpatterns = router.urls + [
    path('health/', health_check),
]
