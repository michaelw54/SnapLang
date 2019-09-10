import argparse
import io
import json
import os
import re
from google.cloud import language
import numpy
import six


def classify(text, verbose=True):
    """Classify the input text into categories. """

    first_word = re.match(r'\A[\w-]+', text).group()
    if len(text.split()) < 20:
        for i in range(20 - len(text.split())):
            text = text + " " + first_word
    language_client = language.LanguageServiceClient()

    document = language.types.Document(
        content=text,
        type=language.enums.Document.Type.PLAIN_TEXT)
    response = language_client.classify_text(document)
    categories = response.categories

    result = {}

    for category in categories:
        # Turn the categories into a dictionary of the form:
        # {category.name: category.confidence}, so that they can
        # be treated as a sparse vector.
        result[category.name] = category.confidence

    # if verbose:
    #     print(text)
    #     for category in categories:
    #         print(u'=' * 20)
    #         print(u'{:<16}: {}'.format('category', category.name))
    #         print(u'{:<16}: {}'.format('confidence', category.confidence))
    return [key.split('/') for key in result]


# if __name__ == "__main__":
#     parser = argparse.ArgumentParser(description="take in input word")
#     parser.add_argument(
#         'text', help='The text to be classified. '
#         'The text needs to have at least 20 tokens.')
#     word = parser.parse_args().text
#     result = classify(word)
#     categories = [key.split('/') for key in result]
#     for
