# PennApps2020
This is the backend for the SnapLang Project

First, make sure you are in the working directory of your Django project. Then, follow these directions:

### Installing all dependencies
```
pip install -r requirements.txt
```
### Start the ngroc server
```
./ngrok http 8000
```
### Editing the [`settings.py`](./ImageTranslator/settings.py) file
```
ALLOWED_HOSTS = ['INSERT_NGROC_URL_HERE',]
```


### Running the Server
Make sure you are in the working directory of your Django project
Then, run the following command:
```
python3 manage.py runserver
```
