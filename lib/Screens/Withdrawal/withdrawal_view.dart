import 'dart:convert';
import 'dart:developer';

import 'package:pricedot/Screens/Kyc/kycScreen.dart';
import 'package:pricedot/Services/api_services/apiConstants.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/designConfig.dart';
import 'package:pricedot/Widgets/nodatafound.dart';
import 'package:pricedot/Widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/Get_transaction_model.dart';
import '../../Models/HomeModel/lottery_list_model.dart';
import '../../Widgets/auth_custom_design.dart';
import '../../Widgets/button.dart';
import 'package:http/http.dart' as http;

import '../Dashboard/dashboard_view.dart';

class WithdrawalScreen extends StatefulWidget {
  WithdrawalScreen({Key? key, this.isFrom, this.gId, required this.isVerified})
      : super(key: key);
  final bool? isFrom;
  String? gId;
  final bool isVerified;

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  @override
  void initState() {
    super.initState();
    balanceUser();
  }

  String? userBalance, userId;
  balanceUser() async {
    userBalance = await SharedPre.getStringValue('balanceUser');
    userId = await SharedPre.getStringValue('userId');
    setState(() {
      getWalletBallace();
    });
  }

  String? wallet;
  String fee='';
  getWalletBallace() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=dc01298267f1df677d56b79b00289958a862e530'
    };
    var request = http.Request(
        'POST', Uri.parse('${baseUrl}Apicontroller/getWalletBalance'));
    request.body = json.encode({"user_id": userId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      setState(() {
        wallet = finalResult['wallet_balance'];
        fee = finalResult['convenience_fee'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  String selectedOption = "UPI";
  String selected = "Withdrawal";
  TextEditingController upiController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController unameController = TextEditingController();
  TextEditingController bnameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchAddressController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpace,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text("Wallet".tr,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showContent(),
            tabTop(),
            _currentIndex == 1 ? withdrawal() : withdrawalRequest()
          ],
        ),
      ),
    );
  }

  int _currentIndex = 1;
  tabTop() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                  // getNewListApi(1);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _currentIndex == 1
                      ? AppColors.secondary
                      : AppColors.secondary.withOpacity(0.2),
                  gradient: _currentIndex == 1
                      ? const LinearGradient(
                          colors: [AppColors.primary,AppColors.secondary],
                          // Define the colors
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        )
                      : const LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                          // Define the colors
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                ),
                height: 45,
                child: Center(
                  child: Text("Withdrawal".tr,
                      style: TextStyle(
                          color: _currentIndex == 1
                              ? AppColors.whit
                              : AppColors.fntClr,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                  getTransactionApi();
                  // getNewListApi(3);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 2
                      ? AppColors.secondary
                      : AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  gradient: _currentIndex == 2
                      ? const LinearGradient(
                    colors: [AppColors.primary,AppColors.secondary],
                          // Define the colors
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        )
                      : LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                          // Define the colors
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                ),
                // width: 120,
                height: 45,
                child: Center(
                  child: Text(
                    "Withdrawal List".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _currentIndex == 2
                            ? AppColors.whit
                            : AppColors.fntClr,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  withdrawal() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Payment Method'.tr,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.fntClr),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        value: 'UPI',
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                          });
                        },
                      ),
                      Text(
                        'UPI'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // const SizedBox(width: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        value: 'Bank Details',
                        groupValue: selectedOption,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                          });
                        },
                      ),
                      Text(
                        'Bank Details'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Text("${fee}% convenience fee will be deducted at the time of withdraw"),
              const SizedBox(height: 20.0),
              if (selectedOption == 'UPI')
                Form(
                  key: _formKey1,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.fntClr),
                              hintText: 'Enter Amount'.tr),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: upiController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            hintText: 'Enter UPI ID'.tr,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.fntClr),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter UPI ID'.tr;
                            }
                            if (!RegExp(r'^[a-z||A-Z||0-9||.]+@[a-z]')
                                .hasMatch(value)) {
                              return 'Please enter valid UPI ID'.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      // const SizedBox(height: 15),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(7),
                      //     color: Colors.white,
                      //   ),
                      //   child: TextFormField(
                      //     keyboardType: TextInputType.name,
                      //     controller: unameController,
                      //     decoration: const InputDecoration(
                      //         contentPadding: EdgeInsets.all(8),
                      //         counterText: "",
                      //         border: InputBorder.none,
                      //         hintStyle:
                      //             TextStyle(fontWeight: FontWeight.normal),
                      //         hintText: 'Enter Name'),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter name';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              if (selectedOption == 'Bank Details')
                Form(
                  key: _formKey2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          onChanged: (value) {
                            if (double.parse(amountController.text) > 10000) {
                              Fluttertoast.showToast(msg: "TDS".tr);
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.fntClr),
                              hintText: 'Enter Amount'.tr),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      // const SizedBox(height: 15),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(7),
                      //     color: Colors.white,
                      //   ),
                      //   child: TextFormField(
                      //     controller: nameController,
                      //     decoration: const InputDecoration(
                      //         contentPadding: EdgeInsets.all(8),
                      //         border: InputBorder.none,
                      //         hintStyle:
                      //             TextStyle(fontWeight: FontWeight.normal),
                      //         hintText: 'Enter Account Holder Name'),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter account holder name';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: bnameController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              counterText: "",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.fntClr),
                              hintText: 'Enter Account Holder Name'.tr),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Account Holder Name'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: accountNumberController,
                          maxLength: 18,
                          decoration: InputDecoration(
                              counterText: "",
                              contentPadding: EdgeInsets.all(8),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.fntClr),
                              hintText: 'Enter Account Number'.tr),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter account number'.tr;
                            }
                            if (value.length < 9) {
                              return 'Please enter valid account number'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: bankNameController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.fntClr),
                              hintText: 'Enter Bank Name'.tr),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter bank name'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: branchAddressController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.fntClr),
                              hintText: 'Enter Branch Address'.tr),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter branch address'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: ifscController,
                          maxLength: 11,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Z0-9]'))
                          ],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.all(8),
                            hintText: 'Enter IFSC Code'.tr,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.fntClr),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter IFSC Code'.tr;
                            } else if (value.length < 11) {
                              return 'Please enter valid IFSC Code'.tr;
                            }
                            return null;
                          },
                        ),
                      ),

                      // Add more TextFormField widgets for other bank details here
                    ],
                  ),
                ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: InkWell(
                    onTap: () {
                      // if (widget.isVerified) {
                        if (selectedOption == 'UPI') {
                          if (_formKey1.currentState!.validate()) {
                            getWithdrawApi();
                          }
                          // makeWithdrawRequest();
                        } else if (selectedOption == 'Bank Details') {
                          if (_formKey2.currentState!.validate()) {
                            getWithdrawApi();
                          }
                        }
                      // } else {
                      //   Fluttertoast.showToast(
                      //       msg:
                      //           "Please Verify Your Account with KYC to proceed."
                      //               .tr);
                      //   Future.delayed(Duration(seconds: 2))
                      //       .then((value) => Navigator.pushReplacement(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => KycScreen(
                      //               adb: '',
                      //               adf: '',
                      //               pan: '',
                      //             ),
                      //           )));
                      // }
                    },
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary,AppColors.secondary],
                          // Define the colors
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Withdraw".tr,
                                  style: const TextStyle(
                                    color: AppColors.whit,
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              // AppButton1(
              //   title: 'Withdrawal',

              // )
            ],
          ),
        ),
      ],
    );
  }

  withdrawalRequest() {
    return getTransactionModel == null
        ? Center(child: CircularProgressIndicator(color: AppColors.primary))
        : getTransactionModel!.withdrawdata!.isEmpty
            ? Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .1,
                ),
                child: NoDataFound())
            : Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: ListView.builder(
                    itemCount: getTransactionModel?.withdrawdata?.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getTransactionModel?.withdrawdata?[i]
                                                .paymentMethod ==
                                            "2"
                                        ? Text(
                                            "UPI",
                                          )
                                        : Text("Bank"),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                        "₹ ${getTransactionModel?.withdrawdata?[i].requestAmount}"),
                                    Text(
                                        "Transaction Id: ${getTransactionModel?.withdrawdata?[i].requestNumber}"),
                                    Text(
                                        "Remark: ${getTransactionModel?.withdrawdata?[i].remark}"),
                                  ],
                                ),
                                getStatus(getTransactionModel
                                        ?.withdrawdata?[i].requestStatus
                                        .toString() ??
                                    '')
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
  }

  Widget getStatus(String status) {
    switch (status) {
      case '0':
        return Row(
          children: [
            Text(
              "Pending",
              style: TextStyle(color: Colors.orange),
            )
          ],
        );
      case '2':
        return Row(
          children: [
            Text(
              "Accepted",
              style: TextStyle(color: Colors.green),
            )
          ],
        );
      case '1':
        return Row(
          children: [
            Text(
              "Declined",
              style: TextStyle(color: Colors.red),
            )
          ],
        );

      default:
        return Row(
          children: [
            Text(
              "Pending",
              style: TextStyle(color: Colors.orange),
            )
          ],
        );
    }
  }

  Future<void> makeWithdrawRequest() async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${baseUrl}/init_bank_payout?type=${selectedOption == 'UPI' ? 'upi' : 'bank'}&account_number=${selectedOption == 'UPI' ? upiController.text : accountNumberController.text}&account_ifsc=${selectedOption == 'UPI' ? '' : ifscController.text}&bankname=${selectedOption == 'UPI' ? '' : bankNameController.text}&confirm_acc_number=${selectedOption == 'UPI' ? '' : accountNumberController.text}&requesttype=&beneficiary_name=${selectedOption == 'UPI' ? numberController.text : bnameController.text}&amount=${amountController.text}&narration=sfhjkhfjkd&transaction_id=${DateTime.now().hashCode}'));

      http.StreamedResponse response = await request.send();
      var json = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: json['message'].toString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      throw Exception(e);
    }
  }

  bool isLoading = false;
  getWithdrawApi() async {
    setState(() {
      isLoading = true;
    });
    var request = http.Request('POST',
        Uri.parse('$baseUrl1/Apicontroller/apiUserWithdrawFundRequest'));
    request.body = json.encode({
      "user_id": userId,
      "request_amount": amountController.text,
      "request_number": numberController.text,
      "payment_method": selectedOption == 'UPI' ? 2 : 1,
      "upi_id": selectedOption == 'UPI' ? upiController.text : "",
      "bank_name":
          selectedOption == 'Bank Details' ? bankNameController.text : "",
      "branch_address":
          selectedOption == 'Bank Details' ? branchAddressController.text : "",
      "ac_holder_name":
          selectedOption == 'UPI' ? unameController.text : bnameController.text,
      "ac_number":
          selectedOption == 'Bank Details' ? accountNumberController.text : "",
      "ifsc_code": selectedOption == 'Bank Details' ? ifscController.text : "",
    });
    print(request.body.toString());
    http.StreamedResponse response = await request.send();
    var result = await response.stream.bytesToString();
    var finalResult = jsonDecode(result);
    if (response.statusCode == 200) {
      if (finalResult['status'] == true) {
        await getWalletBallace();
        Fluttertoast.showToast(msg: "${finalResult['msg']}");
        setState(() {
          isLoading = false;
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DashBoardScreen(),
        //   ),
        // );
      } else {
        Fluttertoast.showToast(msg: "${finalResult['msg']}");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "${finalResult['msg']}");
      setState(() {
        isLoading = false;
      });
      print(response.reasonPhrase);
    }
  }

  LotteryListModel? lotteryDetailsModel;

  StateSetter? dialogState;
  TextEditingController amtC = TextEditingController();
  TextEditingController msgC = TextEditingController();
  ScrollController controller = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  showContent() {
    return Container(
      color: AppColors.secondary1.withOpacity(0.1),
      width: double.infinity,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: MediaQuery.of(context).size.height * .13,
                child: Image.asset(
                  "assets/images/wallet2.png",
                ),
              ),
              Text(
                'Current Balance'.tr,
                style: TextStyle(
                    color: AppColors.fntClr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fugazone'),
              ),
              wallet == null
                  ? ShimmerWidget()
                  : Text(
                      "₹${wallet}",
                      style: TextStyle(
                          color: AppColors.fntClr,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  GetTransactionModel? getTransactionModel;
  // getTransactionApi() async {
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Cookie': 'ci_session=18afbdd33b04ace40a80944d83e9e23e3ab91c3e'
  //   };
  //   var request = http.Request('POST', Uri.parse('$baseUrl1/Apicontroller/apiUserWithdrawTransactionHistory'));
  //   request.body = json.encode({
  //     "user_id":userId
  //   });
  //   print('_____request.body_____${request.body}_________');
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     var result = await response.stream.bytesToString();
  //     var finalResult  = GetTransactionModel.fromJson(json.decode(result));
  //     Fluttertoast.showToast(msg: "${finalResult.msg}");
  //     setState(() {
  //       getTransactionModel = finalResult;
  //     });
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }

  getTransactionApi() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=329e84d8baf5bbe6fc18f412bda3e26574156d56'
    };
    var request = http.Request('POST',
        Uri.parse('$baseUrl1/Apicontroller/apiUserWithdrawTransactionHistory'));
    request.body = json.encode({"user_id": userId});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetTransactionModel.fromJson(json.decode(result));
      log(result.toString());
      // Fluttertoast.showToast(msg: "${finalResult.msg}");
      setState(() {
        getTransactionModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
