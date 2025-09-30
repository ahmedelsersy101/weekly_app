plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin لازم يكون آخر واحد
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.weekly_dash_board"
    compileSdk = 34 // خليها 34 حالياً لأنه ده آخر SDK مدعوم ومستقر (36 لسه preview)

    ndkVersion = flutter.ndkVersion

    compileOptions {
        // استخدام Java 11 (حل مشكلة التحذيرات بتاعة Java 8 obsolete)
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.weekly_dash_board"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        multiDexEnabled = true
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // لو عندك keystore خاص بالتوقيع ضيفه هنا بدلاً من debug
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // Kotlin stdlib (خلي النسخة متوافقة مع نسخة الـ Kotlin Gradle Plugin في gradle.properties)
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    // Multidex
    implementation("androidx.multidex:multidex:2.0.1")

    // Play Core
    implementation("com.google.android.play:core:1.10.3")
}
