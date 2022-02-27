import 'package:b2connect_flutter/view/widgets/custom_buttons/gradiant_color_button.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:b2connect_flutter/view_model/providers/scanner_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'custom_buttons/tinted_color_button.dart';

class EidConfirmationBottomSheet extends StatelessWidget {
  const EidConfirmationBottomSheet() : super();

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(builder: (context, i, _) {
      return WillPopScope(

        onWillPop: () {
          var count = 0;
          Navigator.popUntil(context, (route) {
            i.setScanBusy(true);
            return count++ == 2;
          });          return Future.value(false);
        },
        child: Container(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Confirm Your Emirates Card Details",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lexend',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      thickness: 1,
                      height: 2,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Name: ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${i.userEmiratesData.emiratesName}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Emirates Id: ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${i.userEmiratesData.emiratesId}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Nationality: ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${i.userEmiratesData.emiratesNationality}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Gender: ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${i.userEmiratesData.emiratesGender}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Date of Birth: ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${i.userEmiratesData.emiratesBirthday}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Expiry Date: ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${i.userEmiratesData.emiratesExpiry}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CustomButton2(
                         /*   height: 50,
                              width: 500,*/
                              txt: 'Re-Scan',
                              onTap: () async {
                                i.controller!.stopImageStream();
                                i.setScanBusy(false);
                              //  EasyLoading.show(status: 'Saving Emirates ID...');
                                var count = 0;
/*
                                await Provider.of<ScannerProvider>(context, listen: false)
                                    .sendEmiratesData(context);
                                await Provider.of<AuthProvider>(context, listen: false)
                                    .callUserInfo();*/
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CustomButton(
                              height: 62,
                              width: 500,
                              text: 'Submit',
                              onPressed: () async {
                                i.controller!.stopImageStream();
                                i.setScanBusy(false);
                                EasyLoading.show(status: 'Saving Emirates ID...');
                                var count = 0;

                                await Provider.of<ScannerProvider>(context, listen: false)
                                    .sendEmiratesData();
                                await Provider.of<AuthProvider>(context, listen: false)
                                    .callUserInfo();
                                Navigator.popUntil(context, (route) {
                                  return count++ == 3;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
