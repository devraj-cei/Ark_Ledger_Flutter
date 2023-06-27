import 'dart:convert';
import 'dart:io';

import 'package:ark_ledger/Offer/offers%20details.dart';
import 'package:ark_ledger/Offer/offers.dart';
import 'package:ark_ledger/Widgets/appbar.dart';
import 'package:ark_ledger/Widgets/dropdown.dart';
import 'package:ark_ledger/Widgets/input-field.dart';
import 'package:ark_ledger/drawer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

import '../API/Api-End Point.dart';
import '../Models/OfferModel.dart';
import '../Widgets/bottomNavigation.dart';

class offers_add extends StatefulWidget {
  final OfferModel? offerModel;
  final String? flag;

  const offers_add({Key? key, this.offerModel, this.flag}) : super(key: key);

  @override
  State<offers_add> createState() => _offers_addState();
}

class _offers_addState extends State<offers_add> {
  SharedPreferences? sharedPreferences;

  //TextEditingController
  final titleController = TextEditingController();
  final discountController = TextEditingController();
  final minOrderController = TextEditingController();
  final maxDisController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final noteController = TextEditingController();
  final tncController = TextEditingController();

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  int? _selectedDiscountId=1;
  var image;
  final List _discountList = [
    {"discountId": 1, "name": "Percentage"},
    {"discountId": 2, "name": "Flat"}
  ];

  File? PickedImageFile;
  var PickedImageBasename;

  //Pic Image from Gallary
  _getFromGallery() async {
    final PickedFile? pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        PickedImageFile = File(pickedFile.path);
        print(PickedImageFile);

        //  _filename = p.basename(imageFile.path);
        PickedImageBasename = PickedImageFile!.path.split('/').last;
        print('filename : $PickedImageBasename');
      });
    }
  }

  //Set Text
  _setData() {
    if (widget.flag != null && widget.flag == "update_offer_flag") {
      setState(() {
        image =
            "http://arkledger.techregnum.com/assets/Offers/${widget.offerModel!.imageFile}";
        titleController.text = widget.offerModel!.title!;
        discountController.text = widget.offerModel!.discount.toString();
        minOrderController.text = widget.offerModel!.minOrderValue.toString();
        maxDisController.text = widget.offerModel!.maxDiscountValue.toString();
        startDateController.text = widget.offerModel!.startDate.toString();
        endDateController.text = widget.offerModel!.endDate.toString();
        noteController.text = widget.offerModel!.note!;
        tncController.text = widget.offerModel!.tnc!;
      });
    }
  }

