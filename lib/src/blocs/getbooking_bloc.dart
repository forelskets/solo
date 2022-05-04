
import 'package:rxdart/rxdart.dart';
import 'package:vendue_vendor/src/models/booking_item_model.dart';
import 'package:vendue_vendor/src/repository/repository.dart';


class GetBookingBloc {
   final _getBookingController = PublishSubject<BookItemModel>();

  Stream <BookItemModel> get getBookingStream => _getBookingController.stream;

  Future getBookingSink(String userid, String status) async {
    BookItemModel getBookingModal = await Repository().getBookingApiRepository(userid,status);
    _getBookingController.sink.add(getBookingModal);
  }

  dispose() {
    _getBookingController.close();
  }
}

final getBookingBloc = GetBookingBloc();