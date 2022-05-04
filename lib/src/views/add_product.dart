import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:async/async.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/helper/sizeConfig.dart';
import 'package:vendue_vendor/src/models/getProductModel.dart';
import 'package:vendue_vendor/src/models/product_category_model.dart';
import 'package:vendue_vendor/src/views/tabbar.dart';

// ignore: must_be_immutable
class AddProductPage extends StatefulWidget {
  Function refresh;
  Products products;
  bool editProduct;

  AddProductPage({this.refresh, this.editProduct, this.products});
  @override
  _AddProductPageState createState() => new _AddProductPageState(
      refresh: refresh, products: products, editProduct: editProduct);
}

class _AddProductPageState extends State<AddProductPage> {
  Function refresh;
  Products products;
  bool editProduct;

  _AddProductPageState({this.refresh, this.editProduct, this.products});
  double _height, _width;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _categoryValue;
  String categoryName;
  ProductCateModel productcatmodel;

  bool isLoading = false;
  bool isOverlay = false;

  final _nameController = TextEditingController();
  final _decController = TextEditingController();
  final _priceController = TextEditingController();

  // File _image;
  // final picker = ImagePicker();
  var oldImages = [];
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

  // Future getImageFromGallery() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  // String priceUnit;
  // var priceUnit2 = [
  //   "Hourly",
  //   "Fixed",
  // ];

  @override
  void initState() {
    // _getStore();
    _getCategory();

    if (editProduct != false) {
      _nameController.text = products.productName;
      _decController.text = products.productDescription;
      _priceController.text = products.productPrice;
      _categoryValue = products.catId;
      oldImages.addAll(products.productImage);
    }

    super.initState();
  }

