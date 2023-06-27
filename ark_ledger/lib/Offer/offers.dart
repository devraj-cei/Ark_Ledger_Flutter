import 'dart:async';
import 'dart:convert';

import 'package:ark_ledger/Models/OfferModel.dart';
import 'package:ark_ledger/Offer/offers%20add.dart';
import 'package:ark_ledger/Offer/offers%20details.dart';
import 'package:ark_ledger/Widgets/alert_dialog.dart';
import 'package:ark_ledger/Widgets/bottomNavigation.dart';
import 'package:ark_ledger/Widgets/custom_appbar.dart';
import 'package:ark_ledger/Widgets/dropdown.dart';
import 'package:ark_ledger/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../API/Api-End Point.dart';
import '../Widgets/button.dart';
import '../Widgets/input-field.dart';
import '../dashboard.dart';

class offer extends StatefulWidget {
  const offer({Key? key}) : super(key: key);

  @override
  State<offer> createState() => _offerState();
}

class _offerState extends State<offer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final StreamController<List<OfferModel>> _streamController =
      StreamController();

  SharedPreferences? sharedPreferences;

  final TextEditingController _searchController = TextEditingController();

  var flag;
  var appbarHeight = 9.h;
  var cardHeight = 9.h;
  int _selectedCategory = 0;
  int _selectedSubCategory = 0;
  int? _switchId;
  int? id;
  bool status = true;

  List<OfferModel>? model;
  final List<OfferModel> _searchOfferList = [];
  List<dynamic> categoryList = [];
  List<dynamic> subCategoryList = [];

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => dashboard()), (route) => false);
    return false;
  }

  //Search Customers
  onSearchTextChanged(String text) async {
    _searchOfferList.clear();
    if (text.isEmpty) {
      setState(() {
        return;
      });
    }
    model!.forEach((element) {
      if (element.title!.toLowerCase().contains(text) ||
          element.title!.toLowerCase().contains(text)) {
        _searchOfferList.add(element);
      }
    });
    setState(() {});
  }

  //Get offer API
  Get_Offer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {};
    if (flag == "filter") {
      bodyParam.addAll({
        "productCategoryId": _selectedCategory,
        "productSubCategoryId": _selectedSubCategory
      });
    } else {
      bodyParam.addAll({});
    }

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_OFFER_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    debugPrint('BodyParam : ${bodyParam.toString()}');

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      if (responseCode == "200") {
        final List responseJSOn = responseBody['obj'];
        setState(() {
          debugPrint('Offer Data : $responseBody');
          model = responseJSOn.map((e) => OfferModel.fromJson((e))).toList();
          _streamController.add(model!);
        });
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

  //Get Product Category
  Get_Category_API() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");
    Map<String, dynamic> bodyParam = {};
    final response = await post(
        Uri.parse(
            API_EndPoint.BASE_URL + API_EndPoint.GET_PRODUCT_CATEGORY_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Category data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            for (Map data in responseObj) {
              subCategoryList.clear();
              categoryList.add(data);
              var company = categoryList[0]['id'];
              setState(() {
                _selectedCategory = company;
              });
            }
          });
        });
      }
    }
  }

  //Get Product Category
  Get_SubCategory_API() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"productCategoryId": _selectedCategory};

    final response = await post(
        Uri.parse(
            API_EndPoint.BASE_URL + API_EndPoint.GET_SUB_PRODUCT_CATEGORY_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    debugPrint(" sub category bodyParam : $bodyParam");

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Sub Category data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            for (Map data in responseObj) {
              subCategoryList.add(data);
              var company = subCategoryList[0]['id'];
              setState(() {
                _selectedSubCategory = company;
              });
            }
          });
        });
      }
    }
  }

  //Enable offer
  Enable_offer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"id": _switchId};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.ENABLE_OFFER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Enable Offer : $responseBody');
      Fluttertoast.showToast(
          msg: "Offer Disable Successfully",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);

      if (responseCode == "200") {
        EasyLoading.dismiss();
        debugPrint(responseBody['obj']);
      }
    }
  }

  //Disable offer
  Disable_offer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"id": _switchId};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.DISABLE_OFFER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Disable Offer : $responseBody');
      Fluttertoast.showToast(
          msg: "Offer Disable Successfully",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);

      if (responseCode == "200") {
        debugPrint(responseBody['obj']);
        EasyLoading.dismiss();
      }
    }
  }

  //Delete Offer
  Delete_offer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"id": id};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.DELETE_OFFER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    debugPrint('Delete Offer bodyParam : $bodyParam');

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Delete Offer : $responseBody');
      Fluttertoast.showToast(
          msg: "Offer Deleted Successfully",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);

      if (responseCode == "200") {
        debugPrint(responseBody['obj']);
        EasyLoading.dismiss();
        Get_Offer_API();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_Offer_API();
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
          child: Stack(
            children: [
              //AppBar
              custom_appbar(
                  centerlabel: "MY OFFER",
                  drawerIconTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  widget: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        offers_add(flag: "add_offer_flag")));
                          },
                          child: Icon(CupertinoIcons.add_circled_solid,
                              color: Colors.white, size: 2.8.h)),
                      SizedBox(width: 1.h),
                      InkWell(
                          onTap: () {
                            _bottomSheet();
                            categoryList.clear();
                            subCategoryList.clear();
                            Get_Category_API();
                          },
                          child: Icon(Icons.menu_sharp,
                              color: Colors.white, size: 2.8.h)),
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

              //Offer ListView
              _offerList(),

              //Bottom Navigation
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: MyBottomNavigation(selectedIndex: 3))
            ],
          ),
        ),
      )),
    );
  }

  //Offer List
  Widget _offerList() {
    var imageHeight = 21.h;
    var cardHeight = imageHeight / 1.2;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.h),
        margin: EdgeInsets.only(top: appbarHeight + 3.h, bottom: 9.h),
        child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, AsyncSnapshot<List<OfferModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemCount: _searchOfferList.isNotEmpty &&
                          _searchController.text.isNotEmpty
                      ? _searchOfferList.length
                      : model!.length,
                  itemBuilder: (context, index) {
                    var discount;
                    if (model![index].discountType == 1) {
                      discount = "${model![index].discount}% off";
                    } else {
                      discount = "Flat  ₹${model![index].discount} off ";
                    }

                    //Parse Date
                    DateFormat format = DateFormat("MM/dd/yyyy");
                    var newDate = format.parse(model![index].endDate!);
                    format = DateFormat("dd MMM yyyy");
                    var date = format.format(newDate);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                            top: 1.h,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => offer_details(
                                              offerModel: model![index],
                                            )));
                              },
                              child: Container(
                                height: imageHeight,
                                width: 43.h,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(_searchOfferList
                                                    .isNotEmpty &&
                                                _searchController
                                                    .text.isNotEmpty
                                            ? "http://arkledger.techregnum.com/assets/Offers/${_searchOfferList[index].imageFile}"
                                            : "http://arkledger.techregnum.com/assets/Offers/${model![index].imageFile}"),
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.transparent)),
                              ),
                            )),
                        Card(
                          margin: EdgeInsets.only(
                              top: cardHeight, left: 3.h, right: 3.h),
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        _searchOfferList.isNotEmpty &&
                                                _searchController
                                                    .text.isNotEmpty
                                            ? _searchOfferList[index].title!
                                            : model![index].title!,
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.sp,
                                            color: Colors.black)),
                                    SizedBox(height: 0.5.h),
                                    RichText(
                                        text: TextSpan(
                                            style: GoogleFonts.quicksand(
                                                fontSize: 10.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            children: [
                                          const TextSpan(
                                              text: "Valid till :- "),
                                          TextSpan(
                                              text: date,
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 9.sp,
                                                  color: Colors.grey.shade600)),
                                        ])),
                                    SizedBox(height: 0.5.h),
                                    Text(discount,
                                        style: GoogleFonts.quicksand(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ],
                                ),
                                FlutterSwitch(
                                    width: 3.5.h,
                                    height: 1.7.h,
                                    toggleSize: 2.h,
                                    activeColor: Theme.of(context).primaryColor,
                                    inactiveColor: Colors.grey,
                                    toggleColor: Colors.black,
                                    value: _searchOfferList.isNotEmpty &&
                                            _searchController.text.isNotEmpty
                                        ? _searchOfferList[index].status!
                                        : model![index].status!,
                                    padding: 0,
                                    onToggle: (val) {
                                      setState(() {
                                        model![index].status = val;
                                        if (model![index].status == false) {
                                          setState(() {
                                            _switchId = model![index].id;
                                            Disable_offer_API();
                                          });
                                        } else if (model![index].status ==
                                            true) {
                                          setState(() {
                                            _switchId = model![index].id;
                                            Enable_offer_API();
                                          });
                                        }
                                      });
                                    })
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            right: 2.h,
                            top: 2.h,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return myAlertDialog(
                                          content:
                                              "Are you sure you want to Delete Offer?",
                                          okLabel: "OK",
                                          cancelLabel: "CANCEL",
                                          okTap: () {
                                            setState(() {
                                              id = model![index].id;
                                              Delete_offer_API();
                                              Navigator.pop(context);
                                            });
                                          },
                                        );
                                      });
                                });
                              },
                              child: CircleAvatar(
                                radius: 1.5.h,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.close,
                                    color: Colors.black, size: 1.7.h),
                              ),
                            ))
                      ],
                    );
                  },
                );
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
                padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.h),
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
                                child: Text("Offer Filter",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
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

                          //Category dropdown
                          _text("Category"),
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
                                hint: Text("Select Category", style: TextStyle(color: Colors.black)),
                                items: categoryList.map((item) {
                                  return DropdownMenuItem(
                                      value: item['id'],
                                      child: Text(item['title'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black)));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCategory = newValue as int;
                                    subCategoryList.clear();
                                    Get_SubCategory_API();
                                  });
                                },
                                value: _selectedCategory,
                              ),
                            ),
                          ),

                          //Sub category dropdown
                          _text("SubCategory"),
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
                                hint: Text("Select Sub Category", style: TextStyle(color: Colors.black)),
                                items: subCategoryList.map((item) {
                                  return DropdownMenuItem(
                                      value: item['id'],
                                      child: Text(item['title'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black)));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedSubCategory = newValue as int;
                                  });
                                },
                                value: _selectedSubCategory,
                              ),
                            ),
                          ),

                          SizedBox(height: 2.h),
                          MyButton(
                              label: "ADD",
                              onTap: () {
                                flag = "filter";
                                Get_Offer_API();
                                Navigator.pop(context);
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

  Widget _text(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
      child: Text(label,
          style: GoogleFonts.lato(color: Colors.black, fontSize: 11.sp)),
    );
  }
}
