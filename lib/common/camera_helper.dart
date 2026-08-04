import 'dart:io';
import 'dart:typed_data';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../common/app_colors.dart';

abstract class CameraOnCompleteListener {
  void onSuccessFile(String file, String fileType,int code);
  void onSuccessVideo(String selectedUrl, Uint8List? thumbnail);
}

class CameraHelper {
  int code = 0;
  final picker = ImagePicker();
  BuildContext context = Get.context!;
  CropAspectRatioPreset? cropAspectRatio;
  late CameraOnCompleteListener callback;

  CameraHelper(this.callback);

  void setCropping(CropAspectRatioPreset cropAspectRatio) {
    this.cropAspectRatio = cropAspectRatio;
  }

  void openAttachmentDialog() async {
    if (await isStorageEnabled()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'docx',
          'xlsx',
          'pptx',
          'doc',
          'xls',
          'ppt',
          'txt',
        ],
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        debugPrint(file.path);
        callback.onSuccessFile(file.path, "document",code);
      } else {
        // user canceled the picker
      }
    }
  }

  void openImagePicker(int code) {
    this.code = code;
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder:
          (BuildContext bc) => GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 55),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColor.appTextColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Camera",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (await isCameraEnabled()) {
                            Navigator.pop(context);
                            cropAspectRatio != null
                                ? getImageWithCropping(ImageSource.camera,code)
                                : getImageWithoutCropping(ImageSource.camera);
                          }
                        },
                      ),
                      const SizedBox(width: 60),
                      GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColor.appTextColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.image_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Gallery",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (await isStorageEnabled()) {
                            Navigator.pop(context);
                            cropAspectRatio != null
                                ? getImageWithCropping(ImageSource.gallery,code)
                                : getImageWithoutCropping(ImageSource.gallery);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusScopeNode());
            },
          ),
    );
  }

  Future<bool> openVideoPicker() async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder:
          (BuildContext bc) => GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColor.appTextColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Camera",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (await isCameraEnabled()) {
                            Navigator.pop(context);
                            getVideo(ImageSource.camera);
                          }
                        },
                      ),
                      const SizedBox(width: 60),
                      GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColor.blackColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.image_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Gallery",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (await isStorageEnabled()) {
                            Navigator.pop(context);
                            getVideo(ImageSource.gallery);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusScopeNode());
            },
          ),
    );
    return false;
  }

  Future<void> getVideo(ImageSource source, {isTrimming = true}) async {
    XFile? imageFile = await picker.pickVideo(
      source: source,
      maxDuration: const Duration(seconds: 10),
    );
    if (imageFile != null) {
      debugPrint("Selected video => ${imageFile.path}");
      String? result;
      if (source == ImageSource.camera) {
        result = imageFile.path;
      } else {
        result = imageFile.path;
        // if (isTrimming) {
        //   result = await Get.to(()=> VideoTrimmerView(file: File(imageFile.path)));
        // } else {
        //   result = imageFile.path;
        // }
      }
      debugPrint("pickVideoGallery $result");
      if (result != null) {
        final uint8List = await VideoThumbnail.thumbnailData(
          video: result,
          imageFormat: ImageFormat.PNG,
          maxWidth:
              256, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 60,
        );
        debugPrint("uint8List thumbnail $uint8List");
        if (uint8List != null) {
          XFile xFile = XFile.fromData(uint8List);

          debugPrint("Video Thumbnail ${xFile.path}");
          debugPrint("thumbnail $uint8List");
          callback.onSuccessVideo(result, uint8List);
        } else {
          debugPrint('No video selected.');
        }
      }
    } else {
      debugPrint('No video selected.');
    }
  }

  void openImagePickerNew() {
    showAdaptiveActionSheet(
      context: context,
      title: const Text("Choose Image"),
      isDismissible: true,
      actions: [
        BottomSheetAction(
          title: const Text(
            'Camera',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
          ),
          onPressed: (context) async {
            if (await isCameraEnabled()) {
              Navigator.pop(context);
              cropAspectRatio != null
                  ? getImageWithCropping(ImageSource.camera,code)
                  : getImageWithoutCropping(ImageSource.camera);
            }
          },
        ),
        BottomSheetAction(
          title: const Text(
            'Gallery',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
          ),
          onPressed: (context) async {
            if (await isStorageEnabled()) {
              Navigator.pop(context);
              cropAspectRatio != null
                  ? getImageWithCropping(ImageSource.gallery,code)
                  : getImageWithoutCropping(ImageSource.gallery);
            }
          },
        ),
      ],
      cancelAction: CancelAction(
        title: const Text(
          'Cancel',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
        ),
        onPressed: (BuildContext context) {
          Get.back();
        },
      ),
    );
  }

  Future getImageWithCropping(ImageSource imageSource,int code) async {
    this.code= code;
    XFile? imageFile = await picker.pickImage(source: imageSource);
    CroppedFile? croppedFile;
    if (imageFile != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(0xff6C63FF),
            aspectRatioPresets: [cropAspectRatio!],
            cropStyle: CropStyle.rectangle,
            toolbarWidgetColor: Colors.white,
            showCropGrid: true,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: "Cropper",
            cropStyle: CropStyle.rectangle,
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: false
          ),
        ],
      );
    }
    if (croppedFile != null) {
      callback.onSuccessFile(croppedFile.path, "image",code);
    } else {
      print('No image selected.');
    }
  }

  Future getImageWithoutCropping(ImageSource imageSource) async {
    XFile? imageFile = await picker.pickImage(source: imageSource);
    if (imageFile != null) {
      callback.onSuccessFile(imageFile.path, "image",code);
    } else {
      print('No image selected.');
    }
  }

  Future<bool> isCameraEnabled() async {
    return true;
    // var status = await Permission.camera.request();
    // print("status: " + status.toString());
    // if (status == PermissionStatus.permanentlyDenied) {
    //   Utils.showSnackBar(
    //       "Camera permission permanently denied, we are redirecting to you setting screen to enable permission");
    //   Future.delayed(const Duration(seconds: 4), () {
    //     openAppSettings();
    //   });
    //   return false;
    // } else if (status == PermissionStatus.granted) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Future<bool> isStorageEnabled() async {
    return true;
    // var status;
    // if (Platform.isAndroid) {
    //   status = await Permission.storage.request();
    // } else {
    //   status = await Permission.photos.request();
    // }
    // print("status: " + status.toString());
    // if (Platform.isAndroid) {
    //   if (status == PermissionStatus.permanentlyDenied) {
    //     Utils.showSnackBar(
    //         "Storage permission permanently denied, we are redirecting to you setting screen to enable permission");
    //     Future.delayed(const Duration(seconds: 4), () {
    //       openAppSettings();
    //     });
    //     return false;
    //   } else if (status == PermissionStatus.granted)
    //     return true;
    //   else
    //     return false;
    // } else {
    //   if (status == PermissionStatus.permanentlyDenied) {
    //     Utils.showSnackBar(
    //         "Photos permission permanently denied, we are redirecting to you setting screen to enable permission");
    //     Future.delayed(const Duration(seconds: 4), () {
    //       openAppSettings();
    //     });
    //     return false;
    //   } else if (status == PermissionStatus.granted ||
    //       status == PermissionStatus.limited)
    //     return true;
    //   else
    //     return false;
    // }
  }
}
