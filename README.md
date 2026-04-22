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

### 4. Get SHA Keys (Android)
```bash
cd android
./gradlew signingReport
```
Add the SHA-1 and SHA-256 keys to your Firebase Android app settings.

