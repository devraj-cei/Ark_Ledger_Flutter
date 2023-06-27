import 'dart:convert';
import 'package:ark_ledger/Credit/confirm%20credit.dart';
import 'package:ark_ledger/Customer/customer.dart';
import 'package:ark_ledger/Models/ClientItemModel.dart';
import 'package:ark_ledger/Models/CustomerModel.dart';
import 'package:ark_ledger/Widgets/alert_dialog.dart';
import 'package:ark_ledger/Widgets/appbar.dart';
import 'package:ark_ledger/Widgets/button.dart';
import 'package:ark_ledger/Widgets/dropdown.dart';
import 'package:ark_ledger/Widgets/input-field.dart';
import 'package:ark_ledger/drawer.dart';
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
import '../Widgets/bottomNavigation.dart';
import '../dashboard.dart';

class add_credit extends StatefulWidget {
  const add_credit({Key? key}) : super(key: key);

  @override
  State<add_credit> createState() => _add_creditState();
}

class _add_creditState extends State<add_credit> {
  SharedPreferences? sharedPreferences;
  DateTime _selectedDate = DateTime.now();

  //TextEditingController
  final qtyController = TextEditingController();
  final dateController = TextEditingController();

  var _selectedCompany, _selectedClient, _selectedClientItem, data;

