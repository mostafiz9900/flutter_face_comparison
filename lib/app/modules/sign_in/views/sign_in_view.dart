import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sign_in_controller.dart';
import 'dart:io' as io;
import 'package:flutter_face_api_beta/face_api.dart' as Regula;
import 'package:image_picker/image_picker.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignInView'),
        centerTitle: true,
      ),
      body: GetBuilder<SignInController>(builder: (_) {
        return Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
            width: double.infinity,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              createImage(_.img1.image, () => showAlertDialog(context, true)),
              createImage(_.img2.image, () => showAlertDialog(context, false)),
              Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 15)),
              createButton("Match", () => _.matchFaces()),
              createButton("Liveness", () => _.livenessImage()),
              createButton("Clear", () => _.clearResults()),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Similarity: ${_.similarity}",
                          style: const TextStyle(fontSize: 18)),
                      Container(margin: const EdgeInsets.fromLTRB(20, 0, 0, 0)),
                      Text("Liveness: ${_.liveness}",
                          style: const TextStyle(fontSize: 18))
                    ],
                  ))
            ]));
      }),
    );
  }

  Widget createImage(image, VoidCallback onPress) => Material(
          child: InkWell(
        onTap: onPress,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(height: 150, width: 150, image: image),
          ),
        ),
      ));
  Widget createButton(String text, VoidCallback onPress) => SizedBox(
        width: 250,
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
            ),
            onPressed: onPress,
            child: Text(text)),
      );
  showAlertDialog(BuildContext context, bool first) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: const Text("Select option"), actions: [
            // ignore: deprecated_member_use
            TextButton(
                child: const Text("Use gallery"),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then((value) => {
                            print(value?.path),
                            print("galary image"),
                            controller.setImage(
                                first,
                                io.File(value!.path).readAsBytesSync(),
                                Regula.ImageType.PRINTED)
                          });
                }),
            // ignore: deprecated_member_use
            TextButton(
                child: const Text("Use camera"),
                onPressed: () {
                  // ImagePicker()
                  //     .pickImage(
                  //         source: ImageSource.camera,
                  //         preferredCameraDevice: CameraDevice.front)
                  //     .then((value) => {
                  //           print(value?.path),
                  //           print("galary image"),
                  //           controller.setImage(
                  //               first,
                  //               io.File(value!.path).readAsBytesSync(),
                  //               Regula.ImageType.PRINTED)
                  //         });
                  Regula.FaceSDK.presentFaceCaptureActivity().then((result) => {
                        print('result present face capture $result'),
                        controller.setImage(
                            first,
                            base64Decode(Regula.FaceCaptureResponse.fromJson(
                                    json.decode(result))!
                                .image!
                                .bitmap!
                                .replaceAll("\n", "")),
                            Regula.ImageType.LIVE)
                      });

                  Navigator.pop(context);
                })
          ]));
}
