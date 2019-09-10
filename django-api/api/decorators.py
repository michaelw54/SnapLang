from rest_framework.response import Response
from rest_framework.views import status


def validate_request_data(fn):
    def decorated(*args, **kwargs):
        # args[0] == GenericView Object
        english_definition = args[0].request.data.get("english_definition", "")
        foreign_definition = args[0].request.data.get("foreign_definition", "")
        if not english_definition and not foreign_definition:
            return Response(
                data={
                    "message": "Both english_definition and foreign definition are required to add an image"
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        return fn(*args, **kwargs)
    return decorated
