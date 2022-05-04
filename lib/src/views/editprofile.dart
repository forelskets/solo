import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/helper/sizeConfig.dart';
import 'package:vendue_vendor/src/models/gender_model.dart';
import 'package:vendue_vendor/src/models/updateuser_model.dart';
import 'package:vendue_vendor/src/views/tabbar.dart';
import 'package:vendue_vendor/src/widgets/customdropdown.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  DateTime dt;

  String birthDate = "";
  UpdateUserModel updateUserModel;
  bool isLoading = false;
  File _image;
  final picker = ImagePicker();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final List<GenderModel> _gendertypeList = [
    GenderModel(
      genderType: 'Male',
    ),
    GenderModel(
      genderType: 'Female',
    ),
    GenderModel(
      genderType: 'Other',
    ),
  ];

  GenderModel _gendertypesModel = GenderModel();
  List<DropdownMenuItem<GenderModel>> _genderDropDownListList;
  List<DropdownMenuItem<GenderModel>> _buildGendertypeDropdown(
      List genderList) {
    // ignore: deprecated_member_use
    List<DropdownMenuItem<GenderModel>> items = List();
    for (GenderModel favouriteFoodModel in genderList) {
      items.add(DropdownMenuItem(
        value: favouriteFoodModel,
        child: Text(favouriteFoodModel.genderType),
      ));
    }
    return items;
  }

  _onChangeGenderDropdown(GenderModel favouriteFoodModel) {
    setState(() {
      print(favouriteFoodModel.genderType);
      _gendertypesModel = favouriteFoodModel;
    });
  }

  @override
  void initState() {
    _emailController.text = userEmail;
    _nameController.text = userName;
    _mobileController.text = userMobile;
    if (userDob.length > 0) {
      if (DateFormat('dd-MM-yyyy').parse(userDob) != null) {
        userDob != ''
            ? dt = DateFormat('dd-MM-yyyy').parse(userDob)
            : dt = null;

        userDob != ''
            ? birthDate = DateFormat("dd-MM-yyyy").format(dt)
            : birthDate = '';
      }
    }

    _genderDropDownListList = _buildGendertypeDropdown(_gendertypeList);

    if (userGender == "Male") {
      _gendertypesModel = _gendertypeList[0];
    } else if (userGender == "Female") {
      _gendertypesModel = _gendertypeList[1];
    } else if (userGender == "Other") {
      _gendertypesModel = _gendertypeList[2];
    } else {
      _gendertypesModel = _gendertypeList[0];
    }
    super.initState();
  }

  dateSelect(BuildContext context, DateTime initialDateTime,
      {DateTime lastDate}) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1970),
        maxTime: lastDate == null
            ? DateTime(initialDateTime.year + 5)
            : DateTime.now(),
        theme: DatePickerTheme(
            cancelStyle: TextStyle(color: Colors.white),
            headerColor: Colors.green,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      print('confirm $date');

      setState(() {
        birthDate = DateFormat("dd-MM-yyyy").format(date);
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" +
            birthDate.toString());
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              "Profile Edit",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _body(context),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(appColorYellow),
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _exploreWidget(context),
                _nameTextfield(context),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _emailTextfield(context),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _mobileTextfield(context),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _genderTextfild(context),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _datePickerWidget(context),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _updateButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _updateButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width - 170,
      child: CustomButtom(
        title: 'Update',
        color: Colors.black,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        onPressed: () {
          _updateUSer();
        },
      ),
    );
  }

  Widget _datePickerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Date of birth',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        GestureDetector(
          onTap: () async {
            dateSelect(context, dt, lastDate: DateTime.now());

            // DateTime birthDate2 = await selectDate(context, DateTime.now(),
            //     lastDate: DateTime.now());

            setState(() {});
          },
          child: Container(
            height: SizeConfig.blockSizeVertical * 7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(10)),
            child: new Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Text(
                    birthDate != '' ? "$birthDate" : "YYYY-MM-DD",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _exploreWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
        _image != null
            ? Stack(
                children: [
                  CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black45,
                      backgroundImage: FileImage(_image)),
                  Positioned.fill(
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipOval(
                            child: Material(
                              elevation: 5,
                              color: appColorYellow
                                  .withOpacity(0.8), // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.black,
                                    )),
                                onTap: () {
                                  selectImageSource();
                                },
                              ),
                            ),
                          ),
                        )),
                  )
                ],
              )
            : userImg != ""
                ? Stack(
                    children: [
                      CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black45,
                          backgroundImage: NetworkImage(userImg)),
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipOval(
                                child: Material(
                                  elevation: 5,
                                  color: appColorWhite
                                      .withOpacity(0.8), // button color
                                  child: InkWell(
                                    splashColor: Colors.red, // inkwell color
                                    child: SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.black,
                                        )),
                                    onTap: () {
                                      selectImageSource();
                                    },
                                  ),
                                ),
                              ),
                            )),
                      )
                    ],
                  )
                : Stack(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[300]),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/user.png",
                            color: appColorYellow,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipOval(
                                child: Material(
                                  elevation: 5,
                                  color: appColorWhite
                                      .withOpacity(0.8), // button color
                                  child: InkWell(
                                    splashColor: Colors.red, // inkwell color
                                    child: SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.black,
                                        )),
                                    onTap: () {
                                      selectImageSource();
                                    },
                                  ),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1,
        ),
        Text(
          userName,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.blockSizeHorizontal * 4),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 5),
      ],
    );
  }

  selectImageSource() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(height: 10.0),
                  Text(
                    "Pick Image",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      getImageFromCamera();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          color: appColorYellow,
                        ),
                        Container(width: 10.0),
                        Text('Camera')
                      ],
                    ),
                  ),
                  Container(height: 15.0),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      getImageFromGallery();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.storage,
                          color: appColorYellow,
                        ),
                        Container(width: 10.0),
                        Text('Gallery')
                      ],
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: ClipOval(
                    child: Material(
                      elevation: 5,
                      color: appColorYellow, // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(
                            width: 25,
                            height: 25,
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            )),
                        onTap: () {
                          closeKeyboard();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Email',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _emailController,
          // focusNode: _emailFocus,'
          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          // onSubmitted: (value) {
          //   FocusScope.of(context).requestFocus(_passwordFocus);
          // },
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  Widget _nameTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Name',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _nameController,
          // focusNode: _emailFocus,
          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          // onSubmitted: (value) {
          //   FocusScope.of(context).requestFocus(_passwordFocus);
          // },
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  Widget _mobileTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Mobile Number',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _mobileController,
          // focusNode: _emailFocus,
          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          // onSubmitted: (value) {
          //   FocusScope.of(context).requestFocus(_passwordFocus);
          // },
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  Widget _genderTextfild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Gender',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomDropdown(
          dropdownMenuItemList: _genderDropDownListList,
          onChanged: _onChangeGenderDropdown,
          value: _gendertypesModel,
          isEnabled: true,
        ),
      ],
    );
  }

  _updateUSer() async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    // String pattternMob = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    // RegExp regExpMob = new RegExp(pattternMob);
    if (regex.hasMatch(_emailController.text) && birthDate != "") {
      setState(() {
        isLoading = true;
      });

      var uri = Uri.parse('${baseUrl()}/vendor_edit');
      var request = new http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.headers.addAll(headers);
      request.fields['id'] = userID;
      request.fields['uname'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['mobile'] = _mobileController.text;
      request.fields['gender'] = _gendertypesModel.genderType;
      request.fields['date_of_birth'] = birthDate.toString();
      if (_image != null) {
        request.files.add(
            await http.MultipartFile.fromPath('profile_image', _image.path));
      }

      var response = await request.send();
      print(response.statusCode);
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responseData);
      updateUserModel = UpdateUserModel.fromJson(userData);

      if (updateUserModel.responseCode == "1") {
        setState(() {
          isLoading = false;
        });

        _showSnackBar(context, "Update your profile successfully");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TabbarScreen(currentIndex: 0)),
        );
      }

      print(responseData);
      if (mounted)
        setState(() {
          isLoading = false;
        });
    } else {
      _showSnackBar(context, "Please enter valid email or birdate null");
    }
  }

  void _showSnackBar(BuildContext context, String text) {
// ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        // backgroundColor: Colors.grey,
        content: Text(text),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );
  }
}
