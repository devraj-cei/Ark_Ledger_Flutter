import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ark_ledger/API/Api-End%20Point.dart';
import 'package:ark_ledger/Setting/profile.dart';
import 'package:ark_ledger/Widgets/input-field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/appbar.dart';
import '../Widgets/bottomNavigation.dart';
import '../drawer.dart';
import 'package:http/http.dart' as http;


class profile_edit extends StatefulWidget {
  final String? uid, name, mobile, email, image;

  const profile_edit(
      {Key? key, this.uid, this.name, this.mobile, this.email, this.image})
      : super(key: key);

  @override
  State<profile_edit> createState() => _profile_editState();
}

class _profile_editState extends State<profile_edit> {

  SharedPreferences? sharedPreferences;

  //TextEditingController
  final _uidController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  var _profilePic;
  var networkImage;

  File? PickedImageFile;

  Get_Data() {
    setState(() {
      _uidController.text = widget.uid.toString();
      _nameController.text = widget.name.toString();
      _mobileController.text = widget.mobile.toString();
      _emailController.text = widget.email.toString();
      _profilePic =
      "http://arkledger.techregnum.com/assets/AppClientUsers/${widget.image}";
    });
  }

  //Pic Image from Gallary
  _getFromGallery() async {
    final PickedFile? pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        PickedImageFile = File(pickedFile.path);
        debugPrint("PickedImageFile $PickedImageFile");
      });
    }
  }

  Update_Profile_API() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences!.getString('token');
    var obj = sharedPreferences!.getString('obj');
    var getProfileObj = jsonDecode(obj!);
    int clientId = getProfileObj['appClientId'];
    int clientCompanyId = getProfileObj['appClientCompaniesId'];

    Map<String, dynamic> bodyParam = {
      "appClientId": clientId,
      "appClientCompaniesId": clientCompanyId,
      "name": _nameController.text,
      "email": _emailController.text,
      "mobile": _mobileController.text,
      "profilePic": networkImage
    };

    var response = await post(
        Uri.parse(API_EndPoint.BASE_URL + API_EndPoint.UPDATE_PROFILE),
        headers: {"Content-Type": "application/json", "token": token!},
        body: json.encode(bodyParam));

    debugPrint("Update Profile bodyParam: $bodyParam");

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      var responseCode = responseBody['response_code'];
      debugPrint(responseBody.toString());

      if (responseCode == "200") {
        EasyLoading.dismiss();
        debugPrint("obj " + responseBody['obj']);

        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const profile()));
        });
      } else {
        EasyLoading.dismiss();
        debugPrint(response.body);
      }
    } else {
      EasyLoading.dismiss();
      debugPrint(response.body);
    }
  }

  //Upload Image
  void uploadImage() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    var imagePath = PickedImageFile!.path;
    print(imagePath);
    final request = await http.MultipartRequest(
        'POST',
        Uri.parse(API_EndPoint.BASE_URL+API_EndPoint.UPLOAD_PROFILE_IMAGE));
    request.headers.addAll({"token": token.toString()});
    request.files
        .add(await http.MultipartFile.fromPath("profilePic", imagePath));

    var response = await request.send();
    var responded = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      setState(() {
        networkImage = PickedImageFile!.path.split('/').last.toString();
        print("Network Image :$networkImage");
        print("imagePath :$imagePath");
      });
      //Update_Profile_API();
      print("Uploaded Successfully ${response.statusCode}");
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      print("Error ${response.reasonPhrase}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_Data();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: main_drawer(),
          appBar: MyAppbar(
              label: "Update Profile", suffixLabel: "SAVE", suffixLabelTap: () {
            setState(() {
              if (PickedImageFile == null) {
                debugPrint("file is empty");
                Update_Profile_API();
              } else {
                debugPrint("file is not empty");
                uploadImage();
              }
            });
          }),
          body: Container(
            height: double.infinity,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 2.h, left: 3.h, right: 3.h,bottom: 9.h),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 10.h,
                              backgroundColor: Colors.grey.shade400,
                              backgroundImage:
                              PickedImageFile == null
                                  ? NetworkImage(_profilePic)
                                  : FileImage(PickedImageFile!) as ImageProvider,
                            ),
                            Positioned(
                                bottom: 0,
                                right: 2.h,
                                child: InkWell(
                                  onTap: () => _getFromGallery(),
                                  child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.black),
                                          color: Colors.white),
                                      child: const Icon(
                                          CupertinoIcons.camera_fill,
                                          color: Colors.black, size: 18)),
                                ))
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //UID
                              _text("UID"),
                              MyInputField(
                                  controller: _uidController,
                                  marginBottom: 1.h,
                                  paddingLeft: 0,
                                  color: Colors.grey.shade200,
                                  readOnly: true,
                                  hint: "UID",
                                  prefixIcon:
                                  const Icon(CupertinoIcons.person_crop_circle)),
                              //Name
                              _text("Name"),
                              MyInputField(
                                  controller: _nameController,
                                  marginBottom: 1.h,
                                  paddingLeft: 0,
                                  hint: "Name",
                                  prefixIcon:
                                  const Icon(CupertinoIcons.person_crop_circle)),
                              //Mobile
                              _text("Mobile"),
                              MyInputField(
                                  controller: _mobileController,
                                  marginBottom: 1.h,
                                  paddingLeft: 0,
                                  hint: "Mobile",
                                  keyBoardType: TextInputType.number,
                                  prefixIcon: const Icon(CupertinoIcons.phone_fill)),
                              //Email
                              _text("Email"),
                              MyInputField(
                                  controller: _emailController,
                                  paddingLeft: 0,
                                  hint: "Email",
                                  prefixIcon: const Icon(CupertinoIcons.mail_solid)),
                            ],
                          ),
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
                    child: MyBottomNavigation(
                        selectedIndex: 4)),
              ],
            ),
          ),
        ));
  }

  Widget _text(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(title,
          style: GoogleFonts.quicksand(
              color: Colors.black, fontWeight: FontWeight.w500)),
    );
  }
}
