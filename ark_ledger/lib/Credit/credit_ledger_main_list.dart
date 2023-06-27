import 'dart:async';
import 'dart:convert';
import 'package:ark_ledger/Credit/add%20credit.dart';
import 'package:ark_ledger/Credit/credit_ledger_details.dart';
import 'package:ark_ledger/Credit/credit_ledger_pending_invoice_details.dart';
import 'package:ark_ledger/Models/CreditLedgerForClientCompanyModel.dart';
import 'package:ark_ledger/Models/PendingInvoiceModel.dart';
import 'package:ark_ledger/Widgets/custom_appbar.dart';
import 'package:ark_ledger/Widgets/dropdown.dart';
import 'package:ark_ledger/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../API/Api-End Point.dart';
import '../Models/CreditLedgerForClientModel.dart';
import '../Widgets/bottomNavigation.dart';
import '../Widgets/button.dart';
import '../dashboard.dart';

class credit_ledger_main_list extends StatefulWidget {
  const credit_ledger_main_list({Key? key}) : super(key: key);

  @override
  State<credit_ledger_main_list> createState() =>
      _credit_ledger_main_listState();
}

class _credit_ledger_main_listState extends State<credit_ledger_main_list> {
  SharedPreferences? sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final StreamController<List<CreditLedgerForClientModel>> _scClient =
      StreamController.broadcast();
  final StreamController<List<CreditLedgerForClientCompanyModel>> _scCompany =
      StreamController.broadcast();
  final StreamController<List<PendingInvoiceModel>> _scInvoice =
      StreamController.broadcast();

  var radioButtonValue = "ledger";
  var appbarHeight = 9.h;
  var _monthAppbar = "Month";
  var _yearAppbar = "Year";
  var _selectedMonth;

  int? _selectedYear;

  bool switchStatus = false;

