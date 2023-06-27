import 'dart:async';
import 'dart:convert';
import 'package:ark_ledger/Customer/customer%20add.dart';
import 'package:ark_ledger/Models/CustomerModel.dart';
import 'package:ark_ledger/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../API/Api-End Point.dart';
import '../Widgets/bottomNavigation.dart';
import '../Widgets/custom_appbar.dart';
import '../drawer.dart';

class customer extends StatefulWidget {
  const customer({Key? key}) : super(key: key);

  @override
  State<customer> createState() => _customerState();
}

class _customerState extends State<customer> {
  SharedPreferences? sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final StreamController<List<CustomerModel>> _streamController =
      StreamController.broadcast();
  final TextEditingController _searchController = TextEditingController();

  var appbarHeight = 9.h;
  var cardHeight = 9.h;
  int? _switchId;
  bool status = true;

  final List SearchCustomerList = [];
  List<CustomerModel>? model;

  //Search Customers
  onSearchTextChanged(String text) async {
    SearchCustomerList.clear();
    if (text.isEmpty) {
      setState(() {
        return;
      });
    }
    model!.forEach((element) {
      if (element.customer!.toLowerCase().contains(text)) {
        SearchCustomerList.add(element);
      }
    });
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => dashboard()), (route) => false);
    return false;
  }

  //Get customer API
  Get_Customer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');
    debugPrint(token);

    Map<String, dynamic> bodyParam = {};

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_CUSTOMER_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    debugPrint('BodyParam : $bodyParam');

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      if (responseCode == "200") {
        final List responseJSOn = responseBody['obj'];
        setState(() {
          debugPrint('Customer Data : $responseBody');
          model = responseJSOn.map((e) => CustomerModel.fromJson((e))).toList();
          _streamController.add(model!);
        });
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
        debugPrint(response.body);
      }
    } else {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: response.body,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      debugPrint(response.body);
    }
  }

  //Enable customer
  Enable_customer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"id": _switchId};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.ENABLE_CUSTOMER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Enable Offer : $responseBody');
      Fluttertoast.showToast(
          msg: "Customer Enable Successfully",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);

      if (responseCode == "200") {
        EasyLoading.dismiss();
        debugPrint(responseBody['obj']);
      }
    }
  }

  //Disable customer
  Disable_customer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"id": _switchId};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.DISABLE_CUSTOMER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Disable Offer : $responseBody');
      Fluttertoast.showToast(
          msg: "Customer Disable Successfully",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);

      if (responseCode == "200") {
        debugPrint(responseBody['obj']);
        EasyLoading.dismiss();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_Customer_API();
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
          color: Colors.grey.shade50,
          child: Stack(
            children: [
              //AppBar
              custom_appbar(
                  centerlabel: "CUSTOMERS",
                  drawerIconTap: () => _scaffoldKey.currentState!.openDrawer(),
                  widget: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => customer_add()));
                        },
                        child: Icon(CupertinoIcons.add_circled_solid,
                            color: Colors.white, size: 2.8.h),
                      ),
                    ],
                  )),

              //SearchBar
              Positioned(
                  top: appbarHeight / 1.4,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    alignment: Alignment.center,
                    height: appbarHeight / 2,
                    margin: EdgeInsets.symmetric(horizontal: 4.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: CupertinoSearchTextField(
                      controller: _searchController,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
                      onChanged: onSearchTextChanged,
                    ),
                  )),

              //Customer ListView
              _customerList(),

              //Bottom Navigation
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: MyBottomNavigation(selectedIndex: 1)),
            ],
          ),
        ),
      )),
    );
  }

  //Customer List
  Widget _customerList() {
    var imageSize = 4.h;
    return Container(
        margin: EdgeInsets.only(
            top: appbarHeight + 4.h, left: 2.w, right: 2.w, bottom: 9.h),
        child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, AsyncSnapshot<List<CustomerModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
                  itemCount: SearchCustomerList.isNotEmpty &&
                          _searchController.text.isNotEmpty
                      ? SearchCustomerList.length
                      : model!.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Card(
                          margin: EdgeInsets.only(left: imageSize - 1.h),
                          elevation: 1,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: imageSize + 2.h,
                                right: 1.h,
                                top: 1.h,
                                bottom: 1.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Customer name
                                Row(
                                  children: [
                                    Text(
                                        SearchCustomerList.isNotEmpty &&
                                                _searchController
                                                    .text.isNotEmpty
                                            ? SearchCustomerList[index]
                                                .customer
                                                .toUpperCase()
                                            : model![index]
                                                .customer!
                                                .toUpperCase(),
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: Colors.black)),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                //Customer mail,number
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(TextSpan(
                                            style: GoogleFonts.lato(
                                                color: Colors.grey.shade700),
                                            children: [
                                              WidgetSpan(
                                                  child: Container(
                                                padding:
                                                    EdgeInsets.only(right: 1.h),
                                                child: Icon(
                                                    CupertinoIcons.mail_solid,
                                                    size: 1.8.h,
                                                    color:
                                                        Colors.grey.shade600),
                                              )),
                                              TextSpan(
                                                  text: SearchCustomerList
                                                              .isNotEmpty &&
                                                          _searchController
                                                              .text.isNotEmpty
                                                      ? SearchCustomerList[
                                                              index]
                                                          .email
                                                      : model![index].email),
                                            ])),
                                        SizedBox(height: 1.h),
                                        Text.rich(TextSpan(
                                            style: GoogleFonts.lato(
                                                color: Colors.grey.shade700),
                                            children: [
                                              WidgetSpan(
                                                  child: Container(
                                                padding:
                                                    EdgeInsets.only(right: 1.h),
                                                child: Icon(
                                                    CupertinoIcons.phone_fill,
                                                    size: 1.8.h,
                                                    color:
                                                        Colors.grey.shade600),
                                              )),
                                              TextSpan(
                                                  text: SearchCustomerList
                                                              .isNotEmpty &&
                                                          _searchController
                                                              .text.isNotEmpty
                                                      ? SearchCustomerList[
                                                              index]
                                                          .mobile
                                                      : model![index].mobile,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 10.sp)),
                                            ])),
                                      ],
                                    ),
                                    //Edit,Switch
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            customer_add(
                                                              flag:
                                                                  "customer_update",
                                                              customerModel:
                                                                  model![index],
                                                            )));
                                              },
                                              child: Icon(
                                                  CupertinoIcons
                                                      .pencil_circle_fill,
                                                  color: Colors.black,
                                                  size: 3.h),
                                            ),
                                            SizedBox(width: 0.5.h),
                                            FlutterSwitch(
                                                width: 3.7.h,
                                                height: 2.h,
                                                toggleSize: 2.h,
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                inactiveColor: Colors.grey,
                                                toggleColor: Colors.black,
                                                value: SearchCustomerList
                                                            .isNotEmpty &&
                                                        _searchController
                                                            .text.isNotEmpty
                                                    ? SearchCustomerList[index]
                                                        .status
                                                    : model![index].status,
                                                padding: 0,
                                                onToggle: (val) {
                                                  model![index].status = val;
                                                  if (model![index].status ==
                                                      false) {
                                                    setState(() {
                                                      _switchId =
                                                          model![index].id;
                                                      Disable_customer_API();
                                                    });
                                                  } else if (model![index]
                                                          .status ==
                                                      true) {
                                                    setState(() {
                                                      _switchId =
                                                          model![index].id;
                                                      Enable_customer_API();
                                                    });
                                                  }
                                                }),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: CircleAvatar(
                            radius: imageSize,
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            child: Text(
                              model![index].customer![0],
                              style: GoogleFonts.quicksand(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return Center();
            }));
  }
}
