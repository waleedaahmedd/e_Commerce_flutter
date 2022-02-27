import 'package:b2connect_flutter/model/services/http_service.dart';
import 'package:b2connect_flutter/view/widgets/eid_conirmation_bottom_sheet.dart';
import 'package:b2connect_flutter/view_model/providers/Repository/repository_pattern.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

import '../../model/models/userEmiratesData.dart';
import '../../model/services/util_service.dart';
import '../../model/utils/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_ocr_plugin/simple_ocr_plugin.dart';

class ScannerProvider with ChangeNotifier {
  UserEmiratesData userEmiratesData = UserEmiratesData();

  late bool scanResult;
  bool isScanBusy = false;
  int _cardType = 1;
  int cardFace = 1;
  BuildContext? _context;
  CameraController? controller;
  var clipSize;
  var utilService = locator<UtilService>();
  var recognisedText;
  late List<String> dateResult;
  late List<String> result;
  Repository? http = locator<HttpService>();

  setCardFace(int value) {
    this.cardFace = value;
    notifyListeners();
  }

  setContext(BuildContext value) {
    this._context = value;
    notifyListeners();
  }

  setCardType(int value) {
    this._cardType = value;
    notifyListeners();
  }

  setScanBusy(bool value) {
    this.isScanBusy = value;
    notifyListeners();
  }

  setController(CameraController value) {
    this.controller = value;
    notifyListeners();
  }

  Future<dynamic> sendEmiratesData() async {
    var emiratesId = userEmiratesData.emiratesId;
    var emiratesName = userEmiratesData.emiratesName;
    var emiratesBirthday = userEmiratesData.emiratesBirthday;
    var emiratesNationality = userEmiratesData.emiratesNationality;
    var emiratesGender = userEmiratesData.emiratesGender;
    var emiratesExpiry = userEmiratesData.emiratesExpiry;

    final birthDate =
        await convertDateToTimeStamp(emiratesBirthday!, 'birthDate');
    final expiryDate =
        await convertDateToTimeStamp(emiratesExpiry!, 'expiryDate');
    try {
      var response = await http!.sendEmiratesData(
          emiratesName!,
          emiratesGender!,
          birthDate,
          emiratesNationality!,
          emiratesId!,
          expiryDate);

      if (response.statusCode == 200) {
        //this._cardFace = 1;
        // EasyLoading.showSuccess('Verified Successfully');
        //  utilService.showToast('Sending data successfully');
        return EasyLoading.showSuccess('Verified Successfully');
      } else {
        EasyLoading.showError('Please ReCheck Your Scanning Result');
        //navigationService.closeScreen();
        return null;
      }
    } catch (e) {
      EasyLoading.showError('Please ReCheck Your Scanning Result');
    }
  }

