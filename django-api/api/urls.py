from .views import ListCreateImagesView, ImagesDetailView, ListCreateCategoryView, CategoryDetailView
from django.urls import path

urlpatterns = [
    path('images/', ListCreateImagesView.as_view(), name="images-all"),
    path('images/<int:pk>', ImagesDetailView.as_view(), name="images-detail"),
    path('category/', ListCreateCategoryView.as_view(), name="category-all"),
    path('category/<int:pk>', CategoryDetailView.as_view(),
         name="categories-detail")
]
