class FeedDetailData {
  Information? information;
  List<Activity>? activity;
  List<BuyersJourney>? buyersJourney;

  FeedDetailData({this.information, this.activity, this.buyersJourney});

  FeedDetailData.fromJson(Map<String, dynamic> json) {
    information = json['information'] != null
        ? new Information.fromJson(json['information'])
        : null;
    if (json['activity'] != null) {
      activity = <Activity>[];
      json['activity'].forEach((v) {
        activity!.add(new Activity.fromJson(v));
      });
    }
    if (json['buyers_journey'] != null) {
      buyersJourney = <BuyersJourney>[];
      json['buyers_journey'].forEach((v) {
        buyersJourney!.add(new BuyersJourney.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.information != null) {
      data['information'] = this.information!.toJson();
    }
    if (this.activity != null) {
      data['activity'] = this.activity!.map((v) => v.toJson()).toList();
    }
    if (this.buyersJourney != null) {
      data['buyers_journey'] =
          this.buyersJourney!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Information {
  String? id;
  String? firstName;
  String? lastName;
  String? company;
  String? email;
  String? mobileNo;
  String? address;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? leadSource;
  String? createdAt;
  String? leadOwner;
  String? leadOwnerId;
  String? gstNumber;
  String? annualTurnover;
  String? countryCode;
  String? website;
  String? workPhone;
  String? createUpdate;
  String? lastActivity;

  Information(
      {this.id,
      this.firstName,
      this.lastName,
      this.company,
      this.email,
      this.mobileNo,
      this.address,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.leadSource,
      this.createdAt,
      this.leadOwner,
      this.leadOwnerId,
      this.gstNumber,
      this.annualTurnover,
      this.countryCode,
      this.website,
      this.workPhone,
      this.createUpdate,
      this.lastActivity});

  Information.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postal_code'];
    country = json['country'];
    leadSource = json['lead_source'];
    createdAt = json['created_at'];
    leadOwner = json['lead_owner'];
    leadOwnerId = json['lead_owner_id'];
    gstNumber = json['gst_number'];
    annualTurnover = json['annual_turnover'];
    countryCode = json['country_code'];
    website = json['website'];
    workPhone = json['work_phone'];
    createUpdate = json['create_update'];
    lastActivity = json['last_activity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['company'] = this.company;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postal_code'] = this.postalCode;
    data['country'] = this.country;
    data['lead_source'] = this.leadSource;
    data['created_at'] = this.createdAt;
    data['lead_owner'] = this.leadOwner;
    data['lead_owner_id'] = this.leadOwnerId;
    data['gst_number'] = this.gstNumber;
    data['annual_turnover'] = this.annualTurnover;
    data['country_code'] = this.countryCode;
    data['website'] = this.website;
    data['work_phone'] = this.workPhone;
    data['create_update'] = this.createUpdate;
    data['last_activity'] = this.lastActivity;
    return data;
  }
}

class Activity {
  String? createdDate;
  String? icon;
  String? desc;
  String? source;
  String? sourceDB;

  Activity(
      {this.createdDate, this.icon, this.desc, this.source, this.sourceDB});

  Activity.fromJson(Map<String, dynamic> json) {
    createdDate = json['created_date'];
    icon = json['icon'];
    desc = json['desc'];
    sourceDB = json['source_db'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_date'] = this.createdDate;
    data['icon'] = this.icon;
    data['desc'] = this.desc;
    data['source'] = this.source;
    data['source_db'] = this.sourceDB;
    return data;
  }
}

class BuyersJourney {
  String? eventId;
  String? eventUniqueId;
  String? eventLeadId;
  String? eventType;
  String? eventTime;
  String? eventCode;
  int? isSelected;
  String? description;

  BuyersJourney(
      {this.eventId,
      this.eventUniqueId,
      this.eventLeadId,
      this.eventType,
      this.eventTime,
      this.eventCode,
      this.isSelected,
      this.description});

  BuyersJourney.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventUniqueId = json['event_unique_id'];
    eventLeadId = json['event_lead_id'];
    eventType = json['event_type'];
    eventTime = json['event_time'];
    eventCode = json['event_code'];
    isSelected = json['is_selected'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_unique_id'] = this.eventUniqueId;
    data['event_lead_id'] = this.eventLeadId;
    data['event_type'] = this.eventType;
    data['event_time'] = this.eventTime;
    data['event_code'] = this.eventCode;
    data['is_selected'] = this.isSelected;
    data['description'] = this.description;
    return data;
  }
}
