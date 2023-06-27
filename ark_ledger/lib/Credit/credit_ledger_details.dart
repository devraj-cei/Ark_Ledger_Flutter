import 'dart:async';
import 'dart:convert';
import 'package:ark_ledger/Loader.dart';
import 'package:ark_ledger/Models/CreditLedgerForClientModel.dart';
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
import '../Models/CompanyModel.dart';
import '../Models/CreditLedgerDetailsModel.dart';
import '../Models/CreditLedgerForClientCompanyModel.dart';
import '../Widgets/bottomNavigation.dart';
import '../Widgets/button.dart';
import '../Widgets/custom_appbar.dart';
import '../Widgets/dropdown.dart';
import '../drawer.dart';

class credit_ledger_details extends StatefulWidget {
  final String? flag;
  final String? month;
  final int? year;
  final CreditLedgerForClientCompanyModel? companyModel;
  final CreditLedgerForClientModel? clientModel;

  const credit_ledger_details(
      {Key? key,
      this.flag,
      this.month,
      this.year,
      this.companyModel,
      this.clientModel})
      : super(key: key);

  @override
  State<credit_ledger_details> createState() => _credit_ledger_detailsState();
}

class _credit_ledger_detailsState extends State<credit_ledger_details> {
  SharedPreferences? sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final StreamController<List<CreditLedgerDetailsModel>> _streamController =
      StreamController.broadcast();

  var appbarHeight = 9.h;
  var _monthAppbar = "Month";
  var _yearAppbar = "Year";
  var _selectedMonth, company_change_flag, customer_change_flag;
  dynamic _selectedCompany, companyName;

  int? _selectedYear;

