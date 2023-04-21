class Failure {
  final String message; // to display the failure message
  final StackTrace stackTrace; // to display the failure stack
  const Failure(this.message, this.stackTrace);
}
