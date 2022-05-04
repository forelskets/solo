class ProductModel {
  String status;
  String msg;
  String servicesCount;
  String bookingCount;
  String productsCount;
  List<Restaurants> restaurants;

  ProductModel(
      {this.status,
      this.msg,
      this.servicesCount,
      this.bookingCount,
      this.productsCount,
      this.restaurants});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    servicesCount = json['services_count'];
    bookingCount = json['booking_count'];
    productsCount = json['products_count'];
    if (json['restaurants'] != null) {
      restaurants = <Restaurants>[];
      json['restaurants'].forEach((v) {
        restaurants.add(new Restaurants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['services_count'] = this.servicesCount;
    data['booking_count'] = this.bookingCount;
    data['products_count'] = this.productsCount;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurants {
  String resId;
  String vid;
  String catId;
  String resName;
  String resNameU;
  String resDesc;
  String resDescU;
  String resWebsite;
  ResImage resImage;
  String logo;
  String resPhone;
  String resAddress;
  String resIsOpen;
  String resStatus;
  String resRatings;
  String status;
  String resVideo;
  String resUrl;
  String mfo;
  String mondayFrom;
  String mondayTo;
  String tuesdayFrom;
  String tuesdayTo;
  String wednesdayFrom;
  String wednesdayTo;
  String thursdayFrom;
  String thursdayTo;
  String fridayFrom;
  String fridayTo;
  String saturdayFrom;
  String saturdayTo;
  String sundayFrom;
  String sundayTo;
  String lat;
  String lon;
  String approved;
  String resCreateDate;
  String cName;
  int reviewCount;
  int viewCount;
  List<String> allImage;

  Restaurants(
      {this.resId,
      this.vid,
      this.catId,
      this.resName,
      this.resNameU,
      this.resDesc,
      this.resDescU,
      this.resWebsite,
      this.resImage,
      this.logo,
      this.resPhone,
      this.resAddress,
      this.resIsOpen,
      this.resStatus,
      this.resRatings,
      this.status,
      this.resVideo,
      this.resUrl,
      this.mfo,
      this.mondayFrom,
      this.mondayTo,
      this.tuesdayFrom,
      this.tuesdayTo,
      this.wednesdayFrom,
      this.wednesdayTo,
      this.thursdayFrom,
      this.thursdayTo,
      this.fridayFrom,
      this.fridayTo,
      this.saturdayFrom,
      this.saturdayTo,
      this.sundayFrom,
      this.sundayTo,
      this.lat,
      this.lon,
      this.approved,
      this.resCreateDate,
      this.cName,
      this.reviewCount,
      this.viewCount,
      this.allImage});

  Restaurants.fromJson(Map<String, dynamic> json) {
    resId = json['res_id'];
    vid = json['vid'];
    catId = json['cat_id'];
    resName = json['res_name'];
    resNameU = json['res_name_u'];
    resDesc = json['res_desc'];
    resDescU = json['res_desc_u'];
    resWebsite = json['res_website'];
    resImage = json['res_image'] != null
        ? new ResImage.fromJson(json['res_image'])
        : null;
    logo = json['logo'];
    resPhone = json['res_phone'];
    resAddress = json['res_address'];
    resIsOpen = json['res_isOpen'];
    resStatus = json['res_status'];
    resRatings = json['res_ratings'];
    status = json['status'];
    resVideo = json['res_video'];
    resUrl = json['res_url'];
    mfo = json['mfo'];
    mondayFrom = json['monday_from'];
    mondayTo = json['monday_to'];
    tuesdayFrom = json['tuesday_from'];
    tuesdayTo = json['tuesday_to'];
    wednesdayFrom = json['wednesday_from'];
    wednesdayTo = json['wednesday_to'];
    thursdayFrom = json['thursday_from'];
    thursdayTo = json['thursday_to'];
    fridayFrom = json['friday_from'];
    fridayTo = json['friday_to'];
    saturdayFrom = json['saturday_from'];
    saturdayTo = json['saturday_to'];
    sundayFrom = json['sunday_from'];
    sundayTo = json['sunday_to'];
    lat = json['lat'];
    lon = json['lon'];
    approved = json['approved'];
    resCreateDate = json['res_create_date'];
    cName = json['c_name'];
    reviewCount = json['review_count'];
    viewCount = json['view_count'];
    allImage = json['all_image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_id'] = this.resId;
    data['vid'] = this.vid;
    data['cat_id'] = this.catId;
    data['res_name'] = this.resName;
    data['res_name_u'] = this.resNameU;
    data['res_desc'] = this.resDesc;
    data['res_desc_u'] = this.resDescU;
    data['res_website'] = this.resWebsite;
    if (this.resImage != null) {
      data['res_image'] = this.resImage.toJson();
    }
    data['logo'] = this.logo;
    data['res_phone'] = this.resPhone;
    data['res_address'] = this.resAddress;
    data['res_isOpen'] = this.resIsOpen;
    data['res_status'] = this.resStatus;
    data['res_ratings'] = this.resRatings;
    data['status'] = this.status;
    data['res_video'] = this.resVideo;
    data['res_url'] = this.resUrl;
    data['mfo'] = this.mfo;
    data['monday_from'] = this.mondayFrom;
    data['monday_to'] = this.mondayTo;
    data['tuesday_from'] = this.tuesdayFrom;
    data['tuesday_to'] = this.tuesdayTo;
    data['wednesday_from'] = this.wednesdayFrom;
    data['wednesday_to'] = this.wednesdayTo;
    data['thursday_from'] = this.thursdayFrom;
    data['thursday_to'] = this.thursdayTo;
    data['friday_from'] = this.fridayFrom;
    data['friday_to'] = this.fridayTo;
    data['saturday_from'] = this.saturdayFrom;
    data['saturday_to'] = this.saturdayTo;
    data['sunday_from'] = this.sundayFrom;
    data['sunday_to'] = this.sundayTo;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['approved'] = this.approved;
    data['res_create_date'] = this.resCreateDate;
    data['c_name'] = this.cName;
    data['review_count'] = this.reviewCount;
    data['view_count'] = this.viewCount;
    data['all_image'] = this.allImage;
    return data;
  }
}

class ResImage {
  String resImag0;
  String resImag1;
  String resImag2;
  String resImag3;

  ResImage({this.resImag0, this.resImag1, this.resImag2, this.resImag3});

  ResImage.fromJson(Map<String, dynamic> json) {
    resImag0 = json['res_imag0'];
    resImag1 = json['res_imag1'];
    resImag2 = json['res_imag2'];
    resImag3 = json['res_imag3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_imag0'] = this.resImag0;
    data['res_imag1'] = this.resImag1;
    data['res_imag2'] = this.resImag2;
    data['res_imag3'] = this.resImag3;
    return data;
  }
}
