import json
from django.urls import reverse

from rest_framework.test import APITestCase, APIClient
from rest_framework.views import status
from .models import Images
from .serializers import ImagesSerializer

# tests for models


class ImagesModelTest(APITestCase):
    def setUp(self):
        self.an_image = Images.objects.create(
            english_definition="Ugandan anthem",
            foreign_definition="George William Kakoma"
        )

    def test_song(self):
        """"
        This test ensures that the song created in the setup
        exists
        """
        self.assertEqual(self.an_image.english_definition, "Ugandan anthem")
        self.assertEqual(self.an_image.foreign_definition,
                         "George William Kakoma")
        self.assertEqual(str(self.an_image),
                         "Ugandan anthem - George William Kakoma")

# tests for views


class BaseViewTest(APITestCase):
    client = APIClient()

    @staticmethod
    def create_song(english_definition="", foreign_definition=""):
        """
        Create a song in the db
        :param english_definition:
        :param foreign_definition:
        :return:
        """
        if english_definition != "" and foreign_definition != "":
            Images.objects.create(
                english_definition=english_definition, foreign_definition=foreign_definition)

    def make_a_request(self, kind="post", **kwargs):
        """
        Make a post request to create a song
        :param kind: HTTP VERB
        :return:
        """
        if kind == "post":
            return self.client.post(
                reverse(
                    "Images-list-create",
                    kwargs={
                        "version": kwargs["version"]
                    }
                ),
                data=json.dumps(kwargs["data"]),
                content_type='application/json'
            )
        elif kind == "put":
            return self.client.put(
                reverse(
                    "Images-detail",
                    kwargs={
                        "version": kwargs["version"],
                        "pk": kwargs["id"]
                    }
                ),
                data=json.dumps(kwargs["data"]),
                content_type='application/json'
            )
        else:
            return None

    def fetch_an_image(self, pk=0):
        return self.client.get(
            reverse(
                "songs-detail",
                kwargs={
                    "version": "v1",
                    "pk": pk
                }
            )
        )

    def delete_an_image(self, pk=0):
        return self.client.delete(
            reverse(
                "songs-detail",
                kwargs={
                    "version": "v1",
                    "pk": pk
                }
            )
        )


class GetAllImagesTest(BaseViewTest):

    def test_get_all_songs(self):
        """
        This test ensures that all songs added in the setUp method
        exist when we make a GET request to the songs/ endpoint
        """
        # fetch the data from db
        expected = Images.objects.all()
        serialized = ImagesSerializer(expected, many=True)
        self.assertEqual(response.data, serialized.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class GetASingleImagesTest(BaseViewTest):

    def test_get_an_image(self):
        """
        This test ensures that a single song of a given id is
        returned
        """

        response = self.fetch_an_image(self.valid_song_id)
        # fetch the data from db
        expected = Songs.objects.get(pk=self.valid_song_id)
        serialized = SongsSerializer(expected)
        self.assertEqual(response.data, serialized.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # test with a song that does not exist
        response = self.fetch_an_image(self.invalid_song_id)
        self.assertEqual(
            response.data["message"],
            "Song with id: 100 does not exist"
        )
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


class AddSongsTest(BaseViewTest):

    def test_create_an_image(self):
        """
        This test ensures that a single song can be added
        """
        self.login_client('test_user', 'testing')
        # hit the API endpoint
        response = self.make_a_request(
            kind="post",
            version="v1",
            data=self.valid_data
        )
        self.assertEqual(response.data, self.valid_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # test with invalid data
        response = self.make_a_request(
            kind="post",
            version="v1",
            data=self.invalid_data
        )
        self.assertEqual(
            response.data["message"],
            "Both english_definition and foreign_definition are required to add a song"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class UpdateSongsTest(BaseViewTest):

    def test_update_an_image(self):
        """
        This test ensures that a single song can be updated. In this
        test we update the second song in the db with valid data and
        the third song with invalid data and make assertions
        """
        self.login_client('test_user', 'testing')
        # hit the API endpoint
        response = self.make_a_request(
            kind="put",
            version="v1",
            id=2,
            data=self.valid_data
        )
        self.assertEqual(response.data, self.valid_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # test with invalid data
        response = self.make_a_request(
            kind="put",
            version="v1",
            id=3,
            data=self.invalid_data
        )
        self.assertEqual(
            response.data["message"],
            "Both english_definition and foreign_definition are required to add a song"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class DeleteSongsTest(BaseViewTest):

    def test_delete_an_image(self):
        """
        This test ensures that when a song of given id can be deleted
        """
        self.login_client('test_user', 'testing')
        # hit the API endpoint
        response = self.delete_an_image(1)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        # test with invalid data
        response = self.delete_an_image(100)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
