class CreditLedgerForClientModel {
  CreditLedgerForClientModel({
      this.clientCustomerId, 
      this.customerId, 
      this.customer, 
      this.mobile, 
      this.email, 
      this.amount,});

  CreditLedgerForClientModel.fromJson(dynamic json) {
    clientCustomerId = json['clientCustomerId'];
    customerId = json['customerId'];
    customer = json['customer'];
    mobile = json['mobile'];
    email = json['email'];
    amount = json['amount'];
  }
  int? clientCustomerId;
  int? customerId;
  String? customer;
  String? mobile;
  String? email;
  double? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clientCustomerId'] = clientCustomerId;
    map['customerId'] = customerId;
    map['customer'] = customer;
    map['mobile'] = mobile;
    map['email'] = email;
    map['amount'] = amount;
    return map;
  }

}