// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/models/addproduct_model.dart';
import 'package:vendue_vendor/src/models/category_model.dart';
import 'package:place_picker/place_picker.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:async/async.dart';
import 'package:vendue_vendor/src/views/country_code/bloc/country_code_bloc.dart';
import 'package:vendue_vendor/src/views/country_code/reuseble/country_code_picker.dart';
import 'package:vendue_vendor/src/views/tabbar.dart';

class StepperDemo extends StatefulWidget {
  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  double _height, _width;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  String numberPrefix;

  @override
  void initState() {
    _getCat();

    super.initState();
  }

  bool isOverlay = false;

  AddProductModel addProductModel;

  bool validateStructure(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool validateStructureWeb(String value) {
    String pattern = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  _apicall() async {
    print("🕵️🕵️🕵️");
    print("{$userID}");
    print(fileImageArray);

    if (_businessNameController.text.isNotEmpty &&
        _businessDesController.text.isNotEmpty &&
        check != null &&
        _businessPhoneController.text.isNotEmpty &&
        _businessWebController.text.isNotEmpty &&
        _pickedLocation != '') {
      if (validateStructure(_businessPhoneController.text) &&
          validateStructureWeb(_businessWebController.text)) {
        setState(() {
          isLoading = true;
        });
        var request = http.MultipartRequest(
            'POST', Uri.parse('${baseUrl()}/add_restaurant'));

        request.fields.addAll({
          'vid': userID,
          'name': _businessNameController.text,
          'description': _businessDesController.text,
          'cat_id': check.toString(),
          'phone': _businessPhoneController.text,
          'website': _businessWebController.text,
          'address': _pickedLocation.toString(),
          'monday_from':
              _mondayToController != null ? _mondayToController.text : '',
          'monday_to':
              _mondayFromController != null ? _mondayFromController.text : '',
          'tuesday_from': _tueToController != null ? _tueToController.text : '',
          'tuesday_to':
              _tueFromController != null ? _tueFromController.text : '',
          'wednesday_from':
              _wedToController != null ? _wedToController.text : '',
          'wednesday_to':
              _wedFromController != null ? _wedFromController.text : '',
          'thursday_from':
              _thuToController != null ? _thuToController.text : '',
          'thursday_to':
              _thuFromController != null ? _thuFromController.text : '',
          'friday_from': _friToController != null ? _friToController.text : '',
          'friday_to':
              _friFromController != null ? _friFromController.text : '',
          'saturday_from':
              _satToController != null ? _satToController.text : '',
          'saturday_to':
              _satFromController != null ? _satFromController.text : '',
          'sunday_from': _sunToController != null ? _sunToController.text : '',
          'sunday_to':
              _sunFromController != null ? _sunFromController.text : '',
          // 'original_price':
          //     _bidpriceController != null ? _bidpriceController.text : '',
          // 'bid_closes_in':
          //     _bidEndDateController != null ? _bidEndDateController.text : '',
          // 'buyout_price':
          //     _bidBuypriceController != null ? _bidBuypriceController.text : '',

          // 'otime_mon':
          //     'Monday : ${_mondayToController.text} - ${_mondayFromController.text},\nTuesday : ${_tueToController.text} - ${_tueFromController.text},\nWednesday : ${_wedToController.text} - ${_wedFromController.text},\nThursday : ${_thuToController.text} - ${_thuFromController.text},\nFriday: ${_friToController.text} - ${_friFromController.text},\nSaturday: ${_satToController.text} - ${_satFromController.text},\nSunday : ${_sunToController.text} - ${_sunFromController.text},',
          // 'lat': _pickedLocationlatLong.toString(),
          // 'lon': _pickedLocationlatLong.toString(),
        });

        for (var file in fileImageArray) {
          String fileName = file.path.split("/").last;

          var stream =
              new http.ByteStream(DelegatingStream.typed(file.openRead()));
          var length = await file.length(); //imageFile is your image file
          var multipartFileSign = new http.MultipartFile(
              'res_image[]', stream, length,
              filename: fileName + ".jpeg");

          request.files.add(multipartFileSign);
        }

        http.StreamedResponse response = await request.send();

        String responseData =
            await response.stream.transform(utf8.decoder).join();

        Map data = json.decode(responseData);
        print(data[
            "response_code"]); // decodes on response data using UTF8.decoder

        if (data["response_code"] == '1') {
          print(responseData);
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Store Created sucessfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => TabbarScreen(currentIndex: 0),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          print(response.reasonPhrase);
          Fluttertoast.showToast(
              msg: data["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        setState(() {
          isLoading = false;
        });
      } else {
        if (!validateStructure(_businessPhoneController.text)) {
          Fluttertoast.showToast(
              msg: "Please enter valid phone number",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Please enter valid website",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } else {
      _pickedLocation != ""
          ? Fluttertoast.showToast(
              msg: "All the form fields are mandatory",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0)
          : Fluttertoast.showToast(
              msg: "Please add Store location",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Create Store',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(appColorYellow),
              ),
            )
          : Theme(
              data: ThemeData(
                  primaryColor: appColorYellow,
                  buttonColor: Colors.black,
                  colorScheme: ColorScheme.light(primary: Colors.black)),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: appColorYellow,
                            borderRadius: BorderRadius.circular(40)),
                        child: Padding(
                          padding: EdgeInsets.all(_height * 0.015),
                          child: Text(
                            'Create Store in 5 Steps',
                            style: TextStyle(
                                fontSize: _width * 0.035,
                                color: appColorWhite,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Stepper(
                        type: stepperType,
                        physics: ScrollPhysics(),
                        currentStep: _currentStep,
                        onStepTapped: (step) => tapped(step),
                        onStepContinue: continued,
                        onStepCancel: cancel,
                        steps: <Step>[
                          Step(
                            title: new Text('Add Business Name & Description'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _businessNameTextfield(context),
                                SizedBox(
                                  height: _height * 0.25 / 10,
                                ),
                                _buissnessDesTextfield(context),
                                SizedBox(
                                  height: _height * 0.25 / 10,
                                ),
                                // _bidPriceTextfield(context),
                                // SizedBox(
                                //   height: _height * 0.25 / 10,
                                // ),
                                // _bidBuyPriceTextfield(context),
                                // SizedBox(
                                //   height: _height * 0.25 / 10,
                                // ),
                                // _bidEndDateTextfield(context),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 0
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: new Text('Select Categories'),
                            content: Column(
                              children: <Widget>[_categories()],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 1
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: new Text(
                                'Add Business phone number, website & Location'),
                            content: Column(
                              children: <Widget>[
                                _businessPhoneTextfield(context),
                                SizedBox(
                                  height: _height * 0.25 / 10,
                                ),
                                _businessWebTextfield(context),
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 2
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: new Text('Add Business photos'),
                            content: Column(
                              children: <Widget>[
                                images.length > 0
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        height: _height * 1 / 10,
                                        child: AnimationLimiter(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: images.length,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
                                                // return _imageList(index);
                                                return AnimationConfiguration
                                                    .staggeredList(
                                                  position: index,
                                                  duration: const Duration(
                                                      milliseconds: 375),
                                                  child: SlideAnimation(
                                                    horizontalOffset: 50.0,
                                                    child: FadeInAnimation(
                                                        child:
                                                            _imageList(index)),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    : _dummyIMGList()
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 3
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                          Step(
                            title: new Text('Add Business opening hours'),
                            content: Column(
                              children: <Widget>[_step5content()],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 4
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.list),
      //   onPressed: switchStepsType,
      // ),
    );
  }

  // switchStepsType() {
  //   setState(() => stepperType == StepperType.vertical
  //       ? stepperType = StepperType.horizontal
  //       : stepperType = StepperType.vertical);
  // }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 4 ? setState(() => _currentStep += 1) : _apicall();
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : setState(() {});
  }

  /*setp 1 content*/

  final TextEditingController _businessNameController = TextEditingController();
  final FocusNode __businessNameFocus = FocusNode();
  final TextEditingController _businessDesController = TextEditingController();
  final FocusNode __businessDesFocus = FocusNode();
  final FocusNode _bidpriceFocus = FocusNode();

  // ignore: unused_field
  String _valueChangedbidEndDate = '';
  // ignore: unused_field
  String _valueToValidatebidEndDate = '';
  // ignore: unused_field
  String _valueSavedbidEndDate = '';
  // ignore: unused_field

  Widget _businessNameTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Business Name',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _businessNameController,
          focusNode: __businessNameFocus,

          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(__businessDesFocus);
          },
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  Widget _buissnessDesTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 10),
          child: Text(
            'Business Description',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _businessDesController,
          focusNode: __businessDesFocus,

          textCapitalization: TextCapitalization.none,
          maxLines: 5,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_bidpriceFocus);
          },
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  /*setp 2 content*/

  bool isLoading;
  CateModel categoryModel;

  _getCat() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    categoryModel = CateModel.fromJson(userData);

    if (categoryModel.status == 1) {}
    print(responseData);

    setState(() {
      isLoading = false;
    });
  }

  var check;

  Widget _categories() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      padding: EdgeInsets.all(5),
      itemCount: categoryModel.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 110 / 50,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                      color: check == categoryModel.categories[index].id
                          ? Colors.transparent
                          : appColorYellow)),
              color: check == categoryModel.categories[index].id
                  ? Colors.black
                  : Colors.white,
              onPressed: () => setState(
                    () {
                      check = categoryModel.categories[index].id;
                    },
                  ),
              child: check != categoryModel.categories[index].id
                  ? Center(
                      child: Text(
                        categoryModel.categories[index].cName,
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: _width * 0.028,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Center(
                      child: Text(
                      categoryModel.categories[index].cName,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ))),
        );
      },
    );
  }

  /* step3 content */
  final TextEditingController _businessPhoneController =
      TextEditingController();
  final FocusNode _businessPhoneFocus = FocusNode();
  final TextEditingController _businessWebController = TextEditingController();
  final FocusNode _businessWebFocus = FocusNode();
  String _pickedLocation = "";

  Widget _businessPhoneTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Business Phone Number',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _businessPhoneController,
          focusNode: _businessPhoneFocus,
          keyboardType: TextInputType.phone,

          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_businessWebFocus);
          },
          prefixIcon: InkWell(
            onTap: () {
              return showDialog<void>(
                context: context,
                // barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return CountryPicker();
                },
              );
            },
            child: StreamBuilder<String>(
                stream: countryClodeBloc.codeStream,
                initialData: "+91",
                builder: (context, AsyncSnapshot<String> codeValue) {
                  numberPrefix = codeValue.data ?? "+91";

                  return Padding(
                    padding: const EdgeInsets.only(top: 14, left: 10.0),
                    child: Text(
                      codeValue.data,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  );
                }),
          ),
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  Widget _businessWebTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Business Website',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _businessWebController,
          focusNode: _businessWebFocus,

          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () async {
            showPlacePicker();
          },
          child: new Container(
            // height: 50.0,
            color: Colors.transparent,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: new BorderRadius.all(Radius.circular(15.0))),
                child: new Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          _pickedLocation != ""
                              ? _pickedLocation.toString()
                              : "Select Your store location",
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyCqQW9tN814NYD_MdsLIb35HRY65hHomco",
              //  displayLocation: customLocation,
            )));

    setState(() {
      _pickedLocation = result.formattedAddress.toString();
    });

    // Handle the result in your way
    print(result.formattedAddress);
  }

  /* step 4 content*/

  Widget _imageList(int index) {
    Asset asset = images[index];
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: new AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        ),
        Positioned.fill(
            left: 10,
            top: 5,
            child: Align(
                alignment: Alignment.topLeft,
                child: ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      child: SizedBox(
                          width: 25,
                          height: 25,
                          child: Icon(
                            Icons.clear,
                            size: 20,
                          )),
                      onTap: () {
                        setState(() {
                          images.remove(images[index]);
                        });
                      },
                    ),
                  ),
                )))
      ],
    );
  }

  Widget _dummyIMGList() {
    return Container(
      height: _height * 1 / 10,
      child: AnimationLimiter(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: loadAssets,
                    child: new Container(
                      width: 100,
                      height: 300,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          CupertinoIcons.photo_fill_on_rectangle_fill,
                          size: _width * 0.70 / 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Asset> images = <Asset>[];
  List<File> fileImageArray = [];
  // ignore: unused_field
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#b8e5c5",
          actionBarTitle: "Sellapy",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });

    images.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        // fileImageArray.removeWhere((item) => item.path == 'File:');
        fileImageArray.add(tempFile);
      }
    });
    return fileImageArray;
  }

  /* step 5 content*/

  /*monday*/
  final _mondayToController = TextEditingController();
  final _mondayFromController = TextEditingController();
  // ignore: unused_field
  String _valueChangedmondayTo = '';
  // ignore: unused_field
  String _valueToValidatemondayTo = '';
  // ignore: unused_field
  String _valueSavedmondayTo = '';
  // ignore: unused_field
  String _valueChangedmondayFrom = '';
  // ignore: unused_field
  String _valueToValidatemondayFrom = '';
  // ignore: unused_field
  String _valueSavedmondayFrom = '';

  /*tuesday*/
  final _tueToController = TextEditingController();
  final _tueFromController = TextEditingController();
  // ignore: unused_field
  String _valueChangedTueTo = '';
  // ignore: unused_field
  String _valueToValidateTueTo = '';
  // ignore: unused_field
  String _valueSavedTueTo = '';
  // ignore: unused_field
  String _valueChangedTueFrom = '';
  // ignore: unused_field
  String _valueToValidateTueFrom = '';
  // ignore: unused_field
  String _valueSavedTueFrom = '';

  /*wednesday*/
  final _wedToController = TextEditingController();
  final _wedFromController = TextEditingController();
  // ignore: unused_field
  String _valueChangedWedTo = '';
  // ignore: unused_field
  String _valueToValidateWedTo = '';
  // ignore: unused_field
  String _valueSavedWedTo = '';
  // ignore: unused_field
  String _valueChangedWedFrom = '';
  // ignore: unused_field
  String _valueToValidateWedFrom = '';
  // ignore: unused_field
  String _valueSavedWedFrom = '';

  /*thursday*/
  final _thuToController = TextEditingController();
  final _thuFromController = TextEditingController();
  // ignore: unused_field
  String _valueChangedThuTo = '';
  // ignore: unused_field
  String _valueToValidateThuTo = '';
  // ignore: unused_field
  String _valueSavedThuTo = '';
  // ignore: unused_field
  String _valueChangedThuFrom = '';
  // ignore: unused_field
  String _valueToValidateThuFrom = '';
  // ignore: unused_field
  String _valueSavedThuFrom = '';

  /*friday*/
  final _friToController = TextEditingController();
  final _friFromController = TextEditingController();
  // ignore: unused_field
  String _valueChangedFriTo = '';
  // ignore: unused_field
  String _valueToValidateFriTo = '';
  // ignore: unused_field
  String _valueSavedFriTo = '';
  // ignore: unused_field
  String _valueChangedFriFrom = '';
  // ignore: unused_field
  String _valueToValidateFriFrom = '';
  // ignore: unused_field
  String _valueSavedFriFrom = '';

  /*saturday*/
  final _satToController = TextEditingController();
  final _satFromController = TextEditingController();
  // ignore: unused_field
  String _valueChangedSatTo = '';
  // ignore: unused_field
  String _valueToValidateSatTo = '';
  // ignore: unused_field
  String _valueSavedSatTo = '';
  // ignore: unused_field
  String _valueChangedSatFrom = '';
  // ignore: unused_field
  String _valueToValidateSatFrom = '';
  // ignore: unused_field
  String _valueSavedSatFrom = '';

  /*sunday*/
  final _sunToController = TextEditingController();
  final _sunFromController = TextEditingController();
  // ignore: unused_field
  String _valueChangedSunTo = '';
  // ignore: unused_field
  String _valueToValidateSunTo = '';
  // ignore: unused_field
  String _valueSavedSunTo = '';
  // ignore: unused_field
  String _valueChangedSunFrom = '';
  // ignore: unused_field
  String _valueToValidateSunFrom = '';
  // ignore: unused_field
  String _valueSavedSunFrom = '';

  Widget _step5content() {
    return Column(
      children: [
        _widgetMonday(),
        SizedBox(
          height: 10,
        ),
        _widgetTuesday(),
        SizedBox(
          height: 10,
        ),
        _widgetWed(),
        SizedBox(
          height: 10,
        ),
        _widgetThu(),
        SizedBox(
          height: 10,
        ),
        _widgetFri(),
        SizedBox(
          height: 10,
        ),
        _widgetSat(),
        SizedBox(
          height: 10,
        ),
        _widgetSun()
      ],
    );
  }

  Widget _widgetMonday() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Monday",
          style:
              TextStyle(fontSize: _width * 0.035, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _mondayToController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                // timeLabelText: "Time",
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedmondayTo = val),
                validator: (val) {
                  setState(() => _valueToValidatemondayTo = val ?? '');
                  return null;
                },
                onSaved: (val) =>
                    setState(() => _valueSavedmondayTo = val ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.black,
                height: _height * 0.002,
                width: _width * 0.03,
              ),
            ),

            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _mondayFromController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                // timeLabelText: "Time",
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) =>
                    setState(() => _valueChangedmondayFrom = val),
                validator: (val) {
                  setState(() => _valueToValidatemondayFrom = val ?? '');
                  return null;
                },
                onSaved: (val) =>
                    setState(() => _valueSavedmondayFrom = val ?? ''),
              ),
            ),
            // Expanded(
            //   child: DateTimePicker(
            //     type: DateTimePickerType.time,
            //     controller: _mondayController,
            //     //initialValue: _initialValue,
            //     // icon: Icon(Icons.access_time),
            //     timeLabelText: "Time",
            //     //use24HourFormat: false,
            //     //locale: Locale('en', 'US'),
            //     onChanged: (val) => setState(() => _valueChangedmonday = val),
            //     validator: (val) {
            //       setState(() => _valueToValidatemonday = val ?? '');
            //       return null;
            //     },
            //     onSaved: (val) => setState(() => _valueSavedmonday = val ?? ''),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _widgetTuesday() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Tuesday",
          style:
              TextStyle(fontSize: _width * 0.035, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _tueToController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                // timeLabelText: "Time",
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedTueTo = val),
                validator: (val) {
                  setState(() => _valueToValidateTueTo = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSavedTueTo = val ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.black,
                height: _height * 0.002,
                width: _width * 0.03,
              ),
            ),
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _tueFromController,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                timeLabelText: "Time",
                textAlign: TextAlign.center,
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedTueFrom = val),
                validator: (val) {
                  setState(() => _valueToValidateTueFrom = val ?? '');
                  return null;
                },
                onSaved: (val) =>
                    setState(() => _valueSavedTueFrom = val ?? ''),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _widgetWed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Wednesday",
          style:
              TextStyle(fontSize: _width * 0.035, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _wedToController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                // timeLabelText: "Time",
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedWedTo = val),
                validator: (val) {
                  setState(() => _valueToValidateWedTo = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSavedWedTo = val ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.black,
                height: _height * 0.002,
                width: _width * 0.03,
              ),
            ),
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _wedFromController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),

                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedWedFrom = val),
                validator: (val) {
                  setState(() => _valueToValidateWedFrom = val ?? '');
                  return null;
                },
                onSaved: (val) =>
                    setState(() => _valueSavedWedFrom = val ?? ''),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _widgetThu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Thursday",
          style:
              TextStyle(fontSize: _width * 0.035, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _thuToController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                // timeLabelText: "Time",
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedThuTo = val),
                validator: (val) {
                  setState(() => _valueToValidateThuTo = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSavedThuTo = val ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.black,
                height: _height * 0.002,
                width: _width * 0.03,
              ),
            ),
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _thuFromController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),

                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedThuFrom = val),
                validator: (val) {
                  setState(() => _valueToValidateThuFrom = val ?? '');
                  return null;
                },
                onSaved: (val) =>
                    setState(() => _valueSavedThuFrom = val ?? ''),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _widgetFri() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Friday",
          style:
              TextStyle(fontSize: _width * 0.035, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _friToController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                // timeLabelText: "Time",
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedFriTo = val),
                validator: (val) {
                  setState(() => _valueToValidateFriTo = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSavedFriTo = val ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.black,
                height: _height * 0.002,
                width: _width * 0.03,
              ),
            ),
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _friFromController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),

                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedFriFrom = val),
                validator: (val) {
                  setState(() => _valueToValidateFriFrom = val ?? '');
                  return null;
                },
                onSaved: (val) =>
                    setState(() => _valueSavedFriFrom = val ?? ''),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _widgetSat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Saturday",
          style:
              TextStyle(fontSize: _width * 0.035, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _satToController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                // timeLabelText: "Time",
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedSatTo = val),
                validator: (val) {
                  setState(() => _valueToValidateSatTo = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSavedSatTo = val ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.black,
                height: _height * 0.002,
                width: _width * 0.03,
              ),
            ),
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _satFromController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),

                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedSatFrom = val),
                validator: (val) {
                  setState(() => _valueToValidateSatFrom = val ?? '');
                  return null;
                },
                onSaved: (val) =>
                    setState(() => _valueSavedSatFrom = val ?? ''),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _widgetSun() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Sunday",
          style:
              TextStyle(fontSize: _width * 0.035, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _sunToController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),
                // timeLabelText: "Time",
                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedSunTo = val),
                validator: (val) {
                  setState(() => _valueToValidateSunTo = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSavedSunTo = val ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.black,
                height: _height * 0.002,
                width: _width * 0.03,
              ),
            ),
            SizedBox(
              width: _width * 2 / 10,
              height: _height * 0.50 / 10,
              child: DateTimePicker(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                type: DateTimePickerType.time,
                controller: _sunFromController,
                textAlign: TextAlign.center,
                //initialValue: _initialValue,
                // icon: Icon(Icons.access_time),

                //use24HourFormat: false,
                //locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChangedSunFrom = val),
                validator: (val) {
                  setState(() => _valueToValidateSunFrom = val ?? '');
                  return null;
                },
                onSaved: (val) =>
                    setState(() => _valueSavedSunFrom = val ?? ''),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
