class SocialModel {
  String responseCode;
  String message;
  UserSocial user;
  String status;

  SocialModel({this.responseCode, this.message, this.user, this.status});

  SocialModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    user = json['user'] != null ? new UserSocial.fromJson(json['user']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class UserSocial {
  String id;
  String firstName;
  String lastName;
  String phone;
  String loginType;
  String email;
  String password;
  String country;
  String termsCondition;
  String emailUbscription;
  String gender;
  String dob;
  String profilePic;
  String otp;
  String otpStatus;
  String location;
  String address;
  String createDate;

  UserSocial(
      {this.id,
      this.firstName,
      this.lastName,
      this.phone,
      this.loginType,
      this.email,
      this.password,
      this.country,
      this.termsCondition,
      this.emailUbscription,
      this.gender,
      this.dob,
      this.profilePic,
      this.otp,
      this.otpStatus,
      this.location,
      this.address,
      this.createDate});

  UserSocial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    loginType = json['login_type'];
    email = json['email'];
    password = json['password'];
    country = json['country'];
    termsCondition = json['terms_condition'];
    emailUbscription = json['email_ubscription'];
    gender = json['gender'];
    dob = json['dob'];
    profilePic = json['profile_pic'];
    otp = json['otp'];
    otpStatus = json['otp_status'];
    location = json['location'];
    address = json['address'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['login_type'] = this.loginType;
    data['email'] = this.email;
    data['password'] = this.password;
    data['country'] = this.country;
    data['terms_condition'] = this.termsCondition;
    data['email_ubscription'] = this.emailUbscription;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['profile_pic'] = this.profilePic;
    data['otp'] = this.otp;
    data['otp_status'] = this.otpStatus;
    data['location'] = this.location;
    data['address'] = this.address;
    data['create_date'] = this.createDate;
    return data;
  }
}
