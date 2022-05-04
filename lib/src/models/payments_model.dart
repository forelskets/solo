class PaymentsModel {
  String responseCode;
  String message;
  String totalEarning;
  List<Payment> payment;
  String status;

  PaymentsModel(
      {this.responseCode,
      this.message,
      this.totalEarning,
      this.payment,
      this.status});

  PaymentsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalEarning = json['total_earning'];
    if (json['payment'] != null) {
       // ignore: deprecated_member_use
      payment = new List<Payment>();
      json['payment'].forEach((v) {
        payment.add(new Payment.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    data['total_earning'] = this.totalEarning;
    if (this.payment != null) {
      data['payment'] = this.payment.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
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
  String createdDate;
  String dealName;

  Payment(
      {this.id,
      this.userId,
      this.bidId,
      this.dealId,
      this.payment,
      this.txnId,
      this.pDate,
      this.createdDate,
      this.dealName});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bidId = json['bid_id'];
    dealId = json['deal_id'];
    payment = json['payment'];
    txnId = json['txn_id'];
    pDate = json['p_date'];
    createdDate = json['created_date'];
    dealName = json['deal_name'];
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
    data['created_date'] = this.createdDate;
    data['deal_name'] = this.dealName;
    return data;
  }
}