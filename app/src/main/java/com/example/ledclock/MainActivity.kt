package com.example.ledclock

import android.os.*
import android.view.*
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import java.text.SimpleDateFormat
import java.util.*
import kotlin.random.Random

class MainActivity : AppCompatActivity() {

    private lateinit var clockText: TextView
    private val handler = Handler(Looper.getMainLooper())

    private val updateClock = object : Runnable {
        override fun run() {
            clockText.text =
                SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(Date())

            // Anti burn-in: micro spostamento casuale (1–3 px)
            clockText.translationX = Random.nextInt(-3, 4).toFloat()
            clockText.translationY = Random.nextInt(-3, 4).toFloat()

            handler.postDelayed(this, 1000)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Schermo sempre acceso
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        // Full screen immersivo
        window.decorView.systemUiVisibility =
            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY or
            View.SYSTEM_UI_FLAG_FULLSCREEN or
            View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
            View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE

        setContentView(R.layout.activity_main)
        clockText = findViewById(R.id.clockText)

        handler.post(updateClock)
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(updateClock)
    }
}
