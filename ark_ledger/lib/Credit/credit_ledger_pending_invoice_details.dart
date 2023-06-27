import 'dart:async';
import 'dart:convert';

import 'package:ark_ledger/Models/InvoiceItemModeldart.dart';
import 'package:ark_ledger/Models/PendingInvoiceModel.dart';
import 'package:ark_ledger/Widgets/button.dart';
import 'package:ark_ledger/Widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../API/Api-End Point.dart';
import '../Widgets/bottomNavigation.dart';
import '../Widgets/input-field.dart';
import '../drawer.dart';

class pending_invoice_details extends StatefulWidget {
  final PendingInvoiceModel? pendingInvoiceModel;
  final String? month;
  final int? year;

  const pending_invoice_details({Key? key, this.pendingInvoiceModel,this.month,this.year})
      : super(key: key);

  @override
  State<pending_invoice_details> createState() =>
      _pending_invoice_detailsState();
}

class _pending_invoice_detailsState extends State<pending_invoice_details> {
  SharedPreferences? sharedPreferences;
  DateTime _selectedDate = DateTime.now();

  final StreamController<List<InvoiceItemModel>> _scInvoice =
      StreamController.broadcast();

  //TextEditingController
  final refController = TextEditingController();

  var _yearAppbar = "Year";
  var _monthAppbar = "Month";
  var _selectedPayment;
  var totalAmount = "0";

  bool refNoLayout = false;

  List<InvoiceItemModel>? modelInvoice;
  final paymentList = [
    "Cash",
    "Cheque",
    "Debit Cards",
    "Credit Cards",
    "Online Payment"
  ];

