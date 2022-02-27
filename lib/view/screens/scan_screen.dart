import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/services/util_service.dart';
import 'package:b2connect_flutter/view/widgets/eid_conirmation_bottom_sheet.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../model/services/navigation_service.dart';
import '../../model/utils/service_locator.dart';
import '../../view/widgets/border_painter_widget.dart';
import '../../view/widgets/clip_widget.dart';
import '../../view/widgets/indicator.dart';
import '../../view_model/providers/scanner_provider.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen(/*{
    required this.camera,
  }*/
      )
      : super();

  /*final CameraDescription camera;*/

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  //var navigationService = locator<NavigationService>();
  late CameraController _controller;
  late Future<CameraController> _initializeControllerFuture;
  //var _scanId;
  CameraImage? image;
  Timer? timer;

//  bool _isScanBusy = false;
  var utilService = locator<UtilService>();
  final _imagePicker = ImagePicker();

  late final _size;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _size = MediaQuery.of(context).size;
    });
    _initializeControllerFuture = startCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    //_controller.stopImageStream();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
        builder: (context, i, _) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<CameraController>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        IndicatorWidget("2"),
                        SizedBox(
                          height: 10.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_outlined,
                                color: Colors.white, size: 24),
                          ),
                        ),
                       Container(
                         child: CameraPreview(_controller),
                       )
                       /* snapshot.hasData
                            ? _size.width > 600
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 80.0, right: 80.0),
                                    child: cameraView())
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1.0, right: 1.0),
                                    child: cameraView())
                            : Container(
                                height: 100,
                                color: Colors.red,
                              ),*/
                      ],
                    ),
                    Center(
                      child: i.isScanBusy ? Text('Searching for Emirates ID Card Please Wait...',style: TextStyle(color: Colors.white, fontSize: 18),):
                      Text('Processing ....',style: TextStyle(color: Colors.white, fontSize: 18),),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: i.cardFace == 1
                                ? Text(
                                    AppLocalizations.of(context)!
                                        .translate('front')!,
                                    style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!
                                        .translate('back_')!,
                                    style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text(
                            AppLocalizations.of(context)!.translate('desc')!,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.4),
                          ),
                        ),
                        /*Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          child: Center(
                            child: IconButton(
                                onPressed: () async {
                                  EasyLoading.show(status: 'Scanning...');
                                  // Take the Picture in a try / catch block. If anything goes wrong,
                                  // catch the error.
                                  try {
                                    // Ensure that the camera is initialized.
                                    await _initializeControllerFuture;
                                    // Attempt to take a picture and get the file `image`
                                    // where it was saved.
                                    final image =
                                        await _controller.takePicture();

                                    print(image.length());

                                    //  _cropImage(image.path,image.path, 74, 135, 359 - 74, 420 - 135);

                                    _cropImage(context, image.path, image.path,
                                        10, 20);
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                    print(e);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 60,
                                )),
                          ),
                        )*/
                      ],
                    ),
                  ],
                ),
              ),
            );
            // CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );});
  }

  /*Widget cameraView() {
    return Stack(
      children: [
        Center(
          child:
              ClipPath(clipper: Clip(_size), child: CameraPreview(_controller)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.5),
          child: CustomPaint(
            painter: BorderPainter(),
            child: Container(
              height: _size.height / 3.7,
            ),
          ),
        ),
      ],
    );
  }*/

  Future<CameraController> startCamera() async {
    var cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller.initialize();

    Provider.of<ScannerProvider>(context, listen: false).setController(_controller);
    Provider.of<ScannerProvider>(context, listen: false).setContext(context);

    _controller.startImageStream((image) {
      if (Provider.of<ScannerProvider>(context, listen: false).isScanBusy) {
        // print("1.5 -------- isScanBusy, skipping...");
        return;
      }

      Provider.of<ScannerProvider>(context, listen: false).checkCardFaceAndType(image);



      /*await Provider.of<ScannerProvider>(context, listen: false)
          .scanImage(visionImage);*/
    });
    // takePicture();
    /* });*/
    return _controller;
  }

  /*Future<void> takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      _cropImage(context, image.path, image.path, 10, 20);
    } catch (e) {
      print(e);
    }
  }*/

  /*Future<void> _cropImage(
      context, String filePath, String destPath, int x, int y) async {
    img.Image _image = decodeJpg(await File(filePath).readAsBytes());
    img.Image _cropped =
        copyCrop(_image, x, y, _image.width, _image.width ~/ 1.5);
    await File(destPath).writeAsBytes(encodeJpg(_cropped));

    if (Platform.isAndroid || Platform.isIOS) {
      await Provider.of<ScannerProvider>(context, listen: false)
          .scanImage(destPath);
    }
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CameraSliderScreen(destPath, _size)))
        .then((value) {
      setState(() {
        _scanId = Provider.of<ScannerProvider>(context, listen: false).scanId;
      });
    });
    EasyLoading.dismiss();
  }*/




}
