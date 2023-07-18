class CallLogData {
  List<CallLogDataItem>? items;
  bool? hasMore;
  int? limit;
  int? offset;
  int? count;
  List<Links>? links;

  CallLogData(
      {this.items,
      this.hasMore,
      this.limit,
      this.offset,
      this.count,
      this.links});

  CallLogData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <CallLogDataItem>[];
      json['items'].forEach((v) {
        items!.add(new CallLogDataItem.fromJson(v));
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

class CallLogDataItem {
  String? id;
  String? cntName;
  String? cntNumber;
  String? cntStatus;
  String? time;
  String? duration;

  CallLogDataItem(
      {this.id,
      this.cntName,
      this.cntNumber,
      this.cntStatus,
      this.time,
      this.duration});

  CallLogDataItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cntName = json['cnt_name'];
    cntNumber = json['cnt_number'];
    cntStatus = json['cnt_status'];
    time = json['time'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cnt_name'] = this.cntName;
    data['cnt_number'] = this.cntNumber;
    data['cnt_status'] = this.cntStatus;
    data['time'] = this.time;
    data['duration'] = this.duration;
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
