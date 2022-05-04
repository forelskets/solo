import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/booking_item_model.dart';

class GetBookingApi {
  Future<BookItemModel> getBookingApi(String userid,String status) async {
    var responseJson;
    await http.post(
        Uri.parse(
            '${baseUrl()}get_booking_by_vendor'),
        body: {
          'vid': userid,
          'status': status
        }).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return BookItemModel.fromJson(responseJson);
  }

  dynamic _returnResponse(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);

        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 401:
        throw Exception(response.body.toString());
      case 403:
        throw Exception(response.body.toString());
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
