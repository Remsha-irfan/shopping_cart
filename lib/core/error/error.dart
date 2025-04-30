abstract class Failure {
  final String message;
  Failure(this.message);
}

class GeneralFailure extends Failure {
  GeneralFailure(String message) : super(message);
}

class DataParsingFailure extends Failure {
  DataParsingFailure(String message) : super(message);
}

class FileNotFoundFailure extends Failure {
  FileNotFoundFailure(String message) : super(message);
}
