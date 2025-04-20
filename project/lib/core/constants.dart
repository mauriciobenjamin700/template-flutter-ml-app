import '../schemas/result.dart';

class Constants {
  static String model = "assets/classify/yolo11n-cls_float16.tflite";
  static String labels = "assets/classify/labels.txt";
  static const logo = "assets/images/logo.jpeg";
  static PredictionResult value = PredictionResult(
    classIndex: -1,
    score: -1.0,
  );
}
