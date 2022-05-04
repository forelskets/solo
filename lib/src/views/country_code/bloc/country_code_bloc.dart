import 'package:rxdart/rxdart.dart';

class CountryClodeBloc {
  final _countryCodeController = PublishSubject<String>();

  Stream<String> get codeStream => _countryCodeController.stream;

  countrySink(String value) {
    _countryCodeController.sink.add(value);
  }

  dispose() {
    _countryCodeController.close();
  }
}

final countryClodeBloc = CountryClodeBloc();
