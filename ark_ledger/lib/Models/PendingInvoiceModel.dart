class PendingInvoiceModel {
  PendingInvoiceModel({
      this.id, 
      this.creationTimestamp, 
      this.createdById, 
      this.clientCompanyId, 
      this.clientCompanyName, 
      this.invoiceNo, 
      this.date, 
      this.clientCustomerId, 
      this.clientCustomerName, 
      this.clientCustomerAddress, 
      this.clientCustomerState, 
      this.clientCustomerShippingAddress, 
      this.clientCustomerShippingState, 
      this.gstin, 
      this.year, 
      this.taxOrRetail, 
      this.note, 
      this.isPaid, 
      this.customerGst, 
      this.mobile, 
      this.currencyId,
  this.amount,});

  PendingInvoiceModel.fromJson(dynamic json) {
    id = json['id'];
    creationTimestamp = json['creationTimestamp'];
    createdById = json['createdById'];
    clientCompanyId = json['clientCompanyId'];
    clientCompanyName = json['clientCompanyName'];
    invoiceNo = json['invoiceNo'];
    date = json['date'];
    clientCustomerId = json['clientCustomerId'];
    clientCustomerName = json['clientCustomerName'];
    clientCustomerAddress = json['clientCustomerAddress'];
    clientCustomerState = json['clientCustomerState'];
    clientCustomerShippingAddress = json['clientCustomerShippingAddress'];
    clientCustomerShippingState = json['clientCustomerShippingState'];
    gstin = json['gstin'];
    year = json['year'];
    taxOrRetail = json['taxOrRetail'];
    note = json['note'];
    isPaid = json['isPaid'];
    customerGst = json['customerGst'];
    mobile = json['mobile'];
    currencyId = json['currencyId'];
    amount = json['amount'];
  }
  int? id;
  String? creationTimestamp;
  int? createdById;
  int? clientCompanyId;
  String? clientCompanyName;
  String? invoiceNo;
  String? date;
  int? clientCustomerId;
  String? clientCustomerName;
  String? clientCustomerAddress;
  String? clientCustomerState;
  String? clientCustomerShippingAddress;
  String? clientCustomerShippingState;
  String? gstin;
  int? year;
  bool? taxOrRetail;
  String? note;
  bool? isPaid;
  String? customerGst;
  String? mobile;
  int? currencyId;
  double? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creationTimestamp'] = creationTimestamp;
    map['createdById'] = createdById;
    map['clientCompanyId'] = clientCompanyId;
    map['clientCompanyName'] = clientCompanyName;
    map['invoiceNo'] = invoiceNo;
    map['date'] = date;
    map['clientCustomerId'] = clientCustomerId;
    map['clientCustomerName'] = clientCustomerName;
    map['clientCustomerAddress'] = clientCustomerAddress;
    map['clientCustomerState'] = clientCustomerState;
    map['clientCustomerShippingAddress'] = clientCustomerShippingAddress;
    map['clientCustomerShippingState'] = clientCustomerShippingState;
    map['gstin'] = gstin;
    map['year'] = year;
    map['taxOrRetail'] = taxOrRetail;
    map['note'] = note;
    map['isPaid'] = isPaid;
    map['customerGst'] = customerGst;
    map['mobile'] = mobile;
    map['currencyId'] = currencyId;
    map['amount'] = amount;
    return map;
  }

}