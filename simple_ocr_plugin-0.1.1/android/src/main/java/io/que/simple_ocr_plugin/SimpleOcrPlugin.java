package io.que.simple_ocr_plugin;

import android.content.Context;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.google.android.gms.common.util.Strings;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.mlkit.vision.common.*;
import com.google.mlkit.vision.text.Text;
import com.google.mlkit.vision.text.TextRecognition;
import com.google.mlkit.vision.text.TextRecognizer;
import com.google.mlkit.vision.text.TextRecognizerOptions;

import java.io.File;
import java.io.IOException;

/** SimpleOcrPlugin */
public class SimpleOcrPlugin implements FlutterPlugin, MethodCallHandler {

  static final String debugLabel = "plugin";

  static final String NEWLINE_DELIMITER = "\n";

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  // applicationContext on the corresponding activity
  // also check https://api.flutter.dev/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html
  // and obsolete doc https://github.com/flutter/flutter/wiki/Experimental:-Create-Flutter-Plugin
  private Context ctx;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "simple_ocr_plugin");
    channel.setMethodCallHandler(this);

    this.ctx = flutterPluginBinding.getApplicationContext();
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "simple_ocr_plugin");
    channel.setMethodCallHandler(new SimpleOcrPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    if (call.method.equals("performOCR")) {

      // validation on the imagePath
      String _imagePath = call.argument("imagePath");
      if (Strings.isEmptyOrWhitespace(_imagePath)) {
        result.error("500", "missing a parameter named [imagePath]", "missing a parameter named [imagePath]");
        return;
      }
      final String _delimiter = call.argument("delimiter");
      Log.d(debugLabel, "imagePath: "+_imagePath+", delimiter - ["+_delimiter+"]");

      InputImage _vImg = null;
      try {
        _vImg = InputImage.fromFilePath(this.ctx, Uri.fromFile(new File(_imagePath)));
      } catch (IOException ioe) {
        Log.e(debugLabel, "could not create InputImage: "+ioe.toString());
        return;
      }

      // create the engine - TextRecognizer
      TextRecognizer _engine = TextRecognition.getClient();

      Task<Text> _r = _engine.process(_vImg).addOnSuccessListener(new OnSuccessListener<Text>() {
        @Override
        public void onSuccess(Text text) {
          String _text = text.getText().replaceAll(SimpleOcrPlugin.NEWLINE_DELIMITER, _delimiter);
          Log.d(debugLabel, text.getText());
          Log.d(debugLabel, String.format("{ \"code\": 200, \"text\": \"%s\", \"blocks\": %d }", _text, text.getTextBlocks().size()));
          //result.success("{ \"code\": 200, \"text\": \""+_text+"\", \"blocks\": "+_tResult.getTextBlocks().size()+" }");
          result.success(String.format("{ \"code\": 200, \"text\": \"%s\", \"blocks\": %d }", _text, text.getTextBlocks().size()));
        }
      }).addOnFailureListener(new OnFailureListener() {
        @Override
        public void onFailure(@NonNull Exception e) {
          if (e != null) {
            Log.e(debugLabel, "exception: "+e.toString());
            result.error("500", "exception on recognizing the image", e.toString());
          }
        }
      });

    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
