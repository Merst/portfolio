from django.views import generic
from .models import Project

class HomeView(generic.ListView):
    model = Project
    context_object_name = 'project_list'

