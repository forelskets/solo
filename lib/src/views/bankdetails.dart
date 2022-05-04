import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/helper/sizeConfig.dart';
import 'package:vendue_vendor/src/models/User_model.dart';
import 'package:vendue_vendor/src/models/updateuser_model.dart';

class EditBankdetails extends StatefulWidget {
  @override
  _EditBankdetailsState createState() => _EditBankdetailsState();
}

class _EditBankdetailsState extends State<EditBankdetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  DateTime dt;

  String birthDate = "";
  UserModel userModel;
  UpdateUserModel updateUserModel;
  bool isLoading = false;
  final picker = ImagePicker();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _getUSer();

    super.initState();
  }

  _getUSer() async {
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var uri = Uri.parse('${baseUrl()}/vendor_user_data');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    userModel = UserModel.fromJson(userData);
    _nameController.text = userModel.user.uname;
    _emailController.text = userModel.user.email;

    // select = model.user.gender;

    if (userModel.responseCode == "1") {
      userModel.user.dateOfBirth != ''
          ? dt = DateFormat('dd-MM-yyyy').parse(userModel.user.dateOfBirth)
          : dt = null;

      userModel.user.dateOfBirth != ''
          ? birthDate = DateFormat("dd-MM-yyyy").format(dt)
          : birthDate = DateTime.now().toString();

      // birthDate = DateFormat("dd-MM-yyyy")
      //     .format(DateTime.parse(userModel.user.dateOfBirth));

    }
    print(responseData);
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
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
              "Bank Details",
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
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(appColorYellow),
                      ),
                    )
                  : _body(context),
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
                _nameTextfield(context),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _emailTextfield(context),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _phoneTextfield(context),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                _banknamefield(context),
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
          // _updateUSer();
        },
      ),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Account Name',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
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

  Widget _banknamefield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Bank Name',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _phoneController,
          // focusNode: _emailFocus,
          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          // onSubmitted: (value) {
          //   FocusScope.of(context).requestFocus(_passwordFocus);
          // },

          hintText: 'Enter your phone number',

          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  Widget _phoneTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Account Type',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _phoneController,
          // focusNode: _emailFocus,
          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          // onSubmitted: (value) {
          //   FocusScope.of(context).requestFocus(_passwordFocus);
          // },

          hintText: 'Enter your phone number',

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
            'Account Number',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
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

  // Widget _genderTextfild(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 10, bottom: 10),
  //         child: Text(
  //           'Bank Name',
  //           style: TextStyle(
  //               fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
  //         ),
  //       ),
  //       CustomDropdown(
  //         dropdownMenuItemList: _genderDropDownListList,
  //         onChanged: _onChangeGenderDropdown,
  //         value: _gendertypesModel,
  //         isEnabled: true,
  //       ),
  //     ],
  //   );
  // }
}
