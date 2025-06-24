# aid_registry_flutter_app

Palestinian Ministry of Social Development 2025

## Getting Started

# Aid-Delivery-System – Flutter CI/CD Pipeline

This project includes a complete CI/CD pipeline using GitHub Actions to:

✅ Build and sign APK for Android  
✅ Build EXE for Windows  
✅ Distribute APK via Firebase App Distribution  
✅ Publish builds to GitHub Releases

---

## 🔧 Requirements

- Flutter 3.19.0 or higher
- Firebase Project with App ID
- Generated Android keystore (JKS)
- GitHub Secrets configured

---

## 📁 GitHub Secrets to Add

| Name                     | Description                          |
|--------------------------|--------------------------------------|
| ANDROID_KEYSTORE_BASE64 | Base64 content of keystore           |
| ANDROID_KEYSTORE_PASSWORD | Keystore password                  |
| ANDROID_KEY_ALIAS       | Alias name (e.g., upload)            |
| ANDROID_KEY_PASSWORD    | Key password                         |
| FIREBASE_APP_ID         | App ID from Firebase Console         |
| FIREBASE_SERVICE_ACCOUNT| Raw JSON of Firebase service account |

---

## ▶️ How to Trigger CI/CD

The workflow runs automatically on every `push` to the `main` branch. You can also trigger it manually via GitHub Actions tab.

---

## 📂 Outputs

- `app-release.apk` → GitHub Releases + Firebase testers
- `Aid-Delivery-System.exe` → GitHub Releases

