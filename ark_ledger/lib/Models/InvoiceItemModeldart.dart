class InvoiceItemModel {
  InvoiceItemModel({
      this.id, 
      this.creationTimestamp, 
      this.invoiceId, 
      this.description, 
      this.hsnCode, 
      this.rate, 
      this.qty, 
      this.amount, 
      this.sgst, 
      this.sgstValue, 
      this.cgst, 
      this.cgstValue, 
      this.igst, 
      this.igstValue, 
      this.total, 
      this.clientItemId, 
      this.clientItem,});

  InvoiceItemModel.fromJson(dynamic json) {
    id = json['id'];
    creationTimestamp = json['creationTimestamp'];
    invoiceId = json['invoiceId'];
    description = json['description'];
    hsnCode = json['hsnCode'];
    rate = json['rate'];
    qty = json['qty'];
    amount = json['amount'];
    sgst = json['sgst'];
    sgstValue = json['sgstValue'];
    cgst = json['cgst'];
    cgstValue = json['cgstValue'];
    igst = json['igst'];
    igstValue = json['igstValue'];
    total = json['total'];
    clientItemId = json['clientItemId'];
    clientItem = json['clientItem'];
  }
  int? id;
  String? creationTimestamp;
  int? invoiceId;
  String? description;
  String? hsnCode;
  double? rate;
  int? qty;
  double? amount;
  double? sgst;
  double? sgstValue;
  double? cgst;
  double? cgstValue;
  double? igst;
  double? igstValue;
  double? total;
  int? clientItemId;
  String? clientItem;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['creationTimestamp'] = creationTimestamp;
    map['invoiceId'] = invoiceId;
    map['description'] = description;
    map['hsnCode'] = hsnCode;
    map['rate'] = rate;
    map['qty'] = qty;
    map['amount'] = amount;
    map['sgst'] = sgst;
    map['sgstValue'] = sgstValue;
    map['cgst'] = cgst;
    map['cgstValue'] = cgstValue;
    map['igst'] = igst;
    map['igstValue'] = igstValue;
    map['total'] = total;
    map['clientItemId'] = clientItemId;
    map['clientItem'] = clientItem;
    return map;
  }

}