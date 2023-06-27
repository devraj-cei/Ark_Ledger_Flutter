class CustomerModel {
  CustomerModel({
      this.id, 
      this.creationTimeStamp, 
      this.createdById, 
      this.appClientId, 
      this.customerId, 
      this.customer, 
      this.businessName, 
      this.mobile, 
      this.email, 
      this.address, 
      this.cityId, 
      this.city, 
      this.stateId, 
      this.state, 
      this.countryId, 
      this.country, 
      this.pincode, 
      this.panNo, 
      this.gstIn, 
      this.type, 
      this.website, 
      this.faxNo, 
      this.status, 
      this.personName,});

  CustomerModel.fromJson(dynamic json) {
    id = json['id'];
    creationTimeStamp = json['creationTimeStamp'];
    createdById = json['createdById'];
    appClientId = json['appClientId'];
    customerId = json['customerId'];
    customer = json['customer'];
    businessName = json['businessName'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    cityId = json['cityId'];
    city = json['city'];
    stateId = json['stateId'];
    state = json['state'];
    countryId = json['countryId'];
    country = json['country'];
    pincode = json['pincode'];
    panNo = json['panNo'];
    gstIn = json['gstIn'];
    type = json['type'];
    website = json['website'];
    faxNo = json['faxNo'];
    status = json['status'];
    personName = json['personName'];
  }
  int? id;
  String? creationTimeStamp;
  int? createdById;
  int? appClientId;
  int? customerId;
  String? customer;
  String? businessName;
  String? mobile;
  String? email;
  String? address;
  int? cityId;
  String? city;
  int? stateId;
  String? state;
  int? countryId;
  String? country;
  String? pincode;
  String? panNo;
  String? gstIn;
  int? type;
  String? website;
  String? faxNo;
  bool? status;
  String? personName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creationTimeStamp'] = creationTimeStamp;
    map['createdById'] = createdById;
    map['appClientId'] = appClientId;
    map['customerId'] = customerId;
    map['customer'] = customer;
    map['businessName'] = businessName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['address'] = address;
    map['cityId'] = cityId;
    map['city'] = city;
    map['stateId'] = stateId;
    map['state'] = state;
    map['countryId'] = countryId;
    map['country'] = country;
    map['pincode'] = pincode;
    map['panNo'] = panNo;
    map['gstIn'] = gstIn;
    map['type'] = type;
    map['website'] = website;
    map['faxNo'] = faxNo;
    map['status'] = status;
    map['personName'] = personName;
    return map;
  }

}