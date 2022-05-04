class BidDetailModel {
  String status;
  String msg;
  Restaurant restaurant;
  List<Bidding> bidding;

  BidDetailModel({this.status, this.msg, this.restaurant, this.bidding});

  BidDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
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
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    if (this.bidding != null) {
      data['bidding'] = this.bidding.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  String resId;
  String resName;
  String resDesc;
  List<String> resImage;
  String resRatings;
  String originalPrice;
  String bidClosesIn;
  String buyoutPrice;
  String reviewCount;
  String biddingCount;

  Restaurant(
      {this.resId,
      this.resName,
      this.resDesc,
      this.resImage,
      this.resRatings,
      this.originalPrice,
      this.bidClosesIn,
      this.buyoutPrice,
      this.reviewCount,
      this.biddingCount});

  Restaurant.fromJson(Map<String, dynamic> json) {
    resId = json['res_id'];
    resName = json['res_name'];
    resDesc = json['res_desc'];
    resImage = json['res_image'].cast<String>();
    resRatings = json['res_ratings'];
    originalPrice = json['original_price'];
    bidClosesIn = json['bid_closes_in'];
    buyoutPrice = json['buyout_price'];
    reviewCount = json['review_count'];
    biddingCount = json['bidding_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_id'] = this.resId;
    data['res_name'] = this.resName;
    data['res_desc'] = this.resDesc;
    data['res_image'] = this.resImage;
    data['res_ratings'] = this.resRatings;
    data['original_price'] = this.originalPrice;
    data['bid_closes_in'] = this.bidClosesIn;
    data['buyout_price'] = this.buyoutPrice;
    data['review_count'] = this.reviewCount;
    data['bidding_count'] = this.biddingCount;
    return data;
  }
}

class Bidding {
  String id;
  String userId;
  String resId;
  String bidPrice;
  String status;
  String createdDate;

  Bidding(
      {this.id,
      this.userId,
      this.resId,
      this.bidPrice,
      this.status,
      this.createdDate});

  Bidding.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    resId = json['res_id'];
    bidPrice = json['bid_price'];
    status = json['status'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['res_id'] = this.resId;
    data['bid_price'] = this.bidPrice;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    return data;
  }
}
