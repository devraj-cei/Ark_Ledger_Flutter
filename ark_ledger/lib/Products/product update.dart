import 'dart:convert';
import 'dart:io';

import 'package:ark_ledger/Models/ProductModel.dart';
import 'package:ark_ledger/Products/product.dart';
import 'package:ark_ledger/Widgets/dropdown.dart';
import 'package:ark_ledger/Widgets/input-field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../API/Api-End Point.dart';
import '../Widgets/appbar.dart';
import '../Widgets/bottomNavigation.dart';
import '../drawer.dart';
import 'package:http/http.dart' as http;

class product_update extends StatefulWidget {
  final String? flag;
  final ProductModel? productModel;

  const product_update({Key? key, this.flag, this.productModel}) : super(key: key);

  @override
  State<product_update> createState() => _product_updateState();
}

class _product_updateState extends State<product_update> {
  SharedPreferences? sharedPreferences;

  //TextEditingController
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  int? _selectedCompany;
  int? _selectedCategory;
  int? _selectedSubCategory;
  int? _selectedHSN;
  int? _selectedCurrency;

  var image;
  var productImage;
  File? PickedImageFile;

  List<dynamic> companyList = [];
  List<dynamic> categoryList = [];
  List<dynamic> subCategoryList = [];
  List<dynamic> hsnList = [];
  List<dynamic> currencyList = [];

  Get_Data() {
    setState(() {
      if (widget.flag == "product_update") {
        image =
        "http://arkledger.techregnum.com/assets/Products/${widget.productModel!.image}";
        nameController.text = widget.productModel!.name!;
        descController.text = widget.productModel!.description!;
        priceController.text = widget.productModel!.price.toString();
        discountController.text = widget.productModel!.discount.toString();
        _selectedCompany = widget.productModel!.clientCompanyId;
        _selectedCategory = widget.productModel!.productCategoryId;
        _selectedSubCategory = widget.productModel!.productSubcategoryId;
        _selectedHSN = widget.productModel!.hsnsacId;
        _selectedCurrency = widget.productModel!.currencyId;
      }
    });
  }