  //Get Pending Invoice item api data
  getItemListList() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "id": widget.pendingInvoiceModel!.id,
      "clientcompanyId": widget.pendingInvoiceModel!.clientCompanyId
    };

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_INVOICE_DETAIL),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));
    debugPrint("bodyParam Invoice: ${bodyParam.toString()}");
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      if (responseCode == "200") {
        var obj = responseBody['obj'];
        final List items = obj['invoiceItemsList'];
        setState(() {
          debugPrint('Invoice Data : $obj');
          modelInvoice =
              items.map((e) => InvoiceItemModel.fromJson((e))).toList();
          _scInvoice.add(modelInvoice!);
        });
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  //Update payment Status API
  updatePaymentStatus() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "id": widget.pendingInvoiceModel!.id,
      "amount": totalAmount,
      "paymentDate": DateFormat.yMd().format(_selectedDate),
      "paymentType": _selectedPayment.toString(),
      "paymentRefrenceId": refController.text.toString()
    };
    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.UPDATE_PAYMENT_STATUS),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    debugPrint("Payment Status bodyParam: ${bodyParam.toString()}");

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());

      if (responseCode == "200") {
        EasyLoading.dismiss();
        debugPrint("obj " + responseBody['obj']);
        Fluttertoast.showToast(
            msg: responseBody['obj'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      }else{
        EasyLoading.dismiss();
        debugPrint(response.body);
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemListList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      drawer: main_drawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(CupertinoIcons.list_bullet)),
        ),
        title: Text("PENDING INVOICE",
            style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Row(
              children: [
                Text(widget.year as String ?? _yearAppbar,
                    style: GoogleFonts.quicksand(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                VerticalDivider(
                    thickness: 1,
                    width: 10,
                    color: Colors.grey,
                    endIndent: 2.h,
                    indent: 2.h),
                Text(widget.month??_monthAppbar,
                    style: GoogleFonts.quicksand(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Column(
                children: [
                  //Company/Customer row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _text_w600("For Company", Colors.grey.shade600, 9.sp),
                          _text_w600(
                              widget.pendingInvoiceModel!.clientCompanyName ??
                                  "",
                              Colors.black,
                              11.sp),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _text_w600(
                              "For Customer", Colors.grey.shade600, 9.sp),
                          _text_w600(
                              widget.pendingInvoiceModel!.clientCustomerName ??
                                  "",
                              Colors.black,
                              11.sp),
                        ],
                      )
                    ],
                  ),

                  const Divider(color: Colors.grey, thickness: 1),

                  //Invoice No
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _textBold("Invoice No"),
                          _text_w600(widget.pendingInvoiceModel!.invoiceNo ?? "",
                              Colors.grey.shade600, 11.sp)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _textBold("Invoice Date"),
                          _text_w600(widget.pendingInvoiceModel!.date ?? "",
                              Colors.grey.shade600, 11.sp)
                        ],
                      )
                    ],
                  ),

                  const Divider(color: Colors.grey, thickness: 1),
                  Row(
                    children: [
                      _textForDetailList(47.w, "Item"),
                      _textForDetailList(10.w, "Qty"),
                      _textForDetailList(12.w, "Rate"),
                      _textForDetailList(12.w, "GST"),
                      _textForDetailList(15.w, "Amount")
                    ],
                  ),
                  const Divider(color: Colors.grey, thickness: 1),
                  _invoiceDetailsList(),
                  const Divider(color: Colors.grey, thickness: 1),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _textBold("Notes"),
                      Row(
                        children: [
                          _textBold("Total Amount: "),
                          _text_w600(
                              "₹ $totalAmount", Colors.grey.shade700, 11.sp)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),

            //Bottom row
            Positioned(bottom: 1.h, right: 0, left: 0, child: Column(
              children: [
                _bottomRow(),
                MyBottomNavigation(selectedIndex: 3),
              ],
            ))
          ],
        ),
      ),
    ));
  }

  _invoiceDetailsList() {
    return StreamBuilder(
        stream: _scInvoice.stream,
        builder: (context, AsyncSnapshot<List<InvoiceItemModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemCount: modelInvoice!.length,
                itemBuilder: (context, index) {
                  totalAmount = modelInvoice![index].total.toString();
                  return Row(
                    children: [
                      _textForDetailList(
                          47.w, modelInvoice![index].clientItem ?? ""),
                      _textForDetailList(
                          10.w, modelInvoice![index].qty.toString() ?? ""),
                      _textForDetailList(
                          12.w, modelInvoice![index].rate.toString() ?? ""),
                      _textForDetailList(
                          12.w, modelInvoice![index].igstValue.toString() ?? ""),
                      _textForDetailList(
                          15.w, modelInvoice![index].total.toString() ?? "")
                    ],
                  );
                });
          }
          return Center();
        });
  }

  //Bottom Row
  _bottomRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        children: [
          const Divider(color: Colors.black, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Payment Dropdown
              Expanded(
                child: Container(
                  height: 4.5.h,
                  padding: EdgeInsets.only(left: 1.h),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      style: TextStyle(color: Colors.black,fontSize: 10.sp),
                      borderRadius: BorderRadius.circular(20),
                      hint: Text("Payment Type", style: TextStyle(color: Colors.black)),
                      items: paymentList.map((itemone) {
                        return DropdownMenuItem(
                            value: itemone, child: Text(itemone,style: TextStyle(fontSize: 10.sp),));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPayment = value.toString();
                        });
                      },
                      value: _selectedPayment,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 0.5.h),

              //Date
              Expanded(
                  child: MyInputField(
                      readOnly: true,
                      height: 4.5.h,
                      hint: DateFormat.yMd().format(_selectedDate),
                      title: DateFormat.yMd().format(_selectedDate),
                      suffixIconWidget: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined,
                            color: Colors.grey),
                        onPressed: () async {
                          DateTime? pickerDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2123),
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                            primary: Colors.black)),
                                    child: child!);
                              });

                          if (pickerDate != null) {
                            setState(() {
                              _selectedDate = pickerDate;
                            });
                          }
                        },
                      ))),
              SizedBox(width: 0.2.h),

              //Button paid
              MyButton(
                  label: "PAID",
                  btnHeight: 5.h,
                  btnPadding:
                      EdgeInsets.symmetric(horizontal: 4.h, vertical: 0.h),
                  onTap: () => updatePaymentStatus()),
            ],
          ),
          _referenceNoLayout()
        ],
      ),
    );
  }

  //layout reference no
  _referenceNoLayout() {
    return Visibility(
      visible: (_selectedPayment == "Cash" || _selectedPayment == null)
          ? refNoLayout == true
          : refNoLayout == false,
      child: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("REFERENCE NO:  ",
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold, fontSize: 12.sp)),
              Expanded(
                child: MyInputField(
                    controller: refController,
                    height: 5.h,
                    hint: "Enter Reference No"),
              )
            ],
          )),
    );
  }

  //text weight w600
  _text_w600(String label, Color color, double size) {
    return Text(label,
        style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600, color: color, fontSize: size));
  }

  _textBold(String label) {
    return Text(label,
        style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold, color: Colors.black));
  }

  _textForDetailList(double width, String label) {
    return SizedBox(
        width: width,
        child: Text(label,
            style: TextStyle(color: Colors.black, fontSize: 10.sp)));
  }
}
