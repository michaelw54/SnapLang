from rest_framework import serializers
from .models import Images, Category


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ("name", "count")

    def update(self, instance, validated_data):
        instance.count = validated_data.get("count", instance.count)
        instance.name = validated_data.get("name", instance.name)
        instance.save()
        return instance


class ImagesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Images
        fields = ("english_definition",
                  "foreign_definition", "foreign_language", "category")

    def update(self, instance, validated_data):
        instance.english_definition = validated_data.get(
            "english_definition", instance.english_definition)
        instance.foreign_definition = validated_data.get(
            "foreign_definition", instance.foreign_definition)
        instance.foreign_language = validated_data.get(
            "foreign_language", instance.foreign_language)
        instance.foreign_language = validated_data.get(
            "category", instance.category)
        instance.save()
        return instance
