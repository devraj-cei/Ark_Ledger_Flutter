import 'dart:convert';
import 'package:ark_ledger/Credit/add%20credit.dart';
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
import '../drawer.dart';

class confirm_credit extends StatefulWidget {
  final int? companyId;
  final int? clientId;
  final String? companyName;
  final String? clientName;
  final String? date;
  final List? itemList;

  const confirm_credit(
      {Key? key,
      this.companyId,
      this.clientId,
      this.companyName,
      this.clientName,
      this.date,
      this.itemList})
      : super(key: key);

  @override
  State<confirm_credit> createState() => _confirm_creditState();
}

class _confirm_creditState extends State<confirm_credit> {
  SharedPreferences? sharedPreferences;
  int? companyId, clientId;
  var date, companyName, clientName, image, qty;
  List<dynamic> itemList = [];

  getData() {
    setState(() {
      companyId = widget.companyId;
      clientId = widget.clientId;
      companyName = widget.companyName;
      clientName = widget.clientName;
      date = widget.date;
    });
  }

  //Save Credit Ledger
  saveCreditLedger() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');
    var obj = sharedPreferences!.getString('obj');
    var getProfileObj = jsonDecode(obj!);
    int clientId = getProfileObj['appClientId'];

    Map<String, dynamic> bodyParam = {
      "appclientId": clientId,
      "clientCustomerId": widget.clientId,
      "clientCompanyId": widget.companyId,
      "date": widget.date,
      "clItems": widget.itemList
    };
    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.SAVE_CREDIT_LEDGER),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    debugPrint("save credit bodyParam: ${bodyParam.toString()}");

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());

      if (responseCode == "200") {
        debugPrint("obj " + responseBody['obj']);
        Fluttertoast.showToast(
            msg: "Credit Saved Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const add_credit()));
        });
        EasyLoading.dismiss();
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawer: main_drawer(),
      appBar: MyAppbar(
        label: "Credit Ledger",
        suffixLabel: "SAVE",
        suffixLabelTap: () => saveCreditLedger(),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                child: Column(
                  children: [
                    Image.asset("assets/Images/assets_3.png",
                        height: 17.h, width: 17.h, fit: BoxFit.fill),
                    SizedBox(height: 2.h),
                    Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(companyName ?? "".toUpperCase(),
                            style: GoogleFonts.quicksand(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ))),
                    Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(date ?? "",
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey))),

                    SizedBox(height: 1.h),

                    //Customer button
                    _buttonBlack(_text("Customer: $clientName")),
                    SizedBox(height: 1.h),

                    //total items button
                    _buttonBlack(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _text("Total Items:"),
                        _text(widget.itemList!.length.toString()),
                      ],
                    )),

                    //Item Layout
                    _itemLayout()
                  ],
                ),
              ),
            ),
            //Bottom Navigation
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: MyBottomNavigation(
                    selectedIndex: 0)),
          ],
        ),
      ),
    ));
  }

  _itemLayout() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.itemList!.length,
        itemBuilder: (context, int index) {
          int quantity = int.parse(widget.itemList![index]['qty']);
          double priceDouble = double.parse(widget.itemList![index]['price']);
          int price = priceDouble.toInt();
          image =
              "http://arkledger.techregnum.com/assets/Products/${widget.itemList![index]['image']}";

          return Container(
            margin: EdgeInsets.only(top: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      height: 10.h,
                      width: 10.h,
                      color: Colors.white,
                      child: Image.network(image, fit: BoxFit.fill)),
                ),
                SizedBox(width: 1.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textColorBlack(widget.itemList![index]["item"] ?? ""),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textColorBlack(
                              "Price : ${widget.itemList![index]['currency']} ${price.toString()}"),
                          _textColorBlack(
                              "Qty: ${widget.itemList![index]['qty']}")
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 1.h),
                          padding: EdgeInsets.only(left: 1.h),
                          width: double.infinity,
                          height: 4.h,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.sp),
                              color: Theme.of(context).primaryColor),
                          child: _textColorBlack(
                              "Amount: ${widget.itemList![index]['currency']} ${quantity * price} /-"))
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _buttonBlack(Widget text) {
    return Container(
        height: 4.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            border: Border.all(width: 2),
            color: Colors.black),
        child: text);
  }

  _text(String label) {
    return Text(label,
        style: GoogleFonts.lato(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp));
  }

  _textColorBlack(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.2.h),
      child: Text(label,
          style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp)),
    );
  }
}