  List<CreditLedgerDetailsModel>? model;
  List<dynamic> companyList = [];
  final _monthList = [
    "All",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<int> yearsTilPresent = [];

  List<int> getYears(year) {
    int currentYear = DateTime.now().year;
    while (year <= currentYear) {
      yearsTilPresent.add(year);
      year++;
    }
    return yearsTilPresent;
  }

  //Parse Date
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('MM/dd/yyyy hh:mm:ss a');
    final DateFormat serverFormater = DateFormat('dd/MM/yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  getData() {
    if (widget.flag == "credit_company_flag") {
      setState(() {
        _selectedYear = widget.year;
        _selectedMonth = widget.month;
        company_change_flag = widget.flag;
      });
    } else if (widget.flag == "credit_customer_flag") {
      setState(() {
        _selectedYear = widget.year;
        _selectedMonth = widget.month;
        customer_change_flag = widget.flag;
        print(widget.month);
      });
    }
  }

  getCompanyList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_CLIENT_COMPANY_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Company data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          getLedgerDetails();
          List responseObj = responseBody['obj'];
          setState(() {
            companyList.clear();
            companyList = List<CompanyModel>.from(
                responseObj.map((e) => CompanyModel.fromJson(e)));
          });
        });
      }
    }
  }

  //Get Credit Ledger Details
  getLedgerDetails() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "clientCustomerId": widget.companyModel!.clientCustomerId,
      "year": _selectedYear,
      "month": _selectedMonth
    };

    if (company_change_flag == "credit_company_flag" ||
        widget.flag == "credit_customer_flag") {
      bodyParam.addAll({
        "clientCompanyId": widget.companyModel!.clientCompanyId,
      });
    } else if (company_change_flag == "company_change_flag") {
      bodyParam.addAll({"clientCompanyId": _selectedCompany.id});
    }

    var response = await post(
        Uri.parse(
            API_EndPoint.BASE_URL + API_EndPoint.GET_CREDIT_LEDGER_DETAILS),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));
    debugPrint("bodyParam Company details: ${bodyParam.toString()}");
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      if (responseCode == "200") {
        final List responseJSOn = responseBody['obj'];
        setState(() {
          debugPrint('client company Data : $responseBody');
          model = responseJSOn
              .map((e) => CreditLedgerDetailsModel.fromJson((e)))
              .toList();
          _streamController.add(model!);
        });
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  //Generate Invoice
  generateInvoice() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "month": _selectedMonth,
      "year": _selectedYear.toString(),
      "clientCustomerId": widget.clientModel!.clientCustomerId
    };

    if (_selectedCompany.id != null) {
      print("if${_selectedCompany.id}");
      bodyParam.addAll({
        "clientCompanyId": _selectedCompany.id,
      });
    } else {
      bodyParam.addAll({});
    }
    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.CREATE_INVOICE),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    debugPrint("generate invoice bodyParam: $bodyParam");

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());

      if (responseCode == "200") {
        debugPrint("obj " + responseBody['obj']);
        Fluttertoast.showToast(
            msg: responseBody['obj'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      } else {
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
    method_loading();
    getYears(1999);
    getData();
    getCompanyList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      drawer: main_drawer(),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            custom_appbar(
                label: "CUSTOMER LEDGER",
                drawerIconTap: () => _scaffoldKey.currentState!.openDrawer(),
                widget: Row(
                  children: [
                    Text(_selectedYear.toString() ?? _yearAppbar.toString(),
                        style: GoogleFonts.quicksand(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    VerticalDivider(
                        thickness: 1,
                        width: 10,
                        color: Colors.grey,
                        endIndent: 2.h,
                        indent: 2.h),
                    Text(_selectedMonth ?? _monthAppbar,
                        style: GoogleFonts.quicksand(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 0.5.h),
                    InkWell(
                        onTap: () {
                          _bottomSheet();
                        },
                        child:
                            const Icon(Icons.menu_sharp, color: Colors.white))
                  ],
                )),

            //Company DropDown
            Positioned(
                top: appbarHeight / 1.4,
                left: 0.0,
                right: 0.0,
                child: Container(
                  height: appbarHeight / 1.8,
                  margin: EdgeInsets.symmetric(horizontal: 4.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                        hint: Text("Select Company", style: TextStyle(color: Colors.black)),
                        items: companyList.map((user) {
                          return DropdownMenuItem<CompanyModel>(
                            value: user ?? 0,
                            child: Text("${user.name}"),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCompany = newValue;
                            getLedgerDetails();
                            company_change_flag = "company_change_flag";
                          });
                        },
                        value: _selectedCompany,
                      ),
                    ),
                  ),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.h),
              margin: EdgeInsets.only(top: appbarHeight + 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Company name
                  Text(
                      "For Customer: ${widget.flag == "credit_company_flag" ? widget.companyModel!.clientCompany : widget.clientModel!.customer}",
                      style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                  const Divider(color: Colors.black, thickness: 1),

                  Row(
                    children: [
                      _texrForCustomerList(25.w, "Date", TextAlign.left),
                      _texrForCustomerList(35.w, "Item", TextAlign.left),
                      _texrForCustomerList(15.w, "Qty", TextAlign.center),
                      _texrForCustomerList(20.w, "Amount", TextAlign.right)
                    ],
                  ),
                  const Divider(color: Colors.black, thickness: 1),
                  _invoiceList()
                ],
              ),
            ),
            //Bottom row
            Positioned(
              bottom: 1.h,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  const Divider(color: Colors.black, thickness: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount: 280.00",
                            style: TextStyle(
                                color: Colors.black, fontSize: 12.sp)),
                        MyButton(
                          label: "GENERATE INVOICE",
                          btnHeight: 4.8.h,
                          btnPadding: EdgeInsets.symmetric(horizontal: 2.h),
                          fontSize: 10.sp,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                        "Do you want to generate an invoice for '${widget.clientModel!.customer}' under "
                                        "'${widget.companyModel!.clientCompany}' Company?",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black)),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp))),
                                      TextButton(
                                          onPressed: () {
                                            generateInvoice();
                                            Navigator.pop(context);
                                          },
                                          child: Text("Confirm",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp))),
                                    ],
                                  );
                                });
                          },
                        )
                      ],
                    ),
                  ),
                  //Bottom Navigation
                  MyBottomNavigation(selectedIndex: 3),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  _invoiceList() {
    return StreamBuilder(
        stream: _streamController.stream,
        builder:
            (context, AsyncSnapshot<List<CreditLedgerDetailsModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemCount: model!.length,
                itemBuilder: (context, index) {
                  String date = model![index].date!;
                  return Row(
                    children: [
                      _texrForCustomerList(
                          25.w, convertDateTimeDisplay(date), TextAlign.left),
                      _texrForCustomerList(
                          35.w, model![index].clientItem ?? "", TextAlign.left),
                      _texrForCustomerList(15.w,
                          model![index].qty.toString() ?? "", TextAlign.center),
                      _texrForCustomerList(20.w,
                          "₹ ${model![index].price}" ?? "", TextAlign.right)
                    ],
                  );
                });
          }
          return const Center();
        });
  }

  _bottomSheet() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text("Ledger Filter",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                        fontSize: 14.sp, color: Colors.black)),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                      CupertinoIcons.clear_circled_solid))
                            ],
                          ),
                          SizedBox(height: 1.h),
                          _text("Year"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: Colors.white,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                                hint: Text("Select Year", style: TextStyle(color: Colors.black)),
                                items: yearsTilPresent.map((item) {
                                  return DropdownMenuItem(
                                      value: item,
                                      child: Text(item.toString(),
                                          style: const TextStyle(
                                              color: Colors.black)));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedYear = newValue;
                                  });
                                },
                                value: _selectedYear!,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          _text("Month"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: const Text("Select Month"),
                                value: _selectedMonth,
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMonth = value.toString();
                                  });
                                },
                                items: _monthList.map((itemone) {
                                  return DropdownMenuItem(
                                      value: itemone, child: Text(itemone));
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          MyButton(
                              label: "APPLY",
                              onTap: () {
                                setState(() {
                                  _monthAppbar = _selectedMonth;
                                  _yearAppbar = _selectedYear.toString();
                                  // getLedgerForClient();
                                  Navigator.pop(context);
                                });
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }));
        });
  }

  _text(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Text(
        title,
        style: GoogleFonts.quicksand(
            color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  _texrForCustomerList(double width, String label, TextAlign textAlign) {
    return SizedBox(
        width: width,
        child: Text(label,
            style: TextStyle(color: Colors.black, fontSize: 10.sp),
            textAlign: textAlign ?? TextAlign.left));
  }
}