  //Get Company
  Get_Company_API() async {
    companyList.clear();
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_CLIENT_COMPANY_LIST),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    debugPrint('Company bodyParam : $bodyParam');

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('Company data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            for (Map data in responseObj) {
              companyList.add(data);
              var company = companyList[0]['id'];
              setState(() {
                _selectedCompany = company;
              });
            }
          });
        });
      }
    }
  }

  //Get Product Category
  Get_Category_API() async {
    categoryList.clear();
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
    subCategoryList.clear();
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

  //Get HSN
  Get_HSN_API() async {
    hsnList.clear();
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");

    Map<String, dynamic> bodyParam = {};

    final response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.GET_HSN_CODE),
        headers: {"Content-Type": "application/json", "token": token!},
        body: jsonEncode(bodyParam));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var responseCode = responseBody['response_code'];

      debugPrint('HSN data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            for (Map data in responseObj) {
              hsnList.add(data);
              var hsn = hsnList[0]['id'];
              setState(() {
                _selectedHSN = hsn;
              });
            }
          });
        });
      }
    }
  }

  //Get Currency
  Get_Currency_API() async {
    currencyList.clear();
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

      debugPrint('currency data : $responseBody');

      if (responseCode == '200') {
        setState(() {
          List responseObj = responseBody['obj'];
          setState(() {
            for (Map data in responseObj) {
              currencyList.add(data);
              var currency = currencyList[0]['id'];
              setState(() {
                _selectedCurrency = currency;
              });
            }
          });
        });
      }
    }
  }

  //Save Product
  Update_Product_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString('token');
    var obj = sharedPreferences!.getString('obj');
    var getProfileObj = jsonDecode(obj!);
    int clientId = getProfileObj['appClientId'];

    Map<String, dynamic> bodyParam = {
      'clientId': clientId,
      "name": nameController.text,
      "description": descController.text,
      "price": priceController.text,
      "discount": discountController.text,
      "currencyId": _selectedCurrency,
      "clientCompanyId": _selectedCompany,
      "productCategoryId": _selectedCategory,
      "productSubcategoryId": _selectedSubCategory,
      "hsnsacId": _selectedHSN,
      "status": true,
      "allowSearch": true,
    };
    if (widget.flag == "product_update") {
      bodyParam.addAll({
        "id": widget.productModel!.id,
        "image": productImage ?? widget.productModel!.image
      });
    } else {
      bodyParam.addAll({"image": productImage});
    }
    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.SAVE_PRODUCT),
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
            msg: "Product Saved Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => product()));
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

  //Pic Image from Gallary
  _getFromGallery() async {
    final PickedFile? pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        PickedImageFile = File(pickedFile.path);
        print(PickedImageFile);
      });
    }
  }

  //Upload Product Image
  void uploadImage() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var imagePath = PickedImageFile!.path;
    final request = await http.MultipartRequest('POST',
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.UPLOAD_PRODUCT_IMAGE));
    request.headers.addAll({"token": token!});
    request.files.add(await http.MultipartFile.fromPath("image", imagePath));

    var response = await request.send();
    var responded = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      setState(() {
        productImage = PickedImageFile!.path.split('/').last.toString();
      });
      print("Uploaded Successfully");
      EasyLoading.dismiss();
      Update_Product_API();
    } else {
      EasyLoading.dismiss();
      print("ERROR");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_Data();
    Get_Company_API();
    Get_Category_API();
    Get_HSN_API();
    Get_Currency_API();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: main_drawer(),
          appBar: MyAppbar(
              label: widget.flag == "product_update"
                  ? "Update Product"
                  : "Add Product",
              suffixLabel: "SAVE",
              suffixLabelTap: () {
                if (PickedImageFile == null) {
                  debugPrint("file is empty");
                  Update_Product_API();
                } else {
                  debugPrint("file is not empty");
                  uploadImage();
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
                        //Image
                        Container(
                          height: 20.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: DottedBorder(
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            child: Row(
                              children: [
                                Expanded(
                                  child: widget.flag == "product_update"
                                      ? PickedImageFile == null
                                      ? Image(image: NetworkImage(image))
                                      : Image(
                                      image: FileImage(PickedImageFile!))
                                  /*Image(
                                    image: PickedImageFile == null
                                        ? NetworkImage(image)
                                        : FileImage(PickedImageFile),
                                    fit: BoxFit.fill,
                                  )*/
                                      : Container(
                                    child: PickedImageFile == null
                                        ? Container()
                                        : Image(
                                        image:
                                        FileImage(PickedImageFile!),
                                        fit: BoxFit.fill),
                                  ),
                                )
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

                        //name
                        _text("Name"),
                        MyInputField(
                            controller: nameController,
                            hint: "Name",
                            marginBottom: 1.h),

                        //Company dropdown
                        _text('Company'),
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
                              items: companyList.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text(item['name'].toString(),
                                        style:
                                        const TextStyle(color: Colors.black)));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCompany = newValue as int;
                                });
                              },
                              value: _selectedCompany!,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),

                        //category dropdown
                        _text('Product Category'),
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
                              hint: Text("Select Product Category", style: TextStyle(color: Colors.black)),
                              items: categoryList.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text(item['title'].toString(),
                                        style: const TextStyle(color: Colors.black)));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  subCategoryList.clear();
                                  _selectedCategory = newValue as int;
                                  Get_SubCategory_API();
                                });
                              },
                              value: _selectedCategory!,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),

                        //sub category dropdown
                        _text('Product Sub Category'),
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
                              hint: Text("Select Product Sub Category", style: TextStyle(color: Colors.black)),
                              items: subCategoryList.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text(item['title'].toString(),
                                        style: const TextStyle(color: Colors.black)));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedSubCategory = newValue as int;
                                });
                              },
                              value: _selectedSubCategory!,
                            ),
                          ),
                        ),

                        SizedBox(height: 1.h),
                        _text('Description'),
                        MyInputField(
                            controller: descController,
                            height: 80,
                            maxLines: 4,
                            marginBottom: 1.h,
                            hint: "Description"),

                        //HSN dropdown
                        _text("HSN"),
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
                              hint: Text("Select HSN", style: TextStyle(color: Colors.black)),
                              items: hsnList.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text(item['code'].toString(),
                                        style: const TextStyle(color: Colors.black)));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedHSN = newValue as int;
                                });
                              },
                              value: _selectedHSN!,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),

                        //Currency dropdown
                        _text("Currency"),
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
                              hint: Text("Select Currency", style: TextStyle(color: Colors.black)),
                              items: currencyList.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text(
                                        item['name'].toString() +
                                            "-" +
                                            item["currencyName"] +
                                            "-" +
                                            item['currencySymbol'],
                                        style: const TextStyle(color: Colors.black)));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCurrency = newValue as int;
                                });
                              },
                              value: _selectedCurrency!,
                            ),
                          ),
                        ),

                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _text("Price"),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: MyInputField(
                                              controller: priceController,
                                              hint: "Price")),
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

  Widget _text(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(label, style: GoogleFonts.lato(color: Colors.black)),
    );
  }
}
