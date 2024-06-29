class LocalStorageModel {
  String? uid;
  bool? isClient;
  bool? isFirstVisit;

  LocalStorageModel({this.uid, this.isClient, this.isFirstVisit});

  LocalStorageModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    isClient = json['isClient'];
    isFirstVisit = json['isFirstVisit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['isClient'] = this.isClient;
    data['isFirstVisit'] = this.isFirstVisit;
    return data;
  }
}
