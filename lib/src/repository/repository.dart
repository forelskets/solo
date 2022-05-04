import 'package:vendue_vendor/src/models/booking_item_model.dart';
import 'package:vendue_vendor/src/provider/getBooking_api.dart';

class Repository {
  Future<BookItemModel> getBookingApiRepository(
      String userid, String status) async {
    return await GetBookingApi().getBookingApi(userid, status);
  }
}
