class GetServiceModal {
  String responseCode;
  String message;
  List<Data> data;
  String status;

  GetServiceModal({this.responseCode, this.message, this.data, this.status});

  GetServiceModal.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['data'] != null) {
      // ignore: deprecated_member_use
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String id;
  String catId;
  String resId;
  String vId;
  String serviceName;
  String servicePrice;
  String serviceDescription;
  String serviceImage;
  String priceUnit;
  String duration;
  String serviceRatings;
  String createdDate;
  String categotyName;
  String storeName;
  List<ServicesReviews> servicesReviews;

  Data(
      {this.id,
      this.catId,
      this.resId,
      this.vId,
      this.serviceName,
      this.servicePrice,
      this.serviceDescription,
      this.serviceImage,
      this.priceUnit,
      this.duration,
      this.serviceRatings,
      this.createdDate,
      this.categotyName,
      this.storeName,
      this.servicesReviews});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catId = json['cat_id'];
    resId = json['res_id'];
    vId = json['v_id'];
    serviceName = json['service_name'];
    servicePrice = json['service_price'];
    serviceDescription = json['service_description'];
    serviceImage = json['service_image'];
    priceUnit = json['price_unit'];
    duration = json['duration'];
    serviceRatings = json['service_ratings'];
    createdDate = json['created_date'];
    categotyName = json['categoty_name'];
    storeName = json['store_name'];
    if (json['services_reviews'] != null) {
      // ignore: deprecated_member_use
      servicesReviews = new List<ServicesReviews>();
      json['services_reviews'].forEach((v) {
        servicesReviews.add(new ServicesReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cat_id'] = this.catId;
    data['res_id'] = this.resId;
    data['v_id'] = this.vId;
    data['service_name'] = this.serviceName;
    data['service_price'] = this.servicePrice;
    data['service_description'] = this.serviceDescription;
    data['service_image'] = this.serviceImage;
    data['price_unit'] = this.priceUnit;
    data['duration'] = this.duration;
    data['service_ratings'] = this.serviceRatings;
    data['created_date'] = this.createdDate;
    data['categoty_name'] = this.categotyName;
    data['store_name'] = this.storeName;
    if (this.servicesReviews != null) {
      data['services_reviews'] =
          this.servicesReviews.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicesReviews {
  String revId;
  String revService;
  String revUser;
  String revStars;
  String revText;
  String revDate;
  String username;
  String profilePic;
  RevUserData revUserData;

  ServicesReviews(
      {this.revId,
      this.revService,
      this.revUser,
      this.revStars,
      this.revText,
      this.revDate,
      this.username,
      this.profilePic,
      this.revUserData});

  ServicesReviews.fromJson(Map<String, dynamic> json) {
    revId = json['rev_id'];
    revService = json['rev_service'];
    revUser = json['rev_user'];
    revStars = json['rev_stars'];
    revText = json['rev_text'];
    revDate = json['rev_date'];
    username = json['username'];
    profilePic = json['profile_pic'];
    revUserData = json['rev_user_data'] != null
        ? new RevUserData.fromJson(json['rev_user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rev_id'] = this.revId;
    data['rev_service'] = this.revService;
    data['rev_user'] = this.revUser;
    data['rev_stars'] = this.revStars;
    data['rev_text'] = this.revText;
    data['rev_date'] = this.revDate;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    if (this.revUserData != null) {
      data['rev_user_data'] = this.revUserData.toJson();
    }
    return data;
  }
}

class RevUserData {
  String id;
  String username;
  String email;
  String mobile;
  String password;
  String profilePic;
  String facebookId;
  String type;
  String isGold;
  String address;
  String city;
  String country;
  String deviceToken;
  String date;

  RevUserData(
      {this.id,
      this.username,
      this.email,
      this.mobile,
      this.password,
      this.profilePic,
      this.facebookId,
      this.type,
      this.isGold,
      this.address,
      this.city,
      this.country,
      this.deviceToken,
      this.date});

  RevUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    profilePic = json['profile_pic'];
    facebookId = json['facebook_id'];
    type = json['type'];
    isGold = json['isGold'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    deviceToken = json['device_token'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['profile_pic'] = this.profilePic;
    data['facebook_id'] = this.facebookId;
    data['type'] = this.type;
    data['isGold'] = this.isGold;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['device_token'] = this.deviceToken;
    data['date'] = this.date;
    return data;
  }
}