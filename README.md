# Bored Board

## :memo: How to run

### Step 1: Install Android Studio and Flutter

- [x] Flutter : https://flutter.dev/docs/get-started/install
- [x] Android Studio : https://developer.android.com/studio/install

### Step 2: Open a simulator

### Step 3: Run the APP

```
flutter pub get
flutter run lib/main.dart
```

## :desktop_computer: The project

A dashboard for NFT communities.
It's a tool that complements the discord servers.
It allows to group job offers, members' positions, and other features will arrive to complete this dashboard.

## :computer: How to code

### Pages
* auth_page.dart -> The authentification page
* home_page.dart -> The main page
* transition_page.dart -> The transition page between auth_page and home_page

### Widgets
* server_list.dart -> The navigation menu for the servers
* server_body.dart -> The core widget of the app, calling all the different widgets
* server_jobs.dart -> The widget for the jobs list
* map/ -> The different widgets for the map
* server_profil -> The widget for the profil

### Firebase
* auth.dart -> The principal functions for the firebase_auth

### BLoC
* bloc.dart -> All the stream for the BLoC functions
* validators.dart -> All the validators functions

## :books: External libraries
* firebase_core: For the Firebase setup
* firebase_auth: Firebase Authentification for the register and login page
* firebase_storage: Firebase Storage to store the profil pictures
* cloud_firestore: Firebase Cloud Firestore to store the data of the account
* blackfoot_flutter_lint: For the syntax of the code
* google_maps: For the google maps setup
* google_maps_flutter: Display google maps on mobile
* google_maps_flutter_web: Display google maps on web
* image_picker: Pick an image on mobile
* image_picker_web: Pick an image on web
* location: Get the user location
* path: Get the path of a file
* universal_html: Display specific web element

#### MADE BY PAUL AND YUANTAO