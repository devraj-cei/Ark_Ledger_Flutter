import 'package:ark_ledger/Models/OfferModel.dart';
import 'package:ark_ledger/Offer/offers%20add.dart';
import 'package:ark_ledger/Offer/offers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/bottomNavigation.dart';

class offer_details extends StatefulWidget {
  final OfferModel? offerModel;

  const offer_details({Key? key, this.offerModel}) : super(key: key);

  @override
  State<offer_details> createState() => _offer_detailsState();
}

class _offer_detailsState extends State<offer_details> {
  @override
  Widget build(BuildContext context) {
    double _imageHeight = 28.h;
    double _detailCardTop = _imageHeight - 2.h;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image(
              image: NetworkImage(
                  "http://arkledger.techregnum.com/assets/Offers/${widget.offerModel!.imageFile}"),
              height: _imageHeight,
              width: 100.w,
              fit: BoxFit.fill),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 4.h,
                width: 4.h,
                margin: EdgeInsets.only(top: 2.h, left: 2.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.menu, color: Colors.black, size: 2.h),
              ),
              Container(
                margin: EdgeInsets.only(right: 2.h, top: 2.h),
                height: 4.h,
                width: 4.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const offer()));
                    },
                    child: const Icon(Icons.arrow_back_outlined,
                        color: Colors.black)),
              ),
            ],
          ),

          //Details
          Container(
            margin: EdgeInsets.only(top: _detailCardTop),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: _detailsCard(),
          ),

          //Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              offers_add(offerModel: widget.offerModel,
                              flag: "update_offer_flag",)));
                },
                child: Container(
                  margin: EdgeInsets.only(top: _detailCardTop - 2.5.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.h),
                  height: 4.5.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      "Edit",
                      style: GoogleFonts.quicksand(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //Bottom Navigation
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: MyBottomNavigation(
                  selectedIndex: 3))
        ],
      ),
    ));
  }

  _detailsCard() {
    var discount;
    if (widget.offerModel!.discountType == 1) {
      discount = "${widget.offerModel!.discount}% off";
    } else {
      discount = "Flat  ₹${widget.offerModel!.discount} off ";
    }

    //Parse Date
    DateFormat format = DateFormat("MM/dd/yyyy");
    var newDate = format.parse(widget.offerModel!.endDate!);
    format = DateFormat("dd MMM yyyy");
    var date = format.format(newDate);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h, left: 1.h, right: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Title
          Text(widget.offerModel!.title!,
              style: GoogleFonts.quicksand(
                  fontSize: 12.5.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 0.5.h),
          //discount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                discount,
                style: GoogleFonts.quicksand(
                    fontSize: 11.sp, fontWeight: FontWeight.w500),
              ),
              RichText(
                  text: TextSpan(
                      style: GoogleFonts.quicksand(
                          fontSize: 10.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      children: [
                    const TextSpan(text: "Valid till :- "),
                    TextSpan(
                        text: date,
                        style: GoogleFonts.quicksand(
                            fontSize: 9.sp, color: Colors.grey.shade600)),
                  ])),
            ],
          ),

          Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Divider(color: Colors.grey.shade600)),

          //Note
          RichText(
              text: TextSpan(
                  style: GoogleFonts.quicksand(
                      fontSize: 11.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                  children: [
                const TextSpan(text: "Note: "),
                TextSpan(
                    text: widget.offerModel!.note,
                    style: GoogleFonts.quicksand(
                        fontSize: 9.sp, color: Colors.grey.shade700)),
              ])),

          Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Divider(color: Colors.grey.shade600)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      style: GoogleFonts.quicksand(
                          fontSize: 11.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      children: [
                    const TextSpan(text: "Min Order: "),
                    TextSpan(
                        text: widget.offerModel!.minOrderValue.toString(),
                        style: GoogleFonts.quicksand(
                            fontSize: 9.sp, color: Colors.grey.shade700)),
                  ])),
              RichText(
                  text: TextSpan(
                      style: GoogleFonts.quicksand(
                          fontSize: 11.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      children: [
                    const TextSpan(text: "Max Discount: "),
                    TextSpan(
                        text: widget.offerModel!.maxDiscountValue.toString(),
                        style: GoogleFonts.quicksand(
                            fontSize: 9.sp, color: Colors.grey.shade700)),
                  ])),
            ],
          ),

          Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Divider(color: Colors.grey.shade600)),

          //Terms and conditions
          Text("Terms & Conditions",
              style: GoogleFonts.quicksand(
                  fontSize: 10.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          Text(widget.offerModel!.tnc!,
              style: GoogleFonts.quicksand(fontSize: 9.sp)),
        ],
      ),
    );
  }
}
