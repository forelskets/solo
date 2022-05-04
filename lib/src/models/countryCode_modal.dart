class CountryCodeModal {
  int status;
  String msg;
  List<CountryCode> countryCode;

  CountryCodeModal({this.status, this.msg, this.countryCode});

  CountryCodeModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['country_code'] != null) {
       // ignore: deprecated_member_use
      countryCode = new List<CountryCode>();
      json['country_code'].forEach((v) {
        countryCode.add(new CountryCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.countryCode != null) {
      data['country_code'] = this.countryCode.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryCode {
  String id;
  String countryCode;
  String countryName;
  String createDate;

  CountryCode({this.id, this.countryCode, this.countryName, this.createDate});

  CountryCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['create_date'] = this.createDate;
    return data;
  }
}