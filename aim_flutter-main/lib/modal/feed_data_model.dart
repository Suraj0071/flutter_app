class FeedData {
  List<Items>? items;
  bool? hasMore;
  int? limit;
  int? offset;
  int? count;
  List<Links>? links;

  FeedData(
      {this.items,
      this.hasMore,
      this.limit,
      this.offset,
      this.count,
      this.links});

  FeedData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
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

class Items {
  String? id;
  String? contactName;
  String? activityStatus;
  String? description;
  String? dateAdded;
  String? mobile;
  String? email;
  String? via;
  String? hasSeenStory;

  Items(
      {this.id,
      this.contactName,
      this.activityStatus,
      this.description,
      this.dateAdded,
      this.mobile,
      this.email,
      this.via,
      this.hasSeenStory});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactName = json['contact_name'];
    activityStatus = json['activity_status'];
    description = json['description'];
    dateAdded = json['date_added'];
    mobile = json['mobile'];
    email = json['email'];
    via = json['via'];
    hasSeenStory = json['has_seen_story'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contact_name'] = this.contactName;
    data['activity_status'] = this.activityStatus;
    data['description'] = this.description;
    data['date_added'] = this.dateAdded;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['via'] = this.via;
    data['has_seen_story'] = this.hasSeenStory;
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
