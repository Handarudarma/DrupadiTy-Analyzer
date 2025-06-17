plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.login"
    // Ganti flutter.compileSdkVersion dengan nilai literal, contoh:
    compileSdk = 35
    // Kalau pakai ndkVersion, tulis manual juga, atau hapus kalau gak perlu
    // ndkVersion = "23.1.7779620" // contoh versi ndk

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.login"
        minSdk = 21           // ganti dengan nilai minSdkVersion yang sesuai
        targetSdk = 34        // ganti dengan targetSdkVersion yang sesuai
        versionCode = 1       // ganti dengan versi app kamu
        versionName = "1.0"   // ganti dengan versi name app kamu
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("com.google.firebase:firebase-auth-ktx:21.0.1")
}

flutter {
    source = "../.."
}
