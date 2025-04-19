import '../schemas/result.dart';

class Constants {
  static String model = "assets/yolo11n_float32.tflite";
  static String labels = "assets/labels.txt";
  static const logo = "assets/images/logo.jpeg";
  static PredictionResult value = PredictionResult(
    classIndex: -1,
    score: -1.0,
  );
}
