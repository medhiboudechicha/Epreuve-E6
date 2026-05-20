import java.util.Properties

plugins {
    alias(libs.plugins.android.application)
}

val localProperties = Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use(::load)
    }
}

// Garantit que Retrofit recoit une base URL valide, donc terminee par "/".
fun sanitizeBaseUrl(rawValue: String): String {
    val trimmed = rawValue.trim()
    return if (trimmed.endsWith("/")) trimmed else "$trimmed/"
}

// Priorite de configuration:
// 1. -PapiBaseUrl=... en ligne de commande Gradle
// 2. api.baseUrl=... dans local.properties
// 3. URL par defaut pour emulateur Android vers Laragon/CodeIgniter
val apiBaseUrl = sanitizeBaseUrl(
    (project.findProperty("apiBaseUrl") as String?)
        ?: localProperties.getProperty("api.baseUrl")
        ?: "http://10.0.2.2:8080/AP3_Gestion_Produit_api/public/"
)

// La valeur est injectee dans BuildConfig sous forme de string Java.
val escapedApiBaseUrl = apiBaseUrl
    .replace("\\", "\\\\")
    .replace("\"", "\\\"")

android {
    namespace = "com.example.apimobile"
    compileSdk {
        version = release(36) {
            minorApiLevel = 1
        }
    }

    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.example.apimobile"
        minSdk = 24
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        buildConfigField("String", "API_BASE_URL", "\"$escapedApiBaseUrl\"")
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}

dependencies {
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)
    implementation("androidx.recyclerview:recyclerview:1.3.2")
    implementation("com.github.bumptech.glide:glide:4.16.0")
    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)
    implementation("com.squareup.retrofit2:retrofit:2.11.0")
    implementation("com.squareup.retrofit2:converter-gson:2.11.0")
}
