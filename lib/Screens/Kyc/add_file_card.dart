import 'dart:io';

import 'package:pricedot/Utils/Colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddFileCard extends StatefulWidget {
  final String title;
  final ValueChanged<bool>? onChanged;
  final ValueChanged<File>? file;
  const AddFileCard(
      {super.key, required this.title, this.onChanged, required this.file});

  @override
  State<AddFileCard> createState() => _AddFileCardState();
}

class _AddFileCardState extends State<AddFileCard> {
  File? _image;

  Future<void> _pickFile() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 90,
    );
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: false),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile?.path != null) {
        setState(() {
          _image = File(croppedFile!.path);
          widget.file!(_image!);
        });
      }
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 90,
    );
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile?.path != null) {
        setState(() {
          _image = File(croppedFile!.path);
          widget.file!(_image!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: widget.forCamera ? _pickFromCamera : _pickFile,
      onTap: () async {
        var status = await [
          Permission.photos,
          Permission.storage,
        ].request();
        if (status[Permission.photos] == PermissionStatus.granted ||
            status[Permission.storage] == PermissionStatus.granted) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.photo_library,
                      ),
                      title: Text(
                        'Choose from Gallery'.tr,
                      ),
                      onTap: () {
                        _pickFile();
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.camera_alt,
                      ),
                      title: Text(
                        'Take a Picture'.tr,
                      ),
                      onTap: () {
                        _pickFromCamera();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          Fluttertoast.showToast(msg: 'Permission Denied by User!');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: Colors.white,
        ),
        width: double.infinity,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image == null)
                Center(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.fntClr),
                  ),
                ),
              if (_image != null)
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