  List<dynamic> companyList = [];
  List<dynamic> clientList = [];
  List<dynamic> clientItemList = [];
  List<dynamic> addItemList = [];

  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => dashboard()), (route) => false);
    return false;
  }

  //Add data to static listview
  void addDataToListView() {
    setState(() {
      data = {
        "id": addItemList.length + 1,
        "clientItemId": _selectedClientItem.id,
        "item": _selectedClientItem.name.toString(),
        "qty": qtyController.text.toString(),
        "price": _selectedClientItem.price.toString(),
        "currency": _selectedClientItem.currency,
        "image": _selectedClientItem.image
      };
      addItemList.add(data);
    });
    debugPrint("$addItemList");
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

  getClientList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_CUSTOMER_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('client data : ${responseBody.toString()}');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            clientList.clear();
            clientList = List<CustomerModel>.from(
                responseObj.map((e) => CustomerModel.fromJson(e)));
          });
        });
      }
    }
  }

  getClientItemList() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");
    Map<String, dynamic> bodyParam = {};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_CLIENT_ITEM_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('item data : $responseBody');

      if (responseCode == '200') {
        List responseObj = responseBody['obj'];
        setState(() {
          clientItemList.clear();
          clientItemList = List<ClientItemModel>.from(
              responseObj.map((e) => ClientItemModel.fromJson(e)));
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanyList();
    getClientList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        drawer: main_drawer(),
        appBar: MyAppbar(
          label: "Add Credit",
          suffixLabel: "CONFIRM",
          suffixLabelTap: () {
            if (addItemList.isEmpty) {
              Fluttertoast.showToast(msg: "Please Add Items And Quantity");
            } else if (_selectedCompany == null) {
              Fluttertoast.showToast(msg: "Please Select Company");
            } else if (_selectedClient == null) {
              Fluttertoast.showToast(msg: "Please Select Client");
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => confirm_credit(
                            companyId: _selectedCompany.id,
                            clientId: _selectedClient.id,
                            companyName: _selectedCompany.name,
                            clientName: _selectedClient.customer,
                            date: DateFormat.yMd().format(_selectedDate),
                            itemList: addItemList,
                          )));
            }
          },
        ),
        body: Container(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Company Dropdown
                      _text("Company"),
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
                            hint: Text("Select Company",
                                style: TextStyle(color: Colors.black)),
                            items: companyList.map((user) {
                              return DropdownMenuItem<CompanyModel>(
                                value: user ?? 0,
                                child: Text("${user.name}"),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCompany = newValue;
                              });
                            },
                            value: _selectedCompany,
                          ),
                        ),
                      ),

                      //Customer Dropdown
                      _text("Customer"),
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
                            hint: Text("Select Customer",
                                style: TextStyle(color: Colors.black)),
                            items: clientList.map((user) {
                              return DropdownMenuItem<CustomerModel>(
                                value: user ?? 0,
                                child: Text("${user.customer}"),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedClient = newValue;
                              });
                            },
                            value: _selectedClient,
                          ),
                        ),
                      ),

                      /* MyDropDown(
                            label: "Select Customer",
                            items: clientList.map((item) {
                              return DropdownMenuItem(
                                value: item['id'],
                                  child: Text(item['customer']));
                            }).toList(),
                            onChanged: (value){
                             setState(() {
                               _selectedClientInt=value as int;
                               print("${_selectedClientInt.toString()}");
                               print(clientList[1]['customer']);
                             });
                            },
                            value: _selectedClientInt,
                          ),*/

                      /*  DropdownButton(
                          items: customerList.map((item) {
                            return DropdownMenuItem(
                              value: item['customer'],
                                child: Text(item['customer']));
                          }).toList(),
                          hint: Text("Select customer"),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue=value;
                              print('selected :${selectedValue}');
                            });
                          }),*/
                      //DatePicker
                      _text("Date"),
                      MyInputField(
                          readOnly: true,
                          marginBottom: 2.h,
                          controller: dateController,
                          hint: DateFormat.yMd().format(_selectedDate),
                          suffixIconWidget: IconButton(
                            icon: const Icon(Icons.calendar_today_outlined,
                                color: Colors.grey),
                            onPressed: () async {
                              DateTime? pickerDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime(2123));

                              if (pickerDate != null) {
                                setState(() {
                                  _selectedDate = pickerDate;
                                });
                              }
                            },
                          )),

                      //Item Layout
                      _itemLayout(),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                getClientItemList();
                                _bottomSheet();
                              });
                            },
                            child: Text("Add Items And Quantity",
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              //Bottom Navigation
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: MyBottomNavigation(selectedIndex: 0)),
            ],
          ),
        ),
      )),
    );
  }

  _bottomSheet() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext builder) {
          return StatefulBuilder(builder: ((context, myState) {
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
                                  child: Text("Add Items And Quantity",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          fontSize: 14.sp,
                                          color: Colors.black))),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                      CupertinoIcons.clear_circled_solid))
                            ],
                          ),
                          SizedBox(height: 1.h),

                          //Item dropdown
                          _text("Select Items"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: Colors.white,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                                hint: Text("Select Items",
                                    style: TextStyle(color: Colors.black)),
                                items: clientItemList.map((user) {
                                  return DropdownMenuItem<ClientItemModel>(
                                    value: user ?? 0,
                                    child: Text(
                                        "${user.name + " - " + user.currency + " " + user.price.toString()}"),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  myState(() {
                                    _selectedClientItem = newValue;
                                  });
                                },
                                value: _selectedClientItem,
                              ),
                            ),
                          ),

                          //Quantity textField
                          _text("Quantity"),
                          MyInputField(
                              controller: qtyController,
                              keyBoardType: TextInputType.number,
                              hint: "Quantity",
                              marginBottom: 2.h),

                          //Button Add
                          MyButton(
                              label: "ADD",
                              onTap: () {
                                addDataToListView();
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

  _itemLayout() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: addItemList.length,
        separatorBuilder: (context, index) => SizedBox(height: 1.h),
        itemBuilder: (context, index) {
          int quantity = int.parse(qtyController.text.toString());
          double priceDouble = double.parse("${addItemList[index]['price']}");
          int price = priceDouble.toInt();
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(addItemList[index]['item'],
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 11.sp)),
                        SizedBox(height: 0.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textItemLayoutColm(
                                "Qty", addItemList[index]['qty']),
                            _textItemLayoutColm("Price",
                                "${addItemList[index]['currency']} ${addItemList[index]['price']}"),
                            _textItemLayoutColm("Amount",
                                "${addItemList[index]['currency']} ${quantity * price}"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Icon Close
                InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return myAlertDialog(
                              content: "Are you sure you want to Remove?",
                              okLabel: "YES",
                              cancelLabel: "NO",
                              okTap: () {
                                setState(() {
                                  addItemList.remove(addItemList[index]);
                                  Navigator.pop(context);
                                });
                              },
                            );
                          });
                    },
                    child: const Icon(CupertinoIcons.clear_circled_solid))
              ],
            ),
          );
        });
  }

  Widget _text(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
      child: Text(label,
          style: GoogleFonts.lato(color: Colors.black, fontSize: 11.sp)),
    );
  }

  Widget _textItemLayoutColm(String header, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600, fontSize: 11.sp)),
        Text(desc,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500, fontSize: 10.sp))
      ],
    );
  }
}
