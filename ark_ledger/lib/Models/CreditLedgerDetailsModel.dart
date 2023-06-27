class CreditLedgerDetailsModel {
  CreditLedgerDetailsModel({
      this.id, 
      this.date, 
      this.clientItemId, 
      this.clientItem, 
      this.price, 
      this.qty, 
      this.paid,});

  CreditLedgerDetailsModel.fromJson(dynamic json) {
    id = json['id'];
    date = json['date'];
    clientItemId = json['clientItemId'];
    clientItem = json['clientItem'];
    price = json['price'];
    qty = json['qty'];
    paid = json['paid'];
  }
  int? id;
  String? date;
  int? clientItemId;
  String? clientItem;
  double? price;
  int? qty;
  bool? paid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['date'] = date;
    map['clientItemId'] = clientItemId;
    map['clientItem'] = clientItem;
    map['price'] = price;
    map['qty'] = qty;
    map['paid'] = paid;
    return map;
  }

}