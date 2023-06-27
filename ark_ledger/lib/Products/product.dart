import 'dart:async';
import 'dart:convert';

import 'package:ark_ledger/Models/ProductModel.dart';
import 'package:ark_ledger/Products/product%20add.dart';
import 'package:ark_ledger/Products/product%20update.dart';
import 'package:ark_ledger/Widgets/alert_dialog.dart';
import 'package:ark_ledger/Widgets/dropdown.dart';
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
import '../dashboard.dart';
import '../drawer.dart';

class product extends StatefulWidget {
  const product({Key? key}) : super(key: key);

  @override
  State<product> createState() => _productState();
}

class _productState extends State<product> {
  SharedPreferences? sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final TextEditingController _searchController = TextEditingController();

  final StreamController<List<ProductModel>> _streamController =
      StreamController.broadcast();

  int? _productId;

  bool status = false;
  var appbarHeight = 9.h;
  var searchBarTopMargin;

  final List SearchProductList = [];

  List<ProductModel>? model;

  //Search products
  onSearchTextChanged(String text) async {
    SearchProductList.clear();
    if (text.isEmpty) {
      setState(() {
        return;
      });
    }
    model!.forEach((element) {
      if (element.name!.toLowerCase().contains(text)) {
        SearchProductList.add(element);
      }
    });
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => dashboard()), (route) => false);
    return false;
  }

  //Get product API
  Get_Product_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');
    debugPrint(token);

    Map<String, dynamic> bodyParam = {};

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_PRODUCT_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      if (responseCode == "200") {
        final List responseJSOn = responseBody['obj'];
        setState(() {
          debugPrint('product Data : $responseBody');
          model = responseJSOn.map((e) => ProductModel.fromJson((e))).toList();
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

  //Enable Product
  Enable_product_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"id": _productId};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.ENABLE_PRODUCT),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Enable Product : $responseBody');
      Fluttertoast.showToast(
          msg: "Product Enable Successfully",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);

      if (responseCode == "200") {
        EasyLoading.dismiss();
        debugPrint(responseBody['obj']);
      }
    }
  }

  //Disable Product
  Disable_product_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"id": _productId};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.DISABLE_PRODUCT),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Disable Product : $responseBody');
      Fluttertoast.showToast(
          msg: "Product Disable Successfully",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);

      if (responseCode == "200") {
        debugPrint(responseBody['obj']);
        EasyLoading.dismiss();
      }
    }
  }

  //Delete Product
  Delete_Product_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {"id": _productId};

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.DELETE_PRODUCT),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    debugPrint("product bodyParam: $bodyParam");

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());

      if (responseCode == "200") {
        debugPrint("obj " + responseBody['obj']);
        Fluttertoast.showToast(
            msg: "Product Deleted Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        Get_Product_API();
        EasyLoading.dismiss();
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
    Get_Product_API();
  }

  @override
  Widget build(BuildContext context) {
    searchBarTopMargin = appbarHeight + 3.h;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: main_drawer(),
            backgroundColor: Colors.white,
            body: Container(
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  //AppBar
                  custom_appbar(
                      centerlabel: "PRODUCTS / SERVICES",
                      drawerIconTap: () =>
                          _scaffoldKey.currentState!.openDrawer(),
                      widget: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => product_add()));
                            },
                            child: Icon(CupertinoIcons.add_circled_solid,
                                color: Colors.white, size: 2.8.h),
                          ),
                        ],
                      )),

                  //DropDown
                  Positioned(
                      top: appbarHeight / 1.4,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                          alignment: Alignment.center,
                          height: appbarHeight / 2,
                          margin: EdgeInsets.symmetric(horizontal: 4.h),
                          padding: EdgeInsets.symmetric(horizontal: 2.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Widget>(
                              isExpanded: true,
                              hint: Text("Select Product"),
                              items: [],
                              onChanged: (Object? value) {},
                            ),
                          ))),

                  //Searchbar
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      margin: EdgeInsets.only(top: searchBarTopMargin),
                      child: CupertinoSearchTextField(
                        controller: _searchController,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey)),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 1.h),
                        onChanged: onSearchTextChanged,
                      )),
                  _productList(),

                  //Bottom Navigation
                  Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: MyBottomNavigation(selectedIndex: 1))
                ],
              ),
            ),
          ),
        ));
  }

  Widget _productList() {
    var listTopMargin = searchBarTopMargin + 5.h;
    return Container(
      padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 1.h, bottom: 9.h),
      margin: EdgeInsets.only(top: listTopMargin),
      child: StreamBuilder(
          stream: _streamController.stream,
          builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
                itemCount: SearchProductList.isNotEmpty &&
                        _searchController.text.isNotEmpty
                    ? SearchProductList.length
                    : model!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(left: 0),
                    elevation: 1,
                    color: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                color: Colors.white,
                                height: 12.h,
                                width: 12.h,
                                child: Image.network(
                                    "http://arkledger.techregnum.com/assets/Products/${model![index].image}",
                                    fit: BoxFit.fill),
                              )),
                          SizedBox(width: 1.h),
                          //Details
                          Expanded(
                            child: Container(
                              height: 12.h,
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _text(SearchProductList.isNotEmpty &&
                                              _searchController.text.isNotEmpty
                                          ? SearchProductList[index].name
                                          : model![index].name),
                                      _subTitle(SearchProductList.isNotEmpty &&
                                              _searchController.text.isNotEmpty
                                          ? SearchProductList[index]
                                              .productCategory
                                          : model![index].productCategory),
                                      _subTitle(SearchProductList.isNotEmpty &&
                                              _searchController.text.isNotEmpty
                                          ? SearchProductList[index]
                                              .productSubcategory
                                          : model![index].productSubcategory),
                                    ],
                                  ),
                                  //SizedBox(height: 1.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _text(SearchProductList.isNotEmpty &&
                                              _searchController.text.isNotEmpty
                                          ? SearchProductList[index].currency +
                                              SearchProductList[index]
                                                  .price
                                                  .toString()
                                          : model![index].currency! +
                                              model![index].price.toString()),
                                      //Edit/delete/switch
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            product_update(
                                                                flag:
                                                                    "product_update",
                                                                productModel:
                                                                    model![
                                                                        index])));
                                              },
                                              child: Icon(
                                                  CupertinoIcons
                                                      .pencil_circle_fill,
                                                  color: Colors.black,
                                                  size: 3.1.h)),
                                          SizedBox(width: 0.5.h),

                                          //Delete
                                          InkWell(
                                            onTap: () {
                                              _productId = model![index].id;
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return myAlertDialog(
                                                      content:
                                                          "Are you sure you want to delete product?",
                                                      okLabel: "OK",
                                                      cancelLabel: "CANCEL",
                                                      okTap: () {
                                                        setState(() {
                                                          Delete_Product_API();
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                    );
                                                  });
                                            },
                                            child: CircleAvatar(
                                                radius: 1.4.h,
                                                backgroundColor: Colors.red,
                                                child: Icon(Icons.delete,
                                                    size: 1.8.h,
                                                    color: Colors.white)),
                                          ),
                                          SizedBox(width: 0.7.h),
                                          FlutterSwitch(
                                              width: 4.h,
                                              height: 1.8.h,
                                              toggleSize: 2.h,
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              inactiveColor:
                                                  Colors.grey.shade400,
                                              toggleColor: Colors.black,
                                              value: model![index].status!,
                                              padding: 0,
                                              onToggle: (val) {
                                                setState(() {
                                                  model![index].status = val;
                                                  if (model![index].status ==
                                                      false) {
                                                    setState(() {
                                                      _productId =
                                                          model![index].id;
                                                      Disable_product_API();
                                                    });
                                                  } else if (model![index]
                                                          .status ==
                                                      true) {
                                                    setState(() {
                                                      _productId =
                                                          model![index].id;
                                                      Enable_product_API();
                                                    });
                                                  }
                                                });
                                              }),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center();
          }),
    );
  }

  Widget _text(String label) {
    return Text(label,
        style: GoogleFonts.quicksand(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11.sp));
  }

  Widget _subTitle(String label) {
    return Padding(
      padding: EdgeInsets.only(top: 0.3.h),
      child: Text(label,
          style: GoogleFonts.quicksand(
              color: Colors.grey.shade700, fontSize: 10.sp)),
    );
  }
}
