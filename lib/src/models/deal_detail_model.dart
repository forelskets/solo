class DealDetailModel {
  String status;
  String msg;
  Deal deal;
  List<Bidding> bidding;

  DealDetailModel({this.status, this.msg, this.deal, this.bidding});

  DealDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    deal = json['deal'] != null ? new Deal.fromJson(json['deal']) : null;
    if (json['bidding'] != null) {
       // ignore: deprecated_member_use
      bidding = new List<Bidding>();
      json['bidding'].forEach((v) {
        bidding.add(new Bidding.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.deal != null) {
      data['deal'] = this.deal.toJson();
    }
    if (this.bidding != null) {
      data['bidding'] = this.bidding.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Deal {
  String id;
  String vId;
  String cId;
  String serviceId;
  String dealName;
  String service;
  String originalServiceCost;
  String startPrice;
  String buyoutPrice;
  String timeFrom;
  String timeTo;
  String date;
  String status;
  String createDate;

  Deal(
      {this.id,
      this.vId,
      this.cId,
      this.serviceId,
      this.dealName,
      this.service,
      this.originalServiceCost,
      this.startPrice,
      this.buyoutPrice,
      this.timeFrom,
      this.timeTo,
      this.date,
      this.status,
      this.createDate});

  Deal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vId = json['v_id'];
    cId = json['c_id'];
    serviceId = json['service_id'];
    dealName = json['deal_name'];
    service = json['service'];
    originalServiceCost = json['original_service_cost'];
    startPrice = json['start_price'];
    buyoutPrice = json['buyout_price'];
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
    date = json['date'];
    status = json['status'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['v_id'] = this.vId;
    data['c_id'] = this.cId;
    data['service_id'] = this.serviceId;
    data['deal_name'] = this.dealName;
    data['service'] = this.service;
    data['original_service_cost'] = this.originalServiceCost;
    data['start_price'] = this.startPrice;
    data['buyout_price'] = this.buyoutPrice;
    data['time_from'] = this.timeFrom;
    data['time_to'] = this.timeTo;
    data['date'] = this.date;
    data['status'] = this.status;
    data['create_date'] = this.createDate;
    return data;
  }
}

class Bidding {
  String id;
  String userId;
  String dealId;
  String bidPrice;
  String status;
  String createdDate;
  String username;
  String dealName;
  String serviceName;
  String date;
  String time;

  Bidding(
      {this.id,
      this.userId,
      this.dealId,
      this.bidPrice,
      this.status,
      this.createdDate,
      this.username,
      this.dealName,
      this.serviceName,
      this.date,
      this.time});

  Bidding.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    dealId = json['deal_id'];
    bidPrice = json['bid_price'];
    status = json['status'];
    createdDate = json['created_date'];
    username = json['username'];
    dealName = json['deal_name'];
    serviceName = json['service_name'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['deal_id'] = this.dealId;
    data['bid_price'] = this.bidPrice;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['username'] = this.username;
    data['deal_name'] = this.dealName;
    data['service_name'] = this.serviceName;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}
