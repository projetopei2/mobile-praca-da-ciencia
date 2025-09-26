plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "praca.da.ciencia"  // 🔥 Atualiza aqui para seu novo namespace
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
    applicationId = "praca.da.ciencia"
    minSdk = 23  // 🔥 Atualizado para resolver o erro
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // ❗️Trocar futuramente por signingConfig de release
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Importa o Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))

    // 🔥 Adiciona os serviços Firebase que você vai usar
    implementation("com.google.firebase:firebase-analytics")

    // Caso utilize outros serviços, adicione aqui, por exemplo:
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
}
