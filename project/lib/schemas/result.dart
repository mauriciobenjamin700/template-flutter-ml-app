class PredictionResult {
  final int classIndex;
  final double score;
  final String? label;

  PredictionResult({required this.classIndex, required this.score, this.label});

  @override
  String toString() {
    return 'ClassIndex: $classIndex, Score: $score, Label: $label';
  }
}
