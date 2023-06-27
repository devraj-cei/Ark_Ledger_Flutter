class CompanyModel {
  CompanyModel({
      this.id, 
      this.creationTimestamp, 
      this.createdById, 
      this.appClientId, 
      this.appClient, 
      this.name, 
      this.description, 
      this.gstApplicable, 
      this.showQty, 
      this.showRate, 
      this.status, 
      this.logo, 
      this.website, 
      this.uid, 
      this.employeePrefix, 
      this.stateId, 
      this.state, 
      this.countryId, 
      this.country, 
      this.displayName, 
      this.displayNameColor, 
      this.bgColor, 
      this.fontColor, 
      this.hintColor, 
      this.fontBGColor, 
      this.btnFontColor, 
      this.btnBGStartColor, 
      this.btnBGEndColor, 
      this.btnBGStrokeColor, 
      this.businessCatgeoryId, 
      this.businessCategory, 
      this.businessSubCatgeoryId, 
      this.businessSubCategory, 
      this.currencyId, 
      this.currencySymbol, 
      this.allowCustomerToAddCredit, 
      this.allowSearch, 
      this.mobile, 
      this.address, 
      this.pincode,});

  CompanyModel.fromJson(dynamic json) {
    id = json['id'];
    creationTimestamp = json['creationTimestamp'];
    createdById = json['createdById'];
    appClientId = json['appClientId'];
    appClient = json['appClient'];
    name = json['name'];
    description = json['description'];
    gstApplicable = json['gstApplicable'];
    showQty = json['showQty'];
    showRate = json['showRate'];
    status = json['status'];
    logo = json['logo'];
    website = json['website'];
    uid = json['uid'];
    employeePrefix = json['employeePrefix'];
    stateId = json['stateId'];
    state = json['state'];
    countryId = json['countryId'];
    country = json['country'];
    displayName = json['displayName'];
    displayNameColor = json['displayNameColor'];
    bgColor = json['bgColor'];
    fontColor = json['fontColor'];
    hintColor = json['hintColor'];
    fontBGColor = json['fontBGColor'];
    btnFontColor = json['btnFontColor'];
    btnBGStartColor = json['btnBGStartColor'];
    btnBGEndColor = json['btnBGEndColor'];
    btnBGStrokeColor = json['btnBGStrokeColor'];
    businessCatgeoryId = json['businessCatgeoryId'];
    businessCategory = json['businessCategory'];
    businessSubCatgeoryId = json['businessSubCatgeoryId'];
    businessSubCategory = json['businessSubCategory'];
    currencyId = json['currencyId'];
    currencySymbol = json['currencySymbol'];
    allowCustomerToAddCredit = json['allowCustomerToAddCredit'];
    allowSearch = json['allowSearch'];
    mobile = json['mobile'];
    address = json['address'];
    pincode = json['pincode'];
  }
  int? id;
  String? creationTimestamp;
  int? createdById;
  int? appClientId;
  String? appClient;
  String? name;
  String? description;
  bool? gstApplicable;
  bool? showQty;
  bool? showRate;
  bool? status;
  String? logo;
  String? website;
  String? uid;
  String? employeePrefix;
  int? stateId;
  String? state;
  int? countryId;
  String? country;
  String? displayName;
  String? displayNameColor;
  String? bgColor;
  String? fontColor;
  String? hintColor;
  String? fontBGColor;
  String? btnFontColor;
  String? btnBGStartColor;
  String? btnBGEndColor;
  String? btnBGStrokeColor;
  int?  businessCatgeoryId;
  String? businessCategory;
  int? businessSubCatgeoryId;
  String? businessSubCategory;
  int? currencyId;
  String? currencySymbol;
  bool? allowCustomerToAddCredit;
  bool? allowSearch;
  String? mobile;
  String? address;
  String? pincode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creationTimestamp'] = creationTimestamp;
    map['createdById'] = createdById;
    map['appClientId'] = appClientId;
    map['appClient'] = appClient;
    map['name'] = name;
    map['description'] = description;
    map['gstApplicable'] = gstApplicable;
    map['showQty'] = showQty;
    map['showRate'] = showRate;
    map['status'] = status;
    map['logo'] = logo;
    map['website'] = website;
    map['uid'] = uid;
    map['employeePrefix'] = employeePrefix;
    map['stateId'] = stateId;
    map['state'] = state;
    map['countryId'] = countryId;
    map['country'] = country;
    map['displayName'] = displayName;
    map['displayNameColor'] = displayNameColor;
    map['bgColor'] = bgColor;
    map['fontColor'] = fontColor;
    map['hintColor'] = hintColor;
    map['fontBGColor'] = fontBGColor;
    map['btnFontColor'] = btnFontColor;
    map['btnBGStartColor'] = btnBGStartColor;
    map['btnBGEndColor'] = btnBGEndColor;
    map['btnBGStrokeColor'] = btnBGStrokeColor;
    map['businessCatgeoryId'] = businessCatgeoryId;
    map['businessCategory'] = businessCategory;
    map['businessSubCatgeoryId'] = businessSubCatgeoryId;
    map['businessSubCategory'] = businessSubCategory;
    map['currencyId'] = currencyId;
    map['currencySymbol'] = currencySymbol;
    map['allowCustomerToAddCredit'] = allowCustomerToAddCredit;
    map['allowSearch'] = allowSearch;
    map['mobile'] = mobile;
    map['address'] = address;
    map['pincode'] = pincode;
    return map;
  }

}