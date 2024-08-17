import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localapp/component/customFeild.dart';

openLogInDialog(BuildContext context) async {
  final style = TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey.shade800,
  );
  showDialog(
      context: context,
      builder: (context) => AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: Colors.grey.shade800,
            width: 2
          )
        ),

            // contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
            insetPadding: EdgeInsets.symmetric(horizontal: 20),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                Text(
                  "For us to show you relevant information, we need to know you better.",
                  style: style,
                ),
                const SizedBox(
                  height: 20,
                ),

                //
                Text(
                  "Your name",
                  style: style,
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomField(
                    hintText: "Type Your Name here",
                    controller: TextEditingController(),
                ),
                const SizedBox(
                  height: 20,
                ),

                //
                Text(
                  "10 digit Whatsapp Number",
                  style: style,
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomField(
                  inputType: TextInputType.number,
                    hintText: "10 digit Whatsapp Number",
                    controller: TextEditingController(),
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                //
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "This Whatsapp number will NOT be visible to other users in the app. it is solely used for creating your profile",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.blue.shade300,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                //
                SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey.shade900),
                            shape: MaterialStateProperty.resolveWith((states) =>
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)))),
                        onPressed: () {},
                        child: const Text("Submit")))
              ],
            ),
          ));
}
