from django.urls import include, path
from rest_framework import routers

from api.views import UserViewSet, health_check

router = routers.DefaultRouter()
router.register("users", UserViewSet, basename="users")

urlpatterns = [
    path("api/health/", health_check),
    path("", include(router.urls)),
]