//Save Offer API
  Save_Offer_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');

    Map<String, dynamic> bodyParam = {
      "id": widget.offerModel!.id,
      "appClientId": widget.offerModel!.appClientId,
      "discountType": _selectedDiscountId,
      "discount": discountController.text.toString(),
      "minOrderValue": minOrderController.text.toString(),
      "maxDiscountValue": maxDisController.text.toString(),
      "startDate": startDateController.text.toString(),
      "endDate": endDateController.text.toString(),
      "note": noteController.text.toString(),
      "tnc": tncController.text.toString(),
      "title": titleController.text.toString(),
      "imageFile": PickedImageBasename
    };
    debugPrint("bodyParam :$bodyParam");
    debugPrint("pick image file : $PickedImageBasename");

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.SAVE_OFFER_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());

      if (responseCode == "200") {
        debugPrint("obj " + responseBody['obj']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => offer()));
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

  Upload_Image_API() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences!.getString('token');

      var response = await post(
          Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.UPLOAD_OFFER_IMAGE),
          headers: {"Content-Type": "application/json", "token": token!},
          body: PickedImageBasename);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var responseCode = responseBody['response_code'];
        print(responseBody);

        if (responseCode == "200") {
          var obj = responseBody['obj'];
          print(obj);

          setState(() {
            Save_Offer_API();
          });
        } else {
          debugPrint(response.body);
        }
      } else {
        debugPrint(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      drawer: main_drawer(),
      appBar: MyAppbar(
          label:
              widget.flag == "update_offer_flag" ? "Update Offer" : "Add Offer",
          suffixLabel: "SAVE",
          suffixLabelTap: () {
            if (PickedImageFile == null) {
              debugPrint("file is empty");
              Upload_Image_API();
            } else {
              debugPrint("File is not empty");
              Save_Offer_API();
            }
          }),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    left: 2.h, right: 2.h, top: 2.h, bottom: 9.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 22.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: DottedBorder(
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        child: Row(
                          children: [
                            Expanded(
                                child: widget.flag == "update_offer_flag"
                                    ? PickedImageFile == null
                                        ? Image(
                                            image: NetworkImage(image),
                                            fit: BoxFit.fill)
                                        : Image(
                                            image: FileImage(PickedImageFile!))
                                    : Container())
                          ],
                        ),
                      ),
                    ),

                    //Add photo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              _getFromGallery();
                            },
                            icon: Icon(CupertinoIcons.plus,
                                color: Colors.black, size: 2.5.h),
                            label: Text(
                              "Add Photo",
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.sp),
                            ))
                      ],
                    ),

                    //Title
                    _text("Name"),
                    MyInputField(
                        marginBottom: 1.h,
                        controller: titleController,
                        hint: "Enter Title"),

                    //Discount type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _text("Select Discount Type"),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          dropdownColor: Colors.white,
                                          isExpanded: true,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          hint: Text("Select Discount",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          items: _discountList.map((item) {
                                            return DropdownMenuItem(
                                                value: item['discountId'],
                                                child: Text(
                                                    item['name'].toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black)));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              if (widget.flag ==
                                                  "update_offer_flag") {
                                                widget.offerModel!
                                                        .discountType =
                                                    newValue as int?;
                                                _selectedDiscountId = widget
                                                    .offerModel!.discountType;
                                              } else {
                                                _selectedDiscountId =
                                                    newValue as int?;
                                              }
                                            });
                                          },
                                          value: widget.flag ==
                                                  "update_offer_flag"
                                              ? widget.offerModel!.discountType!
                                              : _selectedDiscountId!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 1.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _text("Discount"),
                              Row(
                                children: [
                                  Expanded(
                                      child: MyInputField(
                                          controller: discountController,
                                          hint: "Discount")),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 1.h),

                    //Min order value
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _text("Min Order Value"),
                              Row(
                                children: [
                                  Expanded(
                                      child: MyInputField(
                                          marginBottom: 1.h,
                                          controller: minOrderController,
                                          hint: "Min Order Value")),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 1.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _text("Max Discount"),
                              Row(
                                children: [
                                  Expanded(
                                      child: MyInputField(
                                          marginBottom: 1.h,
                                          controller: maxDisController,
                                          hint: "Max Discount")),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),

                    //Start/End Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _text("Start Date"),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyInputField(
                                        readOnly: true,
                                        marginBottom: 2.h,
                                        controller: startDateController,
                                        hint: DateFormat.yMd()
                                            .format(_selectedStartDate),
                                        suffixIconWidget: IconButton(
                                          icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: Colors.grey),
                                          onPressed: () async {
                                            DateTime? pickerDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1990),
                                                    lastDate: DateTime(2123));

                                            if (pickerDate != null) {
                                              setState(() {
                                                _selectedStartDate = pickerDate;
                                              });
                                            } else {
                                              debugPrint(
                                                  'Something went wrong');
                                            }
                                          },
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 1.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _text("End Date"),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyInputField(
                                        readOnly: true,
                                        marginBottom: 2.h,
                                        controller: endDateController,
                                        hint: DateFormat.yMd()
                                            .format(_selectedEndDate),
                                        suffixIconWidget: IconButton(
                                          icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: Colors.grey),
                                          onPressed: () async {
                                            DateTime? pickerDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1990),
                                                    lastDate: DateTime(2123));

                                            if (pickerDate != null) {
                                              setState(() {
                                                _selectedEndDate = pickerDate;
                                              });
                                            } else {
                                              debugPrint(
                                                  'Something went wrong');
                                            }
                                          },
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),

                    _text("Note (Optional)"),
                    MyInputField(
                        hint: "Note",
                        maxLines: 4,
                        height: 80,
                        controller: noteController),
                    SizedBox(height: 1.h),
                    _text("T&C"),
                    MyInputField(
                        hint: "T&C",
                        maxLines: 4,
                        height: 80,
                        controller: tncController)
                  ],
                ),
              ),
            ),
            //Bottom Navigation
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: MyBottomNavigation(selectedIndex: 3))
          ],
        ),
      ),
    ));
  }

  Widget _text(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(label, style: GoogleFonts.lato(color: Colors.black)),
    );
  }
}
