package com.prakash.text_me;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.view.WindowManager;
//import android.view.ViewTreeObserver;

public class MainActivity extends FlutterActivity {

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
  }
}
