// class ForgotModel {
//   int status;
//   String msg;
//   String newPass;

//   ForgotModel({this.status, this.msg, this.newPass});

//   ForgotModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     msg = json['msg'];
//     newPass = json['new_pass'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['msg'] = this.msg;
//     data['new_pass'] = this.newPass;
//     return data;
//   }
// }

class ForgotModel {
  int status;
  String msg;
  int newPass;

  ForgotModel({this.status, this.msg, this.newPass});

  ForgotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    newPass = json['new_pass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['new_pass'] = this.newPass;
    return data;
  }
}