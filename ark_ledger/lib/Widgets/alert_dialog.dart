import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class myAlertDialog extends StatelessWidget {
  final String? content;
  final String? okLabel;
  final String? cancelLabel;
  final Function()? okTap;
  const myAlertDialog({Key? key,this.content,this.okLabel,this.cancelLabel,this.okTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      contentPadding: EdgeInsets.all(2.h),
      content: Text(content!,
          style: TextStyle(fontSize: 12.sp)),
      actions: [
        TextButton(
           onPressed: okTap,
            child: Text(okLabel!,
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(cancelLabel!,
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
      ],
    );
  }
}
