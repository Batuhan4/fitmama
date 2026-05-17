package com.momrise.momrise

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.RectF
import android.graphics.Shader
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/// Home-screen widget for momrise.
///
/// Layout:
///   left  → circular calorie ring (today's kcal / 2000 Kal)
///   right → 2x2 grid of quick-action icons:
///             + food   + water
///             + exercise   + weight
///
/// Tap targets:
///   - body (ring)  → open app dashboard
///   - + food       → open /nutrition (add a meal)
///   - + water      → in-place +200 ml, refresh widget
///   - + exercise   → open /exercise
///   - + weight     → open /progress (weight section)
class WaterWidgetProvider : AppWidgetProvider() {
    companion object {
        private const val WATER_STEP_ML = 200

        const val ACTION_WATER_PLUS = "com.momrise.WATER_PLUS"
        private const val WATER_GOAL_ML = 2000

        private const val PREFS_DAY_KEY = "mama_water_widget_day"
        private const val PREFS_ML_KEY = "mama_water_widget_ml"
        private const val FLUTTER_WATER_KEY = "flutter.mama_water"

        // momrise palette (dark variant of the blush / lavender system)
        private val cardColor = Color.parseColor("#FF2A1F36")
        private val ringTrack = Color.parseColor("#FF3A2D48")
        private val ringStart = Color.parseColor("#FFD9A6E2")
        private val ringEnd = Color.parseColor("#FFA063C8")

        fun todayKey(): String =
            SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())

        fun readMl(context: Context): Int {
            val prefs = HomeWidgetPlugin.getData(context)
            val today = todayKey()
            val storedDay = prefs.getString(PREFS_DAY_KEY, "") ?: ""
            return if (storedDay == today) prefs.getInt(PREFS_ML_KEY, 0) else 0
        }

        fun writeMl(context: Context, ml: Int) {
            val prefs = HomeWidgetPlugin.getData(context)
            val today = todayKey()
            val cups = ml / WATER_STEP_ML
            val json = "[{\"id\":\"$today\",\"date\":\"$today\",\"cups\":$cups}]"
            prefs.edit()
                .putString(PREFS_DAY_KEY, today)
                .putInt(PREFS_ML_KEY, ml)
                .putString(FLUTTER_WATER_KEY, json)
                .apply()
        }

        fun render(context: Context, manager: AppWidgetManager, widgetId: Int) {
            val ml = readMl(context)
            val views = RemoteViews(context.packageName, R.layout.water_widget)

            views.setImageViewBitmap(
                R.id.widget_ring,
                buildRing(ml.toFloat() / WATER_GOAL_ML),
            )
            views.setTextViewText(R.id.widget_amount, "${ml}ml")
            views.setTextViewText(
                R.id.widget_subtitle,
                "/ ${WATER_GOAL_ML}ml su",
            )

            views.setOnClickPendingIntent(
                R.id.widget_root,
                launchAppPi(context, widgetId, "momrise://dashboard"),
            )
            views.setOnClickPendingIntent(
                R.id.btn_food,
                launchAppPi(context, widgetId + 1, "momrise://nutrition"),
            )
            views.setOnClickPendingIntent(
                R.id.btn_water,
                launchAppPi(context, widgetId + 4, "momrise://water"),
            )
            views.setOnClickPendingIntent(
                R.id.btn_exercise,
                launchAppPi(context, widgetId + 2, "momrise://exercise"),
            )
            views.setOnClickPendingIntent(
                R.id.btn_weight,
                launchAppPi(context, widgetId + 3, "momrise://progress"),
            )

            manager.updateAppWidget(widgetId, views)
        }

        private fun launchAppPi(
            context: Context,
            requestCode: Int,
            uri: String,
        ): PendingIntent {
            // Persist the target route into the SAME prefs HomeWidget reads
            // — this is the only path Flutter is guaranteed to see when the
            // activity starts cold. PendingIntent extras + getIntent().getData()
            // were unreliable across reinstalls / launcher-cached PendingIntents.
            HomeWidgetPlugin.getData(context).edit()
                .putString("momrise_launch_route", uri)
                .apply()
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(uri))
                .setClass(context, MainActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            return PendingIntent.getActivity(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }

        private fun waterPlusPi(context: Context, widgetId: Int): PendingIntent {
            val intent = Intent(context, WaterWidgetProvider::class.java).apply {
                action = ACTION_WATER_PLUS
                data = Uri.parse("momrise://widget/$widgetId/plus")
            }
            return PendingIntent.getBroadcast(
                context,
                widgetId * 100,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }

        private fun buildRing(progress: Float): Bitmap {
            val size = 240
            val bmp = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bmp)
            val stroke = 18f
            val pad = stroke / 2 + 6f
            val rect = RectF(pad, pad, size - pad, size - pad)

            val trackPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
                style = Paint.Style.STROKE
                strokeWidth = stroke
                strokeCap = Paint.Cap.ROUND
                color = ringTrack
            }
            canvas.drawArc(rect, 0f, 360f, false, trackPaint)

            val pct = progress.coerceIn(0f, 1f)
            if (pct > 0f) {
                val sweep = 360f * pct
                val gradient = LinearGradient(
                    rect.left,
                    rect.top,
                    rect.right,
                    rect.bottom,
                    ringStart,
                    ringEnd,
                    Shader.TileMode.CLAMP,
                )
                val arcPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    style = Paint.Style.STROKE
                    strokeWidth = stroke
                    strokeCap = Paint.Cap.ROUND
                    shader = gradient
                }
                canvas.drawArc(rect, -90f, sweep, false, arcPaint)
            }
            return bmp
        }

        fun renderAll(context: Context) {
            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(
                ComponentName(context, WaterWidgetProvider::class.java)
            )
            for (id in ids) render(context, mgr, id)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (id in appWidgetIds) {
            render(context, appWidgetManager, id)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_WATER_PLUS) {
            val next = readMl(context) + WATER_STEP_ML
            writeMl(context, next)
            renderAll(context)
        }
    }
}
