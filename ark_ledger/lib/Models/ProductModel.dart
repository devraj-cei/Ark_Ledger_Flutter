class ProductModel {
  ProductModel({
      this.id, 
      this.creationTimeStamp, 
      this.createdById, 
      this.uid, 
      this.clientId, 
      this.client, 
      this.name, 
      this.description, 
      this.image, 
      this.price, 
      this.hsnsacId, 
      this.hsnsac, 
      this.status, 
      this.discount, 
      this.productCategoryId, 
      this.productCategory, 
      this.productSubcategoryId, 
      this.productSubcategory, 
      this.currencyId, 
      this.currency, 
      this.clientCompanyId, 
      this.clientCompany, 
      this.allowSearch,});

  ProductModel.fromJson(dynamic json) {
    id = json['id'];
    creationTimeStamp = json['creationTimeStamp'];
    createdById = json['createdById'];
    uid = json['uid'];
    clientId = json['clientId'];
    client = json['client'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    hsnsacId = json['hsnsacId'];
    hsnsac = json['hsnsac'];
    status = json['status'];
    discount = json['discount'];
    productCategoryId = json['productCategoryId'];
    productCategory = json['productCategory'];
    productSubcategoryId = json['productSubcategoryId'];
    productSubcategory = json['productSubcategory'];
    currencyId = json['currencyId'];
    currency = json['currency'];
    clientCompanyId = json['clientCompanyId'];
    clientCompany = json['clientCompany'];
    allowSearch = json['allowSearch'];
  }
  int? id;
  String? creationTimeStamp;
  int? createdById;
  String? uid;
  int? clientId;
  String? client;
  String? name;
  String? description;
  String? image;
  double? price;
  int? hsnsacId;
  String? hsnsac;
  bool? status;
  double? discount;
  int? productCategoryId;
  String? productCategory;
  int? productSubcategoryId;
  String? productSubcategory;
  int? currencyId;
  String? currency;
  int? clientCompanyId;
  String? clientCompany;
  bool? allowSearch;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creationTimeStamp'] = creationTimeStamp;
    map['createdById'] = createdById;
    map['uid'] = uid;
    map['clientId'] = clientId;
    map['client'] = client;
    map['name'] = name;
    map['description'] = description;
    map['image'] = image;
    map['price'] = price;
    map['hsnsacId'] = hsnsacId;
    map['hsnsac'] = hsnsac;
    map['status'] = status;
    map['discount'] = discount;
    map['productCategoryId'] = productCategoryId;
    map['productCategory'] = productCategory;
    map['productSubcategoryId'] = productSubcategoryId;
    map['productSubcategory'] = productSubcategory;
    map['currencyId'] = currencyId;
    map['currency'] = currency;
    map['clientCompanyId'] = clientCompanyId;
    map['clientCompany'] = clientCompany;
    map['allowSearch'] = allowSearch;
    return map;
  }

}