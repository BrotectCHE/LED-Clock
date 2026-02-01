mkdir -p app/src/main/java/com/example/ledclock
mkdir -p app/src/main/res/layout
mkdir -p app/src/main/res/values
mkdir -p .github/workflows

cat <<EOF > app/src/main/java/com/example/ledclock/MainActivity.kt
package com.example.ledclock
import android.os.*
import android.view.WindowManager
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import java.text.SimpleDateFormat
import java.util.*
class MainActivity : AppCompatActivity() {
    private lateinit var clockText: TextView
    private val handler = Handler(Looper.getMainLooper())
    private val updateClock = object : Runnable {
        override fun run() {
            clockText.text = SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(Date())
            handler.postDelayed(this, 1000)
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        setContentView(R.layout.activity_main)
        clockText = findViewById(R.id.clockText)
        handler.post(updateClock)
    }
}
EOF

cat <<EOF > app/src/main/res/layout/activity_main.xml
<RelativeLayout xmlns:android="http://schemas.android.com"
    android:layout_width="match_parent" android:layout_height="match_parent" android:background="#000000">
    <TextView android:id="@+id/clockText" android:layout_width="wrap_content" android:layout_height="wrap_content"
        android:layout_centerInParent="true" android:textColor="#FF1A1A" android:textSize="72sp" android:fontFamily="monospace"/>
</RelativeLayout>
EOF

cat <<EOF > app/src/main/AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com" package="com.example.ledclock">
    <application android:label="LED Clock" android:theme="@style/Theme.AppCompat.NoActionBar">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/><category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

cat <<EOF > build.gradle
buildscript { repositories { google(); mavenCentral() }; dependencies { classpath 'com.android.tools.build:gradle:8.1.0'; classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.20" } }
allprojects { repositories { google(); mavenCentral() } }
EOF

cat <<EOF > app/build.gradle
plugins { id 'com.android.application'; id 'kotlin-android' }
android { namespace 'com.example.ledclock'; compileSdk 33
    defaultConfig { applicationId "com.example.ledclock"; minSdk 24; targetSdk 33; versionCode 1; versionName "1.0" } }
dependencies { implementation 'androidx.core:core-ktx:1.10.1'; implementation 'androidx.appcompat:appcompat:1.6.1'; implementation 'com.google.android.material:material:1.9.0' }
EOF

cat <<EOF > settings.gradle
include ':app'
EOF

cat <<EOF > .github/workflows/build.yml
name: Build APK
on: [push, workflow_dispatch]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with: { java-version: '17', distribution: 'temurin', cache: gradle }
      - run: gradle wrapper
      - run: ./gradlew assembleDebug
      - uses: actions/upload-artifact@v3
        with: { name: LED-Clock-APK, path: app/build/outputs/apk/debug/app-debug.apk }
EOF