  List<CreditLedgerForClientModel>? modelClient;
  List<CreditLedgerForClientCompanyModel>? modelCompany;
  List<PendingInvoiceModel>? modelInvoice;
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

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => dashboard()),
        (route) => false);
    return false;
  }

  //Get Client wise api data
  getLedgerForClient() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "year": _selectedYear,
      "month": _selectedMonth
    };

    var response = await post(
        Uri.parse(
            API_EndPoint.BASE_URL + API_EndPoint.GET_CREDIT_LEDGER_FOR_CLIENT),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    debugPrint("bodyParam Client: $bodyParam");

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      if (responseCode == "200") {
        final List responseJSOn = responseBody['obj'];
        setState(() {
          debugPrint('client Data : $responseBody');
          modelClient = responseJSOn
              .map((e) => CreditLedgerForClientModel.fromJson((e)))
              .toList();
          _scClient.add(modelClient!);
        });
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  //Get Client company wise api data
  getLedgerForCompany() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "year": _selectedYear,
      "month": _selectedMonth
    };

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL +
            API_EndPoint.GET_CREDIT_LEDGER_FOR_CLIENT_COMPANIES),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));
    debugPrint("bodyParam Company: $bodyParam");
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      if (responseCode == "200") {
        final List responseJSOn = responseBody['obj'];
        setState(() {
          debugPrint('client company Data : $responseBody');
          modelCompany = responseJSOn
              .map((e) => CreditLedgerForClientCompanyModel.fromJson((e)))
              .toList();
          _scCompany.add(modelCompany!);
        });
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  //Get Pending Invoice api data
  getPendingInvoiceList() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');
    var obj = sharedPreferences!.getString('obj');
    var getProfileObj = jsonDecode(obj!);
    int clientId = getProfileObj['appClientId'];

    Map<String, dynamic> bodyParam = {
      "appClientId": clientId,
      "isPaid": 0,
      "year": _selectedYear,
      "month": _selectedMonth
    };

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_INVOICE_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));
    debugPrint("bodyParam Invoice: ${bodyParam.toString()}");
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      if (responseCode == "200") {
        final List responseJSOn = responseBody['obj'];
        setState(() {
          debugPrint('Invoice Data : $responseBody');
          modelInvoice = responseJSOn
              .map((e) => PendingInvoiceModel.fromJson((e)))
              .toList();
          _scInvoice.add(modelInvoice!);
        });
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  //Send Payment Reminder
  paymentReminder() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {};

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.SEND_PAYMENT_REMINDER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());
      if (responseCode == "200") {
        _dialogPaymentReminder();
        debugPrint("obj " + responseBody['obj']);
        Fluttertoast.showToast(
            msg: "Payment reminder send successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
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
    getYears(2010);
    getLedgerForClient();
    getLedgerForCompany();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
        key: _scaffoldKey,
        drawer: main_drawer(),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          height: double.infinity,
          child: Stack(
            children: [
              custom_appbar(
                label: "CREDIT LEDGER",
                drawerIconTap: () => _scaffoldKey.currentState!.openDrawer(),
                widget: Row(
                  children: [
                    Text(_yearAppbar,
                        style: GoogleFonts.quicksand(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    VerticalDivider(
                        thickness: 1,
                        width: 10,
                        color: Colors.grey,
                        endIndent: 2.h,
                        indent: 2.h),
                    Text(_monthAppbar,
                        style: GoogleFonts.quicksand(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 0.5.h),
                    InkWell(
                        onTap: () {
                          _bottomSheet();
                        },
                        child: Icon(Icons.menu,color: Colors.white))
                  ],
                ),
              ),
              Positioned(
                  top: appbarHeight / 1.4,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: appbarHeight / 1.8,
                    margin: EdgeInsets.symmetric(horizontal: 4.h),
                    padding: EdgeInsets.symmetric(
                        vertical: 0.7.h, horizontal: 0.7.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomRadioButton("LEDGER", "ledger"),
                        CustomRadioButton("PENDING INVOICE", "invoice"),
                      ],
                    ),
                  )),

              radioButtonValue == "ledger"
                  ?
                  //Company wise row
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      margin: EdgeInsets.only(top: appbarHeight + 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("VIEW COMPANY WISE",
                                  style: GoogleFonts.quicksand(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp)),
                              Switch(
                                activeColor: Theme.of(context).primaryColor,
                                value: switchStatus,
                                onChanged: (value) {
                                  setState(() {
                                    switchStatus = value;
                                    if (switchStatus == false) {
                                      getLedgerForClient();
                                    } else {
                                      getLedgerForCompany();
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                          TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    return Colors.black;
                                  }),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(horizontal: 1.h))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const add_credit()));
                              },
                              icon: Icon(CupertinoIcons.add,
                                  color: Colors.white, size: 2.h),
                              label: Text(
                                "Add Credit",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp),
                              ))
                        ],
                      ))
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      margin: EdgeInsets.only(top: appbarHeight + 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextButton.icon(
                                onPressed: () {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Payment Reminder send successfully");
                                },
                                icon: InkWell(
                                  onTap: () => paymentReminder(),
                                  child: Icon(
                                      Icons.notifications_active_outlined,
                                      color: Colors.black,
                                      size: 2.5.h),
                                ),
                                label: Text("SEND PAYMENT REMINDER",
                                    style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold))),
                          )
                        ],
                      ),
                    ),

              //body
              radioButtonValue == "ledger"
                  ? _creditLedgerList()
                  : _pendingInvoiceList(),

              //Bottom Navigation
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: MyBottomNavigation(selectedIndex: 3)),
            ],
          ),
        ),
      )),
    );
  }

  //Appbar Radio button
  Widget CustomRadioButton(String text, String index) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (radioButtonValue == index)
                ? Theme.of(context).primaryColor
                : Colors.white,
            border: Border.all(color: Colors.transparent)),
        child: OutlinedButton(
          style: ButtonStyle(
              backgroundColor: (radioButtonValue == index)
                  ? MaterialStateProperty.resolveWith<Color>((states) {
                      return Theme.of(context).primaryColor;
                    })
                  : MaterialStateProperty.resolveWith((states) {
                      return Colors.white;
                    }),
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                return Colors.transparent;
              }),
              side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.transparent))),
          onPressed: () {
            setState(() {
              radioButtonValue = index;
              if (radioButtonValue == "ledger") {
                getLedgerForClient();
              } else {
                print("radio button value:$radioButtonValue");
                getPendingInvoiceList();
              }
            });
          },
          child: Text(
            text,
            style: GoogleFonts.quicksand(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10.5.sp),
          ),
        ),
      ),
    );
  }

  //Credit ledger list
  Widget _creditLedgerList() {
    final double topBgHeight = 2.h;
    final double profilePicHeight = 6.h;
    final top = topBgHeight - profilePicHeight / 3;

    return Container(
        margin: EdgeInsets.only(
            top: appbarHeight + 8.h, left: 1.h, right: 1.h, bottom: 9.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              switchStatus == true
                  ? StreamBuilder(
                      stream: _scCompany.stream,
                      builder: (context,
                          AsyncSnapshot<List<CreditLedgerForClientCompanyModel>>
                              snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 1.h),
                            itemCount: modelCompany!.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  _customerList(topBgHeight, 3.h, index),
                                  Positioned(
                                      top: top,
                                      child: Container(
                                        width: 35.h,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.h),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.shade300),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              modelCompany![index]
                                                  .clientCompany
                                                  !.toUpperCase(),
                                              style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              );
                            },
                          );
                        } else {
                          const Text("No Credit ");
                        }
                        return const Center();
                      })
                  : StreamBuilder(
                      stream: _scClient.stream,
                      builder: (context,
                          AsyncSnapshot<List<CreditLedgerForClientModel>>
                              snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 1.h),
                            itemCount: modelClient!.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  _customerList(0, 1.2.h, index),
                                ],
                              );
                            },
                          );
                        }
                        return const Center();
                      })
            ],
          ),
        ));
  }

  //Customer list company/customer wise
  Widget _customerList(double topBgHeight, double paddingVertical, int index) {
    return Container(
      margin: EdgeInsets.only(top: topBgHeight),
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: 1.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 1.5.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          switchStatus == true
                              ? modelCompany![index].clientCompany!.toUpperCase()
                              : modelClient![index].customer!.toUpperCase(),
                          style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text(
                          switchStatus == true
                              ? modelCompany![index].mobile!
                              : modelClient![index].mobile!,
                          style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp)),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pending Amount",
                          style: GoogleFonts.quicksand(
                              color: Colors.grey, fontSize: 9.sp)),
                      Text(
                          switchStatus == true
                              ? "₹ ${modelCompany![index].amount.toString()}"
                              : "₹ ${modelClient![index].amount.toString()}",
                          style:
                              TextStyle(color: Colors.green, fontSize: 10.sp)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (switchStatus == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => credit_ledger_details(
                              flag: "credit_company_flag",
                              year: _selectedYear,
                              month: _selectedMonth,
                              companyModel: modelCompany![index],
                              clientModel: modelClient![index],
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => credit_ledger_details(
                              flag: "credit_customer_flag",
                              year: _selectedYear,
                              month: _selectedMonth,
                              clientModel: modelClient![index],
                              companyModel: modelCompany![index],
                            )));
              }
            },
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey.shade200,
              child: Icon(CupertinoIcons.forward, color: Colors.grey.shade700),
            ),
          )
        ],
      ),
    );
  }

  //Pending invoice list
  Widget _pendingInvoiceList() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.h),
        margin: EdgeInsets.only(top: appbarHeight + 8.h, bottom: 9.h),
        child: StreamBuilder(
            stream: _scInvoice.stream,
            builder:
                (context, AsyncSnapshot<List<PendingInvoiceModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemCount: modelInvoice!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => pending_invoice_details(
                                        pendingInvoiceModel:
                                            modelInvoice![index],
                                        year: _selectedYear!,
                                        month: _selectedMonth,
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.5.h, horizontal: 1.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade400)),
                          child: Column(
                            children: [
                              //Name
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      modelInvoice![index]
                                          .clientCustomerName
                                          !.toUpperCase(),
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      modelInvoice![index]
                                          .clientCompanyName
                                          !.toUpperCase(),
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Divider(color: Colors.grey),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Invoice No",
                                            style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontSize: 10.sp)),
                                        SizedBox(height: 0.5.h),
                                        Text(modelInvoice![index].invoiceNo!,
                                            style: GoogleFonts.lato(
                                                fontSize: 9.sp,
                                                color: Colors.grey.shade700)),
                                      ],
                                    ),
                                    const VerticalDivider(color: Colors.grey),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Amount",
                                            style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontSize: 10.sp)),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                            "${modelInvoice![index].amount ?? "0.0"}",
                                            style: GoogleFonts.lato(
                                                fontSize: 9.sp,
                                                color: Colors.grey.shade600)),
                                      ],
                                    ),
                                    const VerticalDivider(color: Colors.grey),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            modelInvoice![index].date.toString(),
                                            style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontSize: 10.sp)),
                                        SizedBox(height: 0.5.h),
                                        Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.h,
                                                vertical: 0.5.h),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: modelInvoice![index].isPaid ==
                                                    true
                                                ? Text(
                                                    "Paid",
                                                    style: GoogleFonts.lato(
                                                        color: Colors.green,
                                                        fontSize: 9.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    "UnPaid",
                                                    style: GoogleFonts.lato(
                                                        color: Colors.red,
                                                        fontSize: 9.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
              return Center();
            }));
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
                                    _selectedYear = newValue as int;
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
                                  getLedgerForClient();
                                  getLedgerForCompany();
                                  getPendingInvoiceList();
                                  Navigator.pop(context);
                                  _monthAppbar = _selectedMonth;
                                  _yearAppbar = _selectedYear.toString();
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

  _dialogPaymentReminder() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            icon: Image.asset("assets/Images/ledger_logo.png",
                width: 10.w, height: 8.h),
            title: Text("Payment Reminder Send Successfully.",
                style: GoogleFonts.quicksand(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            actions: [
              Center(
                  child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
              ))
            ],
          );
        });
  }
}
