class AllProductsModel {
  int status;
  String msg;
  List<Restaurants> restaurants;

  AllProductsModel({this.status, this.msg, this.restaurants});

  AllProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['restaurants'] != null) {
       // ignore: deprecated_member_use
      restaurants = new List<Restaurants>();
      
      json['restaurants'].forEach((v) {
        restaurants.add(new Restaurants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
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
  String subCatId;
  String resName;
  String resDesc;
  String resWebsite;
  List<String> resImage;
  List<String> logo;
  String resPhone;
  String resAddress;
  String resIsOpen;
  String resStatus;
  String resCreateDate;
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
  String cName;
  int reviewCount;
  String isLikes;

  Restaurants(
      {this.resId,
      this.vid,
      this.catId,
      this.subCatId,
      this.resName,
      this.resDesc,
      this.resWebsite,
      this.resImage,
      this.logo,
      this.resPhone,
      this.resAddress,
      this.resIsOpen,
      this.resStatus,
      this.resCreateDate,
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
      this.cName,
      this.reviewCount,
      this.isLikes});

  Restaurants.fromJson(Map<String, dynamic> json) {
    resId = json['res_id'];
    vid = json['vid'];
    catId = json['cat_id'];
    subCatId = json['sub_cat_id'];
    resName = json['res_name'];
    resDesc = json['res_desc'];
    resWebsite = json['res_website'];
    resImage = json['res_image'].cast<String>();
    logo = json['logo'].cast<String>();
    resPhone = json['res_phone'];
    resAddress = json['res_address'];
    resIsOpen = json['res_isOpen'];
    resStatus = json['res_status'];
    resCreateDate = json['res_create_date'];
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
    cName = json['c_name'];
    reviewCount = json['review_count'];
    isLikes = json['is_likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_id'] = this.resId;
    data['vid'] = this.vid;
    data['cat_id'] = this.catId;
    data['sub_cat_id'] = this.subCatId;
    data['res_name'] = this.resName;
    data['res_desc'] = this.resDesc;
    data['res_website'] = this.resWebsite;
    data['res_image'] = this.resImage;
    data['logo'] = this.logo;
    data['res_phone'] = this.resPhone;
    data['res_address'] = this.resAddress;
    data['res_isOpen'] = this.resIsOpen;
    data['res_status'] = this.resStatus;
    data['res_create_date'] = this.resCreateDate;
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
    data['c_name'] = this.cName;
    data['review_count'] = this.reviewCount;
    data['is_likes'] = this.isLikes;
    return data;
  }
}
