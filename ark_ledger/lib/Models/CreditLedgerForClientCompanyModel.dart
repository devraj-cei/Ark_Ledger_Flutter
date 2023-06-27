class CreditLedgerForClientCompanyModel {
  CreditLedgerForClientCompanyModel({
      this.clientCompanyId, 
      this.clientCompany, 
      this.clientCustomerId, 
      this.customerId, 
      this.customer, 
      this.mobile, 
      this.email, 
      this.amount,});

  CreditLedgerForClientCompanyModel.fromJson(dynamic json) {
    clientCompanyId = json['clientCompanyId'];
    clientCompany = json['clientCompany'];
    clientCustomerId = json['clientCustomerId'];
    customerId = json['customerId'];
    customer = json['customer'];
    mobile = json['mobile'];
    email = json['email'];
    amount = json['amount'];
  }
  int? clientCompanyId;
  String? clientCompany;
  int? clientCustomerId;
  int? customerId;
  String? customer;
  String? mobile;
  String? email;
  double? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clientCompanyId'] = clientCompanyId;
    map['clientCompany'] = clientCompany;
    map['clientCustomerId'] = clientCustomerId;
    map['customerId'] = customerId;
    map['customer'] = customer;
    map['mobile'] = mobile;
    map['email'] = email;
    map['amount'] = amount;
    return map;
  }

}