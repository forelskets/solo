class DetailsModel {
  String responseCode;
  String message;
  Store store;
  List<Review> review;
  String status;

  DetailsModel(
      {this.responseCode, this.message, this.store, this.review, this.status});

  DetailsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    if (json['review'] != null) {
      review = <Review>[];
      json['review'].forEach((v) {
        review.add(new Review.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.store != null) {
      data['store'] = this.store.toJson();
    }
    if (this.review != null) {
      data['review'] = this.review.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Store {
  String storeId;
  String vid;
  String storeName;
  String storeDesc;
  List<String> storeImage;
  List<String> galleryImage;
  String storePhone;
  String storeWebsite;
  String facebookUrl;
  String instagramUrl;
  String storeRatings;
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
  String storeAddress;
  String lat;
  String lon;
  String approved;
  String openStatus;
  String storeCreateDate;
  String isLikes;
  String storeMenu;

  Store(
      {this.storeId,
      this.vid,
      this.storeName,
      this.storeDesc,
      this.storeImage,
      this.galleryImage,
      this.storePhone,
      this.storeWebsite,
      this.facebookUrl,
      this.instagramUrl,
      this.storeRatings,
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
      this.storeAddress,
      this.lat,
      this.lon,
      this.approved,
      this.openStatus,
      this.storeCreateDate,
      this.isLikes,
      this.storeMenu});

  Store.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    vid = json['vid'];
    storeName = json['store_name'];
    storeDesc = json['store_desc'];
    storeImage = json['store_image'].cast<String>();
    galleryImage = json['gallery_image'].cast<String>();
    storePhone = json['store_phone'];
    storeWebsite = json['store_website'];
    facebookUrl = json['facebook_url'];
    instagramUrl = json['instagram_url'];
    storeRatings = json['store_ratings'];
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
    storeAddress = json['store_address'];
    lat = json['lat'];
    lon = json['lon'];
    approved = json['approved'];
    openStatus = json['open_status'];
    storeCreateDate = json['store_create_date'];
    isLikes = json['is_likes'];
    storeMenu = json['store_menu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['vid'] = this.vid;
    data['store_name'] = this.storeName;
    data['store_desc'] = this.storeDesc;
    data['store_image'] = this.storeImage;
    data['gallery_image'] = this.galleryImage;
    data['store_phone'] = this.storePhone;
    data['store_website'] = this.storeWebsite;
    data['facebook_url'] = this.facebookUrl;
    data['instagram_url'] = this.instagramUrl;
    data['store_ratings'] = this.storeRatings;
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
    data['store_address'] = this.storeAddress;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['approved'] = this.approved;
    data['open_status'] = this.openStatus;
    data['store_create_date'] = this.storeCreateDate;
    data['is_likes'] = this.isLikes;
    data['store_menu'] = this.storeMenu;
    return data;
  }
}

class Review {
  String revId;
  String revStore;
  String revUser;
  String revStars;
  String revText;
  String revDate;
  String username;
  String profilePic;
  RevUserData revUserData;

  Review(
      {this.revId,
      this.revStore,
      this.revUser,
      this.revStars,
      this.revText,
      this.revDate,
      this.username,
      this.profilePic,
      this.revUserData});

  Review.fromJson(Map<String, dynamic> json) {
    revId = json['rev_id'];
    revStore = json['rev_store'];
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
    data['rev_store'] = this.revStore;
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
  String phone;
  String password;
  String userType;
  String gender;
  String dob;
  String profilePic;
  String deviceToken;
  String createDate;

  RevUserData(
      {this.id,
      this.username,
      this.email,
      this.phone,
      this.password,
      this.userType,
      this.gender,
      this.dob,
      this.profilePic,
      this.deviceToken,
      this.createDate});

  RevUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    userType = json['user_type'];
    gender = json['gender'];
    dob = json['dob'];
    profilePic = json['profile_pic'];
    deviceToken = json['device_token'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['user_type'] = this.userType;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['profile_pic'] = this.profilePic;
    data['device_token'] = this.deviceToken;
    data['create_date'] = this.createDate;
    return data;
  }
}