  _getCategory() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}/get_all_product_category');
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
    productcatmodel = ProductCateModel.fromJson(userData);

    print(responseData);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // _getStore() async {
  //   var uri = Uri.parse('${baseUrl()}/get_v_res');
  //   var request = new http.MultipartRequest("POST", uri);
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //   };
  //   request.headers.addAll(headers);
  //   request.fields.addAll({'vid': userID});
  //   // request.fields['user_id'] = userID;
  //   var response = await request.send();
  //   print(response.statusCode);
  //   String responseData = await response.stream.transform(utf8.decoder).join();
  //   var userData = json.decode(responseData);

  //   if (mounted)
  //     setState(() {
  //       storModel = ProductModel.fromJson(userData);
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 1,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: appColorWhite,
            title: editProduct
                ? Text(
                    "Edit Product",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "Add Product",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            centerTitle: true,
            actions: <Widget>[],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 0),
                // padding: EdgeInsets.only(bottom: 20),
                child: CustomScrollView(
                  primary: true,
                  shrinkWrap: false,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: isLoading
                          ? Container(
                              height: SizeConfig.screenHeight,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      appColorYellow),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Wrap(
                                runSpacing: 8,
                                children: [
                                  Column(
                                    children: [
                                      _productImages(),
                                      SizedBox(height: 20),
                                      _productTextField(),
                                      SizedBox(height: 20),
                                      _selectCat(),
                                      SizedBox(height: 20),
                                      _productDesTextField(),
                                      SizedBox(height: 20),
                                      _priceField(),
                                      SizedBox(height: 20),
                                      _submit()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              isOverlay
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: loader(context),
                    ))
                  : Container()
            ],
          )),
    );
  }

  Widget _productImages() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                onTap: loadAssets,
                child: new Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.image, size: _height * 0.50 / 10),
                  ),
                ),
              ),
            ),
            editProduct ? imageUrls() : Container(),
            _imagePicker(),
          ],
        ),
      ),
    );
  }

  Widget imageUrls() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: oldImages.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext ctxt, int index) {
          // return _imageList(index);
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: new Image.network(
                  oldImages[index],
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
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
                                oldImages.remove(oldImages[index]);
                              });
                            },
                          ),
                        ),
                      )))
            ],
          );
        });
  }

  Widget _imagePicker() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext ctxt, int index) {
          Asset asset = images[index];
          // return _imageList(index);
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: AssetThumb(
                  asset: asset,
                  width: 100,
                  height: 100,
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
        });
  }

  Widget _submit() {
    return SizedBox(
        width: _width * 10 / 10,
        height: _height * 0.50 / 10,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: appColorYellow,
          ),
          child: Text(
            'Submit',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _width * 0.35 / 10,
                color: Colors.white),
          ),
          onPressed: () {
            if (images != [] &&
                _nameController.text.isNotEmpty &&
                _categoryValue != null &&
                _decController.text.isNotEmpty &&
                _priceController.text.isNotEmpty) {
              closeKeyboard();
              _apicall();
            } else {
              if (images == []) {
                Flushbar(
                  message: "Please select products images",
                  duration: Duration(seconds: 3),
                  icon: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                )..show(context);
              } else if (_nameController.text.isEmpty) {
                Flushbar(
                  message: "Please enter Product name",
                  duration: Duration(seconds: 3),
                  icon: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                )..show(context);
              } else if (categoryName == null) {
                Flushbar(
                  message: "Please select Product category",
                  duration: Duration(seconds: 3),
                  icon: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                )..show(context);
              } else if (_decController.text.isEmpty) {
                Flushbar(
                  message: "Please enter Product description",
                  duration: Duration(seconds: 3),
                  icon: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                )..show(context);
              } else if (_priceController.text.isEmpty) {
                Flushbar(
                  message: "Please enter Product price",
                  duration: Duration(seconds: 3),
                  icon: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                )..show(context);
              }
            }
          },
        ));
  }

  // Widget _imagePicker(BuildContext context) {
  //   return Container(
  //       alignment: Alignment.centerLeft,
  //       height: 100,
  //       child: _image != null ? _imageWidget() : _dummyIMGList());
  // }

  // Widget _imageWidget() {
  //   return Stack(
  //     children: [
  //       Container(
  //         width: 100,
  //         height: 100,
  //         margin: EdgeInsets.symmetric(horizontal: 5),
  //         child: Image.file(
  //           _image,
  //           width: 300,
  //           height: 300,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       Positioned.fill(
  //           top: 5,
  //           right: 5,
  //           child: Align(
  //               alignment: Alignment.topRight,
  //               child: ClipOval(
  //                 child: Material(
  //                   color: appColorYellow, // button color
  //                   child: InkWell(
  //                     splashColor: Colors.red, // inkwell color
  //                     child: SizedBox(
  //                         width: 25,
  //                         height: 25,
  //                         child: Icon(
  //                           Icons.clear,
  //                           size: 15,
  //                           color: Colors.black,
  //                         )),
  //                     onTap: () {
  //                       setState(() {
  //                         _image = null;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               )))
  //     ],
  //   );
  // }

  // Widget _dummyIMGList() {
  //   return AnimationLimiter(
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 1,
  //       itemBuilder: (BuildContext context, int index) {
  //         return AnimationConfiguration.staggeredList(
  //           position: index,
  //           duration: const Duration(milliseconds: 375),
  //           child: SlideAnimation(
  //             verticalOffset: 50.0,
  //             child: Container(
  //               margin: EdgeInsets.symmetric(horizontal: 5),
  //               child: InkWell(
  //                 onTap: getImageFromGallery,
  //                 child: new Container(
  //                   width: 100,
  //                   height: 300,
  //                   decoration: BoxDecoration(
  //                       color: Colors.grey[200],
  //                       borderRadius: BorderRadius.circular(8)),
  //                   child: Center(
  //                     child: Icon(
  //                       CupertinoIcons.photo_fill,
  //                       color: Colors.black45,
  //                       size: 40,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _productImages() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       RichText(
  //         text: TextSpan(
  //           text: 'Service Image',
  //           style: TextStyle(
  //               color: Colors.grey[800],
  //               // fontWeight: FontWeight.w700,
  //               fontStyle: FontStyle.normal,
  //               fontSize: SizeConfig.blockSizeHorizontal * 3.8,
  //               fontFamily: fontFamily),
  //           children: <TextSpan>[
  //             TextSpan(
  //                 text: ' *',
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.bold, color: Colors.red)),
  //           ],
  //         ),
  //       ),
  //       // Container(
  //       //   height: 55,
  //       //   child: TextField(
  //       //     decoration: inputDecoration2,
  //       //   ),
  //       // ),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       _imagePicker(context),
  //     ],
  //   );
  // }

  Widget _productTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Product Name',
            style: TextStyle(
                color: Colors.grey[800],
                fontFamily: fontFamily,
                fontStyle: FontStyle.normal,
                fontSize: SizeConfig.blockSizeHorizontal * 4),
            children: <TextSpan>[
              TextSpan(
                  text: ' *',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
        ),
        // Container(
        //   height: 55,
        //   child: TextField(
        //     decoration: inputDecoration2,
        //   ),
        // ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: SizeConfig.blockSizeVertical * 6,
          child: CupertinoTextField(
            controller: _nameController,
            padding: EdgeInsets.only(left: 20),
            placeholder: 'Enter name',
            placeholderStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontFamily: fontFamily,
            ),
            textAlign: TextAlign.start,

            //maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _selectCat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Select Category',
            style: TextStyle(
                color: Colors.grey[800],
                fontFamily: fontFamily,
                fontStyle: FontStyle.normal,
                fontSize: SizeConfig.blockSizeHorizontal * 4),
            children: <TextSpan>[
              TextSpan(
                  text: ' *',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
        ),
        // Container(
        //   height: 55,
        //   child: TextField(
        //     decoration: inputDecoration2,
        //   ),
        // ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          child: FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  fillColor: Colors.white,
                  filled: true,
                  errorStyle:
                      TextStyle(color: Colors.redAccent, fontSize: 16.0),
                  // hintText: 'Please select Engine Capacity',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 0.3),
                      borderRadius: BorderRadius.circular(
                        5.0,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 0.3),
                      borderRadius: BorderRadius.circular(
                        5.0,
                      )),
                ),
                isEmpty: _categoryValue == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _categoryValue,
                    isDense: true,
                    hint: Text(
                      "Please select category*",
                      style: TextStyle(
                        color: Colors.black45,
                        fontFamily: fontFamily,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        categoryName = newValue;
                        _categoryValue = newValue;
                        state.didChange(newValue);
                      });
                    },
                    items: productcatmodel.category.map((item) {
                      return new DropdownMenuItem(
                          child: new Text(
                            item.cName,
                            style:
                                TextStyle(fontSize: 15, fontFamily: fontFamily),
                          ),
                          value: item.id.toString());
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _productDesTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Description',
            style: TextStyle(
                color: Colors.grey[800],
                fontFamily: fontFamily,
                fontStyle: FontStyle.normal,
                fontSize: SizeConfig.blockSizeHorizontal * 4),
            children: <TextSpan>[
              TextSpan(
                  text: ' *',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
        ),
        // Container(
        //   height: 55,
        //   child: TextField(
        //     decoration: inputDecoration2,
        //   ),
        // ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: SizeConfig.blockSizeVertical * 14,
          child: CupertinoTextField(
            controller: _decController,
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 10, right: 20),
            placeholder: 'Enter description',
            textAlign: TextAlign.start,
            maxLines: 10,

            placeholderStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontFamily: fontFamily,
            ),
            //maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _priceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Price',
            style: TextStyle(
                color: Colors.grey[800],
                fontFamily: fontFamily,
                fontStyle: FontStyle.normal,
                fontSize: SizeConfig.blockSizeHorizontal * 4),
            children: <TextSpan>[
              TextSpan(
                  text: ' *',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
        ),
        // Container(
        //   height: 55,
        //   child: TextField(
        //     decoration: inputDecoration2,
        //   ),
        // ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: SizeConfig.blockSizeVertical * 6,
          child: CupertinoTextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            padding: EdgeInsets.only(left: 20),
            placeholder: 'Enter price',
            textAlign: TextAlign.start,
            placeholderStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontFamily: fontFamily,
            ),
            //maxLines: 2,
          ),
        ),
      ],
    );
  }

  _apicall() async {
    var stringImage = StringBuffer();

    oldImages.forEach((item) {
      stringImage.write(item + ",");
    });
    setState(() {
      isOverlay = true;
    });
    var request;

    if (editProduct != true) {
      debugPrint('add Product API');
      request = http.MultipartRequest(
          'POST', Uri.parse('${baseUrl()}add_vendor_product'));
    } else {
      debugPrint('edit Product API');
      request = http.MultipartRequest(
          'POST', Uri.parse('${baseUrl()}edit_vendor_product'));
    }

    if (editProduct != true) {
      debugPrint('add Product Field');
      request.fields.addAll({
        'vid': userID,
        'cat_id': _categoryValue.toString(),
        'product_name': _nameController.text,
        'product_price': _priceController.text,
        'product_description': _decController.text,
      });
    } else {
      debugPrint('edit Product Field');
      request.fields.addAll({
        'product_id': products.productId,
        'vid': userID,
        'cat_id': _categoryValue.toString(),
        'product_name': _nameController.text,
        'product_price': _priceController.text,
        'product_description': _decController.text,
        'image_list': stringImage.toString(),
      });
    }

    for (var file in fileImageArray) {
      String fileName = file.path.split("/").last;

      var stream =
          // ignore: deprecated_member_use
          new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length(); //imageFile is your image file
      var multipartFileSign = new http.MultipartFile(
          'product_image[]', stream, length,
          filename: fileName + ".jpeg");

      request.files.add(multipartFileSign);
    }

    // final dir = await getTemporaryDirectory();
    // final targetPath = dir.absolute.path +
    //     "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
    // await FlutterImageCompress.compressAndGetFile(
    //   _image.absolute.path,
    //   targetPath,
    //   quality: 30,
    // ).then((_image) async {
    //   String fileName = _image.path.split("/").last;
    //   var stream = new http.ByteStream(DelegatingStream(_image.openRead()));
    //   var length = await _image.length();
    //   var multipartFileSign = new http.MultipartFile(
    //       'service_image', stream, length,
    //       filename: fileName + ".jpeg");

    //   request.files.add(multipartFileSign);
    // });

    var response = await request.send();

    print(request.fields);

    String responseData = await response.stream
        .transform(utf8.decoder)
        .join(); // decodes on response data using UTF8.decoder
    var data = json.decode(responseData);

    if (data["response_code"] == '1') {
      print(responseData);
      setState(() {
        isOverlay = false;
      });
      Fluttertoast.showToast(
          msg: data["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => TabbarScreen(currentIndex: 2),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      Fluttertoast.showToast(
          msg: data["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {
      isOverlay = false;
    });
  }
}
