from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("wiki/<title>/", views.get, name="get"),
    path("search/",views.search, name="search"),
    path("random/",views.random_choice, name="random"),
    path("add/",views.add, name ='add'),
    path("edit/<title>",views.edit,name='edit')
]
