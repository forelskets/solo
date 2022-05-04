class TransactionModel {
  String responseCode;
  String message;
  List<Payment> payment;

  TransactionModel({this.responseCode, this.message, this.payment});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['payment'] != null) {
       // ignore: deprecated_member_use
      payment = new List<Payment>();
      json['payment'].forEach((v) {
        payment.add(new Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.payment != null) {
      data['payment'] = this.payment.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  String id;
  String userId;
  String bidId;
  String dealId;
  String payment;
  String txnId;
  String pDate;
  String status;
  String createdDate;
  String profilePic;

  Payment(
      {this.id,
      this.userId,
      this.bidId,
      this.dealId,
      this.payment,
      this.txnId,
      this.pDate,
      this.status,
      this.createdDate,
      this.profilePic});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bidId = json['bid_id'];
    dealId = json['deal_id'];
    payment = json['payment'];
    txnId = json['txn_id'];
    pDate = json['p_date'];
    status = json['status'];
    createdDate = json['created_date'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bid_id'] = this.bidId;
    data['deal_id'] = this.dealId;
    data['payment'] = this.payment;
    data['txn_id'] = this.txnId;
    data['p_date'] = this.pDate;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
