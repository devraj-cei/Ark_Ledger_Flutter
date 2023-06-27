import 'dart:convert';
import 'package:ark_ledger/Customer/customer.dart';
import 'package:ark_ledger/Models/CustomerModel.dart';
import 'package:ark_ledger/Widgets/button.dart';
import 'package:ark_ledger/Widgets/dropdown.dart';
import 'package:ark_ledger/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../API/Api-End Point.dart';
import '../Widgets/appbar.dart';
import '../Widgets/bottomNavigation.dart';
import '../Widgets/input-field.dart';

class customer_add extends StatefulWidget {
  customer_add({Key? key, this.flag, this.customerModel}) : super(key: key);

  String? flag;
  CustomerModel? customerModel;

  @override
  State<customer_add> createState() => _customer_addState();
}

class _customer_addState extends State<customer_add> {
  SharedPreferences? sharedPreferences;

  //TextEditingController
  final nameController = TextEditingController(text: "jay Patel");
  final numberController = TextEditingController(text: "9696353856");
  final emailController = TextEditingController();
  final addrController = TextEditingController();
  final pinCodeController = TextEditingController();
  final businessController = TextEditingController();
  final panController = TextEditingController();
  final gstController = TextEditingController();

  bool _chckBoxValue = false;
  bool _btnSearch = true;
  bool _checkBusinessLayout = false;
  bool _businessDetailsLayout = false;
  bool _customerDetailsLayout = false;
  bool _reSearchLayout = false;
  bool _lblSave = false;
  bool _edtNumber = true;

  int? _selectedCountry = 0;
  int? _selectedState = 0;
  int? _selectedCity = 0;
  int? type;

  var email;

  List<dynamic> countryList = [];
  List<dynamic> stateList = [];
  List<dynamic> cityList = [];

  _getData() {
    if (widget.flag == "customer_update") {
      _btnSearch = false;
      _customerDetailsLayout = true;
      _lblSave = true;

      setState(() {
        //Set Controller data
        nameController.text = widget.customerModel!.customer!;
        numberController.text = widget.customerModel!.mobile!;
        emailController.text = widget.customerModel!.email!;
        addrController.text = widget.customerModel!.address!;
        pinCodeController.text = widget.customerModel!.pincode!;
        _selectedCountry = widget.customerModel!.countryId;
        _selectedState = widget.customerModel!.stateId;
        _selectedCity = widget.customerModel!.cityId;

        if (widget.customerModel!.type == 1) {
          _checkBusinessLayout = true;
        } else {
          _checkBusinessLayout = true;
          _chckBoxValue = true;
          _businessDetailsLayout = true;
          businessController.text = widget.customerModel!.businessName!;
          panController.text = widget.customerModel!.panNo!;
          gstController.text = widget.customerModel!.gstIn!;
        }
      });
    }
  }

  _setType() {
    setState(() {
      if (_chckBoxValue == true) {
        type = 2;
      } else {
        type = 1;
      }
    });
  }

