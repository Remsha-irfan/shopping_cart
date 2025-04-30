abstract class Failure {
  final String message;
  Failure(this.message);
}

class GeneralFailure extends Failure {
  GeneralFailure(super.message);
}

class DataParsingFailure extends Failure {
  DataParsingFailure(super.message);
}
