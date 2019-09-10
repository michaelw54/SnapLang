from rest_framework import generics
from rest_framework import permissions
from rest_framework.response import Response
from rest_framework.views import status
from .classify_text import classify

from .decorators import validate_request_data
from .models import Images, Category
from .serializers import ImagesSerializer, CategorySerializer


class ListCreateCategoryView(generics.ListCreateAPIView):
    """
    GET category/
    POST category/
    """

    queryset = Category.objects.all()
    serializer_class = CategorySerializer

    @validate_request_data
    def post(self, request, *args, **kwargs):
        a_category = Category.objects.create(
            count=request.data["count"],
            name=request.data["name"]
        )
        return Response(
            data=CategorySerializer(a_category).data,
            status=status.HTTP_201_CREATED
        )


class CategoryDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET category/
    """
    # queryset = Category.objects.all()
    # serializer_class = CategorySerializer

    # def get(self, request, *args, **kwargs):
    #     try:
    #         a_category = self.queryset.get(pk=kwargs["pk"])
    #         return Response(CategorySerializer(a_category).data)
    #     except Category.DoesNotExist:
    #         return Response(
    #             data={
    #                 "message": "Category with id: {} does not exist".format(kwargs["pk"])
    #             },
    #             status=status.HTTP_404_NOT_FOUND
    #         )


class ListCreateImagesView(generics.ListCreateAPIView):
    """
    POST images/
    """
    queryset = Images.objects.all()
    serializer_class = ImagesSerializer

    @validate_request_data
    def post(self, request, *args, **kwargs):
        categories = classify(request.data["english_definition"])

        if (len(categories) == 0):
            categories = [["", "Miscellaneous"]]
        an_image = Images.objects.create(
            english_definition=request.data["english_definition"],
            foreign_definition=request.data["foreign_definition"],
            foreign_language=request.data["foreign_language"],
            category=categories[0][1]
        )

        for category in categories:
            results = Category.objects.filter(name=category[1])
            store = []
            for result in results:
                if (result.name != ''):
                    store.append(result)
            if (len(store) == 0):
                newCategory = Category(
                    name=category[1],
                    count=1
                )
                newCategory.save()
            else:
                existing = store[0]
                if (existing.name == category[1]):
                    existing_category_id = existing.id
                    # existing_category_id = Category.objects.get(
                    #     name='existing.name').id
                    existing_category = Category.objects.get(
                        id=existing_category_id)
                    existing_category.count = existing_category.count + 1  # change field
                    existing_category.save()  # this will update only
                    # existing_count = existing.count
                    # existing.count = existing_count + 1
                    # existing.save()
        return Response(
            data=ImagesSerializer(an_image).data,
            status=status.HTTP_201_CREATED
        )


class ImagesDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET images/:id/
    PUT images/:id/
    DELETE images/:id/
    """
    queryset = Images.objects.all()
    serializer_class = ImagesSerializer

    def get(self, request, *args, **kwargs):
        try:
            an_image = self.queryset.get(pk=kwargs["pk"])
            return Response(ImagesSerializer(an_image).data)
        except Images.DoesNotExist:
            return Response(
                data={
                    "message": "Image with id: {} does not exist".format(kwargs["pk"])
                },
                status=status.HTTP_404_NOT_FOUND
            )

    @validate_request_data
    def put(self, request, *args, **kwargs):
        try:
            an_image = self.queryset.get(pk=kwargs["pk"])
            serializer = ImagesSerializer()
            updated_image = serializer.update(an_image, request.data)
            return Response(ImagesSerializer(updated_image).data)
        except Images.DoesNotExist:
            return Response(
                data={
                    "message": "Image with id: {} does not exist".format(kwargs["pk"])
                },
                status=status.HTTP_404_NOT_FOUND
            )

    def delete(self, request, *args, **kwargs):
        try:
            an_image = self.queryset.get(pk=kwargs["pk"])
            an_image.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Images.DoesNotExist:
            return Response(
                data={
                    "message": "Image with id: {} does not exist".format(kwargs["pk"])
                },
                status=status.HTTP_404_NOT_FOUND
            )
