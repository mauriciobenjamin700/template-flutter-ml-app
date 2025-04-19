class ErrorPredictException implements Exception {
  final String mensagem;

  ErrorPredictException(this.mensagem);

  @override
  String toString() {
    return 'MinhaExcecaoPersonalizada: $mensagem';
  }
}
