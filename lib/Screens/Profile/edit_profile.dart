import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:pricedot/Services/api_services/apiConstants.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pricedot/Widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pricedot/Widgets/designConfig.dart';

import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/get_profile_model.dart';
import '../../Utils/Colors.dart';
import '../../Widgets/auth_custom_design.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key, this.getProfileModel}) : super(key: key);
  final GetProfileModel? getProfileModel;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.getProfileModel?.profile?.userName ?? "";
    mobileController.text = widget.getProfileModel?.profile?.mobile ?? "";
    emailController.text = widget.getProfileModel?.profile?.email ?? "";
    addressController.text = widget.getProfileModel?.profile?.address ?? "";
    image = widget.getProfileModel?.profile?.image ?? '';
    print('_____nameController_____${nameController.text}_________');
    super.initState();

    referCode();
  }

  String? userId;
  referCode() async {
    userId = await SharedPre.getStringValue('userId');
  }

  String? image;
  final ImagePicker _picker = ImagePicker();
  bool isEditProfile = false;
  final key = GlobalKey<FormState>();
  File? imageFile;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Future<bool> showExitPopup1() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Center(child: Text('Select Image')),
          content: Row(
            // crossAxisAlignment: CrossAxisAlignment.s,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  getImage(ImageSource.camera, context, 1);
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(child: Text("Camera")),
                ),
              ),

              SizedBox(
                width: 15,
              ),

              InkWell(
                onTap: () {
                  getImageCmera(ImageSource.gallery, context, 1);
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(child: Text("Gallery")),
                ),
              )
              // ElevatedButton(
              //   onPressed: () {
              //
              //   },
              //   child: Text('Gallery'),
              // ),
            ],
          )),
    ); //if showDialouge had returned null, then return false
  }

  void requestPermission(BuildContext context, int i) async {
    print("okay");
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.mediaLibrary,
      Permission.storage,
    ].request();
    if (statuses[Permission.photos] == PermissionStatus.granted &&
        statuses[Permission.mediaLibrary] == PermissionStatus.granted) {
      getImage(ImageSource.gallery, context, 1);
    } else {
      getImageCmera(ImageSource.camera, context, 1);
    }
  }

  Future getImage(ImageSource source, BuildContext context, int i) async {
    var image = await ImagePicker().pickImage(source: source, imageQuality: 50);
    setState(() {
      imageFile = File(image!.path);
    });

    Navigator.pop(context);
  }

  Future getImageCmera(ImageSource source, BuildContext context, int i) async {
    var image = await ImagePicker().pickImage(source: source, imageQuality: 50);
    setState(() {
      imageFile = File(image!.path);
    });
    Navigator.pop(context);
  }

  void getCropImage(BuildContext context, int i, var image) async {
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );
    setState(() {
      if (i == 1) {
        imageFile = File(croppedFile!.path.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpace,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Edit Profile".tr,
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              // Top-left corner radius
              topRight: Radius.circular(30),
              // Top-right corner radius
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: key,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Stack(children: [
                    imageFile == null
                        ? SizedBox(
                            height: 110,
                            width: 110,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              elevation: 5,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    image!,
                                    fit: BoxFit.cover,
                                  )
                                  // Image.file(imageFile!,fit: BoxFit.fill,),
                                  ),
                            ),
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(imageFile ?? File(''),
                                    fit: BoxFit.fill)
                                // Image.file(imageFile!,fit: BoxFit.fill,),
                                ),
                          ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        // top: 30,
                        child: InkWell(
                          onTap: () {
                            showExitPopup1();
                            // showExitPopup(isFromProfile ?? false);
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: AppColors.bgColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.camera_enhance_outlined,
                                color: AppColors.primary,
                              )),
                        ))
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "Please enter name";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5, left: 10),
                          border: OutlineInputBorder(),
                          hintText: 'Enter Name'.tr),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: addressController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5, left: 10),
                          border: OutlineInputBorder(),
                          hintText: 'Enter Address'.tr),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      controller: mobileController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5, left: 10),
                          border: OutlineInputBorder(),
                          hintText: 'Enter Mobile'.tr),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter an email address'.tr;
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address'.tr;
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5, left: 10),
                          border: OutlineInputBorder(),
                          hintText: 'Enter Email'.tr),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (key.currentState!.validate()) {
                        updateProfile();
                      }
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          // Define the colors
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      child: Center(
                        child: isEditProfile == true
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Edit Profile".tr,
                                style: TextStyle(
                                  color: AppColors.whit,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                  // AppButton1(
                  //   title:
                  //       isEditProfile == true ? "please wait..." : "Edit Profile",
                  //   onTap: () {
                  //     updateProfile();
                  //   },
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateProfile() async {
    setState(() {
      isEditProfile = true;
    });

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl1/Apicontroller/apiProfileUpdate'));
    request.fields.addAll({
      'user_name': nameController.text,
      'email': emailController.text,
      'address': addressController.text,
      'user_id': userId.toString()
    });
    print('____request.fields______${request.fields}_________');
    if (imageFile != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image', imageFile?.path ?? ''));
    }
    http.StreamedResponse response = await request.send();
    var result = await response.stream.bytesToString();
    var finalResult = jsonDecode(result);
    log(result.toString());
    if (response.statusCode == 200) {
      // await getProfile();
      Fluttertoast.showToast(msg: "${finalResult['msg']}");
      setState(() {
        isEditProfile = false;
      });
      Navigator.pop(context, true);
    } else {
      setState(() {
        isEditProfile = false;
      });
      print(response.reasonPhrase);
    }
  }

  GetProfileModel? getProfileModel;

  getProfile() async {
    try {
      var request = http.Request(
          'POST', Uri.parse('$baseUrl1/Apicontroller/apiGetProfile'));
      request.body = json.encode({"user_id": userId.toString()});
      print(request.body);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print("here");
        var result = await response.stream.bytesToString();
        print("here1");
        var finalResult = GetProfileModel.fromJson(json.decode(result));
        print("here2");
        String getProfileModel = jsonEncode(finalResult);
        print("here3");
        SharedPre.setValue('profile', getProfileModel);
        var pro = await SharedPre.getStringValue('profile');
        print(jsonDecode(pro));
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, StackTrace) {
      print(StackTrace);
      throw Exception(e);
    }
  }
}
