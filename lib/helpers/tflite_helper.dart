import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteHelper {
  static final TFLiteHelper _instance = TFLiteHelper._internal();
  factory TFLiteHelper() => _instance;
  TFLiteHelper._internal();

  Interpreter? _interpreter;
  List<String> _labels = [];

  bool get isLoaded => _interpreter != null;

  // Load model and labels
  Future<void> loadModel() async {
    try {
      print('🔍 Loading model...');
      _interpreter = await Interpreter.fromAsset('assets/models/best_head_quant.tflite');
      print('✅ Model loaded successfully!');

      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData
          .split('\n')
          .where((element) => element.trim().isNotEmpty)
          .toList();
      print('✅ Labels loaded: ${_labels.length}');
    } catch (e) {
      print('❌ Error loading model: $e');
    }
  }

  // Run inference on an image
  Future<List<double>> runModel(File imageFile) async {
    if (_interpreter == null) {
      print('⚠️ Interpreter not initialized!');
      return [];
    }

    try {
      final rawBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(rawBytes);
      if (image == null) throw Exception("Invalid image");

      // Resize to model input size (224x224)
      final resized = img.copyResize(image, width: 224, height: 224);

      // Prepare input tensor: shape [1, 224, 224, 3]
      List<List<List<List<double>>>> input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              final pixel = resized.getPixel(x, y);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );

      // Prepare output tensor: shape [1, num_labels]
      List<List<double>> output = List.generate(
        1,
        (_) => List.filled(_labels.length, 0.0),
      );

      // Run inference
      _interpreter!.run(input, output);

      print('✅ Inference done! Output: $output');
      return List<double>.from(output[0]);
    } catch (e) {
      print('❌ Error running inference: $e');
      return [];
    }
  }

  // Get label with highest probability
  String getTopLabel(List<double> output) {
    if (output.isEmpty || _labels.isEmpty) return "Unknown";
    int maxIndex = 0;
    double maxValue = output[0];
    for (int i = 1; i < output.length; i++) {
      if (output[i] > maxValue) {
        maxValue = output[i];
        maxIndex = i;
      }
    }
    return "${_labels[maxIndex]} (${(maxValue * 100).toStringAsFixed(2)}%)";
  }

  // Close interpreter to free memory
  void close() {
    _interpreter?.close();
    _interpreter = null;
    print('🧹 Interpreter closed.');
  }
}
