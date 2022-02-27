
import 'dart:async';

import 'package:flutter/services.dart';


// For more info on plugin development -> https://flutter.dev/docs/development/packages-and-plugins/developing-packages#step-2b-add-android-platform-code-ktjava .

/// The plugin provides OCR recognition on an image / photo file.
/// 
/// ```dart
/// String resultJson = await SimpleOcrPlugin.performOCR("your/image/path", delimiter: "---");
/// ```
class SimpleOcrPlugin {

  /// The default value for newline delimiter. 
  /// 
  /// Due to the result returned by the plugin is in json (simply textual) format; hence it 
  /// is important to replace the \n to a specific delimter sequence. 
  /// Default delimiter sequence is "   ".
  static const String NewLineDelimiter = "   ";

  static const MethodChannel _channel = const MethodChannel('simple_ocr_plugin');

  /// Returns the recognized text blocks available on [imagePath], an optional newline [delimiter] could be provided.
  static Future<String> performOCR(String imagePath, { String delimiter = SimpleOcrPlugin.NewLineDelimiter }) async {
    final String _value = await _channel.invokeMethod("performOCR", {
      "imagePath": imagePath,
      "delimiter": delimiter, // (delimiter == null || delimiter.trim()=="")?NewLineDelimiter:delimiter,
    });
    return _value;
  }

}
