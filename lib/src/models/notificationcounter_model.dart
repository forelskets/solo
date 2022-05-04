class NotificationCounterModel {
  String responseCode;
  String message;
  String count;
  List<UnreadNotification> unreadNotification;
  String status;

  NotificationCounterModel(
      {this.responseCode,
      this.message,
      this.count,
      this.unreadNotification,
      this.status});

  NotificationCounterModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    count = json['count'];
    if (json['unread_notification'] != null) {
      unreadNotification = <UnreadNotification>[];
      json['unread_notification'].forEach((v) {
        unreadNotification.add(new UnreadNotification.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.unreadNotification != null) {
      data['unread_notification'] =
          this.unreadNotification.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class UnreadNotification {
  String notId;
  String vId;
  String dataId;
  String type;
  String title;
  String message;
  String readStatus;
  String date;

  UnreadNotification(
      {this.notId,
      this.vId,
      this.dataId,
      this.type,
      this.title,
      this.message,
      this.readStatus,
      this.date});

  UnreadNotification.fromJson(Map<String, dynamic> json) {
    notId = json['not_id'];
    vId = json['v_id'];
    dataId = json['data_id'];
    type = json['type'];
    title = json['title'];
    message = json['message'];
    readStatus = json['read_status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['not_id'] = this.notId;
    data['v_id'] = this.vId;
    data['data_id'] = this.dataId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['message'] = this.message;
    data['read_status'] = this.readStatus;
    data['date'] = this.date;
    return data;
  }
}