  Future<void> scanCard(String? text) async {
    recognisedText = text;

    result = text!.split('\n');

    print(result);

    if (_cardType == 2 && cardFace == 2) {
      final birthDateIndex =
          result.indexWhere((element) => element.contains('Date of Birth'));

      final List<String> dateOfBirth = getSubString("Date of Birth", result[birthDateIndex]).split(" ");
      this.userEmiratesData.emiratesBirthday =  dateOfBirth[0];

      final expiryDateIndex =
          result.indexWhere((element) => element.contains('Expiry Date'));
      this.userEmiratesData.emiratesExpiry = result[expiryDateIndex + 1];

      final genderIndex =
          result.indexWhere((element) => element.contains('Sex'));
      result[genderIndex].contains('F')
          ? this.userEmiratesData.emiratesGender = 'Female'
          : this.userEmiratesData.emiratesGender = 'Male';

      //utilService.showToast('Scanned Successfully');
      this.setCardFace(1);
      this.setCardType(1);
      this.controller!.stopImageStream();
      confirmEidBottomSheet();

      setScanBusy(false);
    } else if (_cardType == 2 && cardFace == 1) {
      final idIndex =
          result.indexWhere((element) => element.contains('ID Number'));
      this.userEmiratesData.emiratesId = result[idIndex + 1];

      final nameIndex =
          result.indexWhere((element) => element.contains('Name'));
      this.userEmiratesData.emiratesName =
          getSubString("Name", result[nameIndex]);

      final nationalityIndex =
          result.indexWhere((element) => element.contains('Nationality'));
      this.userEmiratesData.emiratesNationality =
          getSubString("Nationality", result[nationalityIndex]);
      utilService.showToast('Kindly Flip Your Card');
      this.setCardFace(2);
      this.setCardType(2);
      setScanBusy(false);
    } else {
      final idIndex =
          result.indexWhere((element) => element.contains('ID Number'));
      this.userEmiratesData.emiratesId = result[idIndex + 1];

      final nameIndex =
          result.indexWhere((element) => element.contains('Name'));
      this.userEmiratesData.emiratesName =
          getSubString("Name", result[nameIndex]);

      final nationalityIndex =
          result.indexWhere((element) => element.contains('Nationality'));
      this.userEmiratesData.emiratesNationality =
          getSubString("Nationality", result[nationalityIndex]);

      final birthDateIndex =
          result.indexWhere((element) => element.contains('Date of Birth'));
      this.userEmiratesData.emiratesBirthday = result[birthDateIndex + 1];

      final expiryDateIndex =
          result.indexWhere((element) => element.contains('Expiry Date'));
      this.userEmiratesData.emiratesExpiry = result[expiryDateIndex + 1];

      final genderIndex =
          result.indexWhere((element) => element.contains('Sex'));
      result[genderIndex].contains('F')
          ? this.userEmiratesData.emiratesGender = 'Female'
          : result[genderIndex+1].contains('F')?this.userEmiratesData.emiratesGender = 'Female': this.userEmiratesData.emiratesGender = 'Male';

     // utilService.showToast('Scanned Successfully');
      this.controller!.stopImageStream();
      setScanBusy(false);

      this.setCardFace(1);
      this.setCardType(1);
      confirmEidBottomSheet();

    }

    // utilService.showToast(result[0]);
  }

// for Android & IOS
  /*Future<void> scanImage(var file) async {
    try {
      String _resultString =
          await SimpleOcrPlugin.performOCR(file.path, delimiter: ' *** ');
      recognisedText = _resultString;
      print(_resultString);
      result = _resultString.split(' *** ');
    } catch (e) {
      utilService.showToast('No card found');
    }

    if (_cardFace == 1) {
      try {
        if (!recognisedText.contains('UNITED ARAB EMIRATES') &&
            !recognisedText.contains('United Arab Emirates')) {
          scanResult = false;
          return;
        } else if (recognisedText.contains('UNITED ARAB EMIRATES')) {
          if (!result[4].contains('784')) {
            scanResult = false;
            return;
          } else {
            scanResult = true;
            this.userEmiratesData.emiratesId = result[4];
            this.userEmiratesData.emiratesName =
                getSubString("Name", result[5]);
            await convertDateToTimeStamp(result[7].toString(), 'birthDate');
            birthDate = result[7].toString();
            await convertDateToTimeStamp(result[12].toString(), 'expiryDate');
            expiryDate = result[12].toString();
            this.userEmiratesData.emiratesNationality =
                getSubString("Nationality:", result[8]);
            if (!result[13].contains('Sex')) {
              result[14].contains('F')?
              this.userEmiratesData.emiratesGender = 'Female': result[14].contains('M')?this.userEmiratesData.emiratesGender = 'Male': this.userEmiratesData.emiratesGender ='';
            } else {
              result[13].contains('F')?
              this.userEmiratesData.emiratesGender = 'Female': result[13].contains('M')?this.userEmiratesData.emiratesGender = 'Male': this.userEmiratesData.emiratesGender ='';
            }
          }
        }
        else {
          if (!result[3].contains('784')) {
            scanResult = false;
            return;
          } else {
            scanResult = true;
            this.userEmiratesData.emiratesId = result[3];
            this.userEmiratesData.emiratesName =
                getSubString("Name", result[4]);
            if (!result[5].contains('Nationality')) {
              List<String> nationality = result[6].split('"');
              this.userEmiratesData.emiratesNationality =
                  getSubString("Nationality:", nationality [0]);
              nationality.clear();
            } else {
              List<String> nationality = result[5].split('"');
              this.userEmiratesData.emiratesNationality =
                  getSubString("Nationality:", nationality [0]);
              nationality.clear();
            }
          }
        }
      } catch (e) {
        scanResult = false;
        utilService.showToast('Please insert front side of your card');
        return;
      }
    } else if (_cardFace == 2) {
      if (!recognisedText.contains('Sex') &&
          !recognisedText.contains('Employer')) {
        scanResult = false;
        utilService.showToast('Please insert back side of your card');
        return;
      } else if (recognisedText.contains('Sex') &&
          recognisedText.contains('UNITED ARAB EMIRATES')) {
        scanResult = false;
        utilService.showToast('Please insert back side of your card');
        return;
      } else if (recognisedText.contains('Sex')) {
        try {
          scanResult = true;
          if (!result[2].contains('Date of Birth')) {
            List<String> dateOfBirth = result[1].split(" ");
            convertDateToTimeStamp(dateOfBirth[3].toString(), 'birthDate');
            birthDate = dateOfBirth[3].toString();
          } else {
            convertDateToTimeStamp(result[3].toString(), 'birthDate');
            birthDate = result[3].toString();
          }
          if (!result[4].contains('Expiry')) {
            convertDateToTimeStamp(result[3].toString(), 'expiryDate');
            expiryDate = result[3].toString();
          } else {
            convertDateToTimeStamp(result[6].toString(), 'expiryDate');
            expiryDate = result[6].toString();
          }

          if (!result[1].contains('Sex')) {
            result[0].contains('F')?
            this.userEmiratesData.emiratesGender = 'Female': result[0].contains('M')?this.userEmiratesData.emiratesGender = 'Male': this.userEmiratesData.emiratesGender ='';
          */ /*  List<String> sex = result[0].split(" ");
            this.userEmiratesData.emiratesGender = sex[5];*/ /*
          } else {
            result[1].contains('F')?
            this.userEmiratesData.emiratesGender = 'Female': result[1].contains('M')?this.userEmiratesData.emiratesGender = 'Male': this.userEmiratesData.emiratesGender ='';
           // this.userEmiratesData.emiratesGender = result[1];
          }
        } catch (e) {
          scanResult = false;
          utilService.showToast('Please insert back side of your card');
          return;
        }
      } else {
        scanResult = true;
        return;
      }
    }
  }*/

