# SnapLang
Centralized platform for language-learning analytics and resources. Identify objects, learn them in a foreign language, and reinforce what you've learned with a personal dashboard. Devpost url: https://devpost.com/software/snaplang

## SnapLang iOS

### Installing Dependencies
```
pod install
```

### GCP Credentials
In XCode go to Product > Scheme > Edit Scheme > Arguments and add a new environment variable `gcp_api_key` with your own GCP API key as the value.

### Building
Connect your phone to computer via USB and select your phone as build target.

## SnapLang Web

### Installing Dependencies
```
npm install
```

### Running the Client
```
npm start
```

## Node API

### GCP Credentials
Retrieve your own GCP credentials from the dashboard. Create a .env file and set an environment variable `GOOGLE_APPLICATION_CREDENTIALS` to the file path of the JSON file that contains your service account key. This variable only applies to your current shell session, so if you open a new session, set the variable again.

### Installing Dependencies
```
npm install
```

### Starting the server
```
node index.js
```

## Django API 

First, make sure you are in the working directory of your Django project. Then, follow these directions:

### Installing all dependencies
```
pip install -r requirements.txt
```

### GCP Credentials
In a terminal window, set an environment variable `GOOGLE_APPLICATION_CREDENTIALS` to the file path of the JSON file that contains your service account key. This variable only applies to your current shell session, so if you open a new session, set the variable again.

### Start the ngrok server
```
./ngrok http 8000
```
### Editing [`settings.py`](./ImageTranslator/settings.py)
```
ALLOWED_HOSTS = ['INSERT_NGROC_URL_HERE',]
```

### Running the Server
Make sure you are in the working directory of your Django project
Then, run the following command:
```
python3 manage.py runserver
```