  //Get Profile api
  Get_Customer_Details() async {
    try {
      EasyLoading.show(
          status: "Please Wait", maskType: EasyLoadingMaskType.black);
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences!.getString('token');

      Map<String, dynamic> bodyParam = {
        "personName": nameController.text.toString(),
        "mobile": numberController.text.toString()
      };

      var response = await post(
          Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_CUSTOMER_DETAILS),
          headers: {"Content-Type": "application/json", "token": token!},
          body: json.encode(bodyParam));

      debugPrint("Customer Details bodyParam : ${bodyParam.toString()}");

      if (response.statusCode == 200) {
        var responseJSON = json.decode(response.body);
        var responseCode = responseJSON['response_code'];

        if (responseCode == "200") {
          EasyLoading.dismiss();
          var obj = responseJSON['obj'];
          debugPrint("Customer Details obj : $obj");

          debugPrint('Customer Data : $responseJSON');
          setState(() {
            if (obj.isNotEmpty) {
              Fluttertoast.showToast(
                  msg: "Customer Already Exist!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM);
              _customerDetailsLayout = false;
              _btnSearch = true;
              _checkBusinessLayout = false;
              _edtNumber = true;
              _lblSave = false;
              _reSearchLayout = false;
            } else {
              setState(() {
                //Get_Country_API();
                Fluttertoast.showToast(
                    msg: "Customer Not Found",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM);
                _customerDetailsLayout = true;
                _btnSearch = false;
                _checkBusinessLayout = true;
                _edtNumber = false;
                _lblSave = true;
                _reSearchLayout = true;
              });
            }
          });
        } else {
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
        debugPrint(response.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
    }
  }

  //Get Country
  Get_Country_API() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");
    Map<String, dynamic> bodyParam = {};
    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_COUNTRY_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Country data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            countryList = responseObj;
            if (countryList.length > 0) {
              if (_selectedCountry == 0) {
                _selectedCountry = countryList[0]['id'];
              }
            }
          });
        });
      }
    }
  }

  //Get State
  Get_State_API() async {
    if (stateList.isNotEmpty) {
      setState(() {
        stateList.clear();
        _selectedState = 0;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"countryId": _selectedCountry};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_STATE_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    debugPrint("state bodyParam : $bodyParam");

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('State data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            stateList = responseObj;
            if (stateList.length > 0) {
              if (_selectedState == 0) {
                _selectedState = stateList[0]['id'];
              }
            }
          });
        });
      }
    }
  }

  //Get City
  Get_City_API() async {
    if (cityList.isNotEmpty) {
      setState(() {
        cityList.clear();
        _selectedCity = 0;
      });
    }
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {"stateId": _selectedState};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_CITY_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    debugPrint("city bodyParam : $bodyParam");

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('city data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            cityList = responseObj;
            if (cityList.length > 0) {
              if (_selectedCity == 0) {
                _selectedCity = cityList[0]['id'];
              }
            }
          });
        });
      }
    }
  }

  //Update Customer
  Update_Customer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "id": widget.customerModel!.id,
      "cityId": widget.customerModel!.cityId,
      "stateId": widget.customerModel!.stateId,
      "countryId": widget.customerModel!.countryId,
      "personName": nameController.text,
      "mobile": numberController.text,
      "email": emailController.text,
      "address": addrController.text,
      "pincode": pinCodeController.text,
      "businessName": businessController.text,
      "panNo": panController.text,
      "gstIn": gstController.text,
      "type": type
    };
    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.UPDATE_CUSTOMER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    debugPrint("Update Customer bodyParam: $bodyParam");

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());

      if (responseCode == "200") {
        debugPrint("obj " + responseBody['obj']);
        Fluttertoast.showToast(
            msg: "Customer Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => customer()));
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

  //Save Customer
  Save_Customer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "cityId": _selectedCity,
      "stateId": _selectedState,
      "countryId": _selectedCountry,
      "personName": nameController.text,
      "mobile": numberController.text,
      "email": emailController.text,
      "address": addrController.text,
      "pincode": pinCodeController.text,
      "businessName": businessController.text,
      "panNo": panController.text,
      "gstIn": gstController.text,
      "type": type
    };
    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.ADD_CUSTOMER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    debugPrint("Add Customer bodyParam: $bodyParam");

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());

      if (responseCode == "200") {
        debugPrint("obj " + responseBody['obj']);
        Fluttertoast.showToast(
            msg: "Customer Added Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => customer()));
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
    _getData();
    _setType();
    Get_Country_API();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      drawer: main_drawer(),
      appBar: MyAppbar(
          label: widget.flag == "customer_update"
              ? "Update Customer"
              : "Add Customer",
          suffixLabel: "SAVE",
          suffixLabelVisibility: _lblSave,
          suffixLabelTap: () {
            if (widget.flag == "customer_update") {
              Update_Customer_API();
            } else {
              Save_Customer_API();
            }
          }),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 2.h, right: 2.h, top: 2.h, bottom: 9.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _text("Name"),
                    MyInputField(
                        marginBottom: 1.h,
                        controller: nameController,
                        hint: "Please Enter Name"),
                    _text("Mobile"),
                    //number
                    Visibility(
                        visible: _edtNumber,
                        child: MyInputField(
                            keyBoardType: TextInputType.number,
                            marginBottom: 1.h,
                            controller: numberController,
                            hint: "Please Enter Mobile")),

                    //Layout Research
                    Visibility(
                      visible: _reSearchLayout,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 60.w,
                              child: MyInputField(
                                  keyBoardType: TextInputType.number,
                                  marginBottom: 1.h,
                                  controller: numberController,
                                  hint: "Please Enter Mobile")),
                          SizedBox(width: 0.5.h),
                          Expanded(
                            child: MyButton(
                                label: "Search",
                                onTap: () {
                                  setState(() {
                                    Get_Customer_Details();
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),

                    //button Search
                    Visibility(
                      visible: _btnSearch,
                      child: MyButton(
                          label: "Search",
                          onTap: () {
                            setState(() {
                              Get_Customer_Details();
                            });
                          }),
                    ),

                    _customerDetailsShow()
                  ],
                ),
              ),
            ),

            //Bottom Navigation
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: MyBottomNavigation(selectedIndex: 1))
          ],
        ),
      ),
    ));
  }

  Widget _customerDetailsShow() {
    return Visibility(
      visible: _customerDetailsLayout,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Email
          _text("Email"),
          MyInputField(
              marginBottom: 1.h,
              controller: emailController,
              hint: "Please Enter Email"),

          //Address
          _text("Address"),
          MyInputField(
              marginBottom: 1.h,
              controller: addrController,
              hint: "Please Enter Address",
              maxLines: 4,
              height: 80),

          //PinCode
          _text("PinCode"),
          MyInputField(
              marginBottom: 1.h,
              controller: pinCodeController,
              hint: "Please Enter PinCode",
              keyBoardType: TextInputType.number),

          //Country dropdown
          _text("Country"),
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
                hint: Text("Select Country",
                    style: TextStyle(color: Colors.black)),
                items: countryList.map((item) {
                  return DropdownMenuItem(
                      value: item['id'],
                      child: Text(item['name'].toString(),
                          style: const TextStyle(color: Colors.black)));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    stateList.clear();
                    cityList.clear();
                    _selectedCountry = newValue as int;
                    Get_State_API();
                  });
                },
                value: _selectedCountry!,
              ),
            ),
          ),
          SizedBox(height: 1.h),

          //state dropdown
          _text("State"),
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
                hint:
                    Text("Select State", style: TextStyle(color: Colors.black)),
                items: stateList.map((item) {
                  return DropdownMenuItem(
                      value: item['id'],
                      child: Text(item['name'].toString(),
                          style: const TextStyle(color: Colors.black)));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    cityList.clear();
                    _selectedState = newValue as int;
                    Get_City_API();
                  });
                },
                value: _selectedState!,
              ),
            ),
          ),
          SizedBox(height: 1.h),

          //City dropdown
          _text("City"),
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
                hint:
                    Text("Select City", style: TextStyle(color: Colors.black)),
                items: cityList.map((item) {
                  return DropdownMenuItem(
                      value: item['id'],
                      child: Text(item['name'].toString(),
                          style: const TextStyle(color: Colors.black)));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCity = newValue as int;
                  });
                },
                value: _selectedCity!,
              ),
            ),
          ),

          //Business layout
          _businessLayout()
        ],
      ),
    );
  }

  //Business Layout
  _businessLayout() {
    return Column(
      children: [
        Visibility(
          visible: _checkBusinessLayout,
          child: Row(
            children: [
              Checkbox(
                  activeColor: Colors.black,
                  value: _chckBoxValue,
                  onChanged: (value) {
                    setState(() {
                      _chckBoxValue = !_chckBoxValue;
                      _businessDetailsLayout = true;
                    });
                  }),
              Text("Include Business Details",
                  style: GoogleFonts.quicksand(
                      color: Colors.black, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Visibility(
            visible: _businessDetailsLayout,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Business name
                _text("Business Name"),
                MyInputField(
                    marginBottom: 1.h,
                    controller: businessController,
                    hint: "Please Enter Business Name"),

                //PAN
                _text("Pan Number"),
                MyInputField(
                    marginBottom: 1.h,
                    controller: panController,
                    hint: "Please Enter Pan No."),

                //GST
                _text("GST No."),
                MyInputField(
                    marginBottom: 1.h,
                    controller: gstController,
                    hint: "Please Enter GST No."),
              ],
            ))
      ],
    );
  }

  Widget _text(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(label, style: GoogleFonts.lato(color: Colors.black)),
    );
  }
}