  String getSubString(title, value) {
    return value.substring((title.length + 1));
  }

  Future<int> convertDateToTimeStamp(String date, String dateType) async {
    dateResult = date.split('/');
    print(dateResult[2].toString());
    final DateTime date2 = DateTime(int.parse(dateResult[2]),
        int.parse(dateResult[1]), int.parse(dateResult[0]));
    final timestamp = date2.millisecondsSinceEpoch;
    if (dateType == 'birthDate') {
      final dateOfBirthTimeStamp = timestamp / 1000;
      return dateOfBirthTimeStamp.toInt();
    } else {
      final expiryTimeStamp = timestamp / 1000;
      return expiryTimeStamp.toInt();
    }
  }

  Future<String> scanText(CameraImage image) async {
    final GoogleVisionImageMetadata metadata = GoogleVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        planeData: image.planes
            .map((currentPlane) => GoogleVisionImagePlaneMetadata(
                bytesPerRow: currentPlane.bytesPerRow,
                height: currentPlane.height,
                width: currentPlane.width))
            .toList(),
        rotation: ImageRotation.rotation90);

    final GoogleVisionImage visionImage =
        GoogleVisionImage.fromBytes(image.planes[0].bytes, metadata);

    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    textRecognizer.close();

    return visionText.text!;
  }

  void checkCardFaceAndType(CameraImage image) {
    /*if (this.cardFace == 2 &&
        this.cardType == 1) {
      this.controller!.stopImageStream();
      confirmEidBottomSheet(context);
      return;
    }*/
    this.setScanBusy(true);


    if (this.cardFace == 2 && this._cardType == 2) {
      scanText(image).then((visionText) {
        if (visionText.contains('Date of Birth') &&
            visionText.contains('Expiry Date')) {
          //this.setCardFace(1);
          //this.setCardType(1);
          this.scanCard(visionText);
        //  confirmEidBottomSheet();
         // this.controller!.stopImageStream();
        //  utilService.showToast('card 2 face 2');
        } else {
          print("non");
          this.setScanBusy(false);
        }
      });
    } else {
      scanText(image).then((visionText) {
        if (visionText.contains('UNITED ARAB EMIRATES') &&
            visionText.contains('Name') &&
            visionText.contains('Date of Birth') &&
            visionText.contains('Nationality') &&
            visionText.contains('Expiry Date') &&
            visionText.contains('ID Number')) {
          this.scanCard(visionText);
        } else if (visionText.contains('United Arab Emirates') &&
            visionText.contains('Name') &&
            visionText.contains('Nationality') &&
            visionText.contains('ID Number')) {
         // utilService.showToast('card 2 face 1');

          this.setCardFace(1);
          this.setCardType(2);
          this.scanCard(visionText);
        } else {
          print("non");
          this.isScanBusy = false;
        }
      });
    }
  }

  void confirmEidBottomSheet() {
    EasyLoading.dismiss();
    showModalBottomSheet(
      isDismissible: false,

      enableDrag: false,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      context: _context!,
      builder: (BuildContext bc) {
        return EidConfirmationBottomSheet();
      },
    );
  }
}
