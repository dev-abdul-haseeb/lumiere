# lumiere

A new Flutter project.

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/dev-abdul-haseeb/spend_wise.git
cd spend_wise
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Setup Firebase
- Create a project at [Firebase Console](https://console.firebase.google.com/)
- Run the Firebase CLI setup commands
- Enable **Email/Password** authentication in Firebase Console
- Enable **Cloud Firestore** in Firebase Console

#### Get SHA Keys (Android)
```bash
cd android
./gradlew signingReport
```
Add the SHA-1 and SHA-256 keys to your Firebase Android app settings.

### 4. Setup Supabase
1. Create a project in supabase.com
2. Add package supabase_flutter
3. URL: Go to settings -> Data API -> API URL which will be url for main
   AnonKey: Settings -> API Keys -> Secret key

4. Go to https://supabase.com/docs/guides/getting-started/quickstarts/flutter
5. And for production, you add specific code to android/app/src/main/AndroidManifest.xml for permitting internet usage

#### For storage features
1. Go to storage.
2. Add a new bucket and name it

Run using:
```bash
flutter pub get
flutter run --dart-define-from-file=env.json
```

## 🛠 Tech Stack

Framework: Flutter
Backend: Firebase (Auth + Firestore)
State Management: BLoC
Architecture: BLoC (MVVM-aligned)
Local Storage: Shared Preferences


## Packages used:

1. google_fonts
2. firebase_core
3. cloud_firestore
4. firebase_auth
5. google_sign_in
6. equatable
7. bloc
8. flutter_bloc
9. dartz
10. firebase_messaging
11. flutter_local_notifications
12. http
13. googleapis_auth
14. app_settings
15. supabase_flutter
16. image_picker

### Google sign in setup:
Add this code to android/build.gradle.kts:
```bash
plugins {
    id("com.google.gms.google-services") version "4.3.15" apply false
}
```
Add following code to android/app/build.gradle.kts:
```bash
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.0.0"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.android.gms:play-services-auth:21.2.0")
}
```
Following to web/index.html under 'head':
```bash
  <meta name="google-signin-client_id"
        content="WEB_CLIENT_ID">
```
In main.dart:
```bash
if (kIsWeb) {
    // Web: NO serverClientId — it reads from index.html meta tag instead
    await GoogleSignIn.instance.initialize();
  } else if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    // Mobile: serverClientId required
    await GoogleSignIn.instance.initialize(
      serverClientId: 'WEB_CLIENT_ID',
    );
  }
 ```