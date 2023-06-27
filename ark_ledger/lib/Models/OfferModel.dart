class OfferModel {
  OfferModel({
      this.id, 
      this.creationTimestamp, 
      this.createdById, 
      this.appClientId, 
      this.appClient, 
      this.title, 
      this.note, 
      this.tnc, 
      this.discount, 
      this.discountType, 
      this.maxDiscountValue, 
      this.startDate, 
      this.endDate, 
      this.status, 
      this.minOrderValue, 
      this.imageFile,});

  OfferModel.fromJson(dynamic json) {
    id = json['id'];
    creationTimestamp = json['creationTimestamp'];
    createdById = json['createdById'];
    appClientId = json['appClientId'];
    appClient = json['appClient'];
    title = json['title'];
    note = json['note'];
    tnc = json['tnc'];
    discount = json['discount'];
    discountType = json['discountType'];
    maxDiscountValue = json['maxDiscountValue'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'];
    minOrderValue = json['minOrderValue'];
    imageFile = json['imageFile'];
  }
  int? id;
  String? creationTimestamp;
  int? createdById;
  int? appClientId;
  String? appClient;
  String? title;
  String? note;
  String? tnc;
  double? discount;
  int? discountType;
  double? maxDiscountValue;
  String? startDate;
  String? endDate;
  bool? status;
  double? minOrderValue;
  String? imageFile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creationTimestamp'] = creationTimestamp;
    map['createdById'] = createdById;
    map['appClientId'] = appClientId;
    map['appClient'] = appClient;
    map['title'] = title;
    map['note'] = note;
    map['tnc'] = tnc;
    map['discount'] = discount;
    map['discountType'] = discountType;
    map['maxDiscountValue'] = maxDiscountValue;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['status'] = status;
    map['minOrderValue'] = minOrderValue;
    map['imageFile'] = imageFile;
    return map;
  }

}