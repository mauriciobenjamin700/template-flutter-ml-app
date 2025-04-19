class PredictionResult {
  final int classIndex;
  final double score;

  PredictionResult({required this.classIndex, required this.score});

  @override
  String toString() {
    return 'ClassIndex: $classIndex, Score: $score';
  }
}
