class ContactModel {
  List<ContactItems>? items;
  bool? hasMore;
  int? limit;
  int? offset;
  int? count;
  List<Links>? links;

  ContactModel(
      {this.items,
      this.hasMore,
      this.limit,
      this.offset,
      this.count,
      this.links});

  ContactModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ContactItems>[];
      json['items'].forEach((v) {
        items!.add(new ContactItems.fromJson(v));
      });
    }
    hasMore = json['hasMore'];
    limit = json['limit'];
    offset = json['offset'];
    count = json['count'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['hasMore'] = this.hasMore;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['count'] = this.count;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContactItems {
  String? leadId;
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNum;
  String? workPhone;
  String? company;
  String? updateDate;
  String? createDate;
  String? contactOwner;

  ContactItems(
      {this.leadId,
      this.fullName,
      this.firstName,
      this.lastName,
      this.email,
      this.mobileNum,
      this.workPhone,
      this.company,
      this.updateDate,
      this.createDate,
      this.contactOwner});

  ContactItems.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    fullName = json['full_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobileNum = json['mobile_num'];
    workPhone = json['work_phone'];
    company = json['company'];
    updateDate = json['update_date'];
    createDate = json['create_date'];
    contactOwner = json['lead_owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_id'] = this.leadId;
    data['full_name'] = this.fullName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['mobile_num'] = this.mobileNum;
    data['work_phone'] = this.workPhone;
    data['company'] = this.company;
    data['update_date'] = this.updateDate;
    data['create_date'] = this.createDate;
    data['lead_owner'] = this.contactOwner;
    return data;
  }
}

class Links {
  String? rel;
  String? href;

  Links({this.rel, this.href});

  Links.fromJson(Map<String, dynamic> json) {
    rel = json['rel'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rel'] = this.rel;
    data['href'] = this.href;
    return data;
  }
}
