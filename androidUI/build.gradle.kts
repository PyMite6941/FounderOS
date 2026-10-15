plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}

android {
    namespace = 'com.founderos.androidui'
    compileSdk 34

    defaultConfig {
        applicationId = "com.founderos.androidui"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize'), 'proguard-rules.pro'
        }
    }
}

kotlin {
    android {
        experimental = '1.7.0'
    }
}
