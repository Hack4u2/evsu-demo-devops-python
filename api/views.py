"""Views for the User API and health check."""

from django.http import JsonResponse
from rest_framework import viewsets
from rest_framework.response import Response

from .models import User
from .serializers import UserSerializer


class UserViewSet(viewsets.ModelViewSet):
    """ViewSet for handling User CRUD operations."""

    serializer_class = UserSerializer
    queryset = User.objects.all()

    def list(self, request):
        """Return a list of users."""
        serializer = self.get_serializer(self.get_queryset(), many=True)
        return Response(serializer.data)

    def retrieve(self, request, pk):
        """Return a specific user by ID."""
        serializer = self.get_serializer(self.get_object())
        return Response(serializer.data)

    def create(self, request):
        """Create a new user unless DNI already exists."""
        data = request.data

        if self.get_queryset().filter(dni=data.get('dni', '')).exists():
            return Response({'detail': 'User already exists'}, status=400)

        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(serializer.data, status=201)


def health_check(request):
    """Simple health check endpoint."""
    return JsonResponse({"status": "ok"})
