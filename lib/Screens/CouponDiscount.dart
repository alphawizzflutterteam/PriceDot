import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pricedot/Models/PromoCodeModel.dart';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:pricedot/Services/api_services/apiConstants.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/nodatafound.dart';

import '../Widgets/designConfig.dart';

class CouponDiscountScreen extends StatefulWidget {
  const CouponDiscountScreen({super.key,required this.entryFee});
  final String entryFee;
  @override
  State<CouponDiscountScreen> createState() => _CouponDiscountScreenState();
}

class _CouponDiscountScreenState extends State<CouponDiscountScreen> {
  bool isLoading=false;
  PromoCodeModel? promoCodeModel;
  List<PromoData> promoCodes=[];
  Future<void> getPromo()async{
    try{
      promoCodes.clear();
      setState(() {
        isLoading=true;
      });
      var request = http.Request('GET', Uri.parse('${baseUrl}/Apicontroller/get_promo_list'));
      http.StreamedResponse response = await request.send();
      var json=jsonDecode(await response.stream.bytesToString());
      print(json);
      if (response.statusCode == 200) {
        promoCodeModel=PromoCodeModel.fromJson(json);
        promoCodes=promoCodeModel?.data??[];
        setState(() {
          isLoading=false;
        });
      }
      else {
        setState(() {
          isLoading=false;
        });
        print(response.reasonPhrase);
      }

    }catch(e){
      throw Exception(e);
    }
  }
  Future<void> applyPromo(
  {required String promoCode}
      )async{
    try{
      var headers = {
        'Cookie': 'ci_session=0bb61ef80f474e4d82e0b72293485a64f98c1331'
      };
      var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}/Apicontroller/validate_promo_code'));
      request.fields.addAll({
        'promo_code': promoCode,
        'user_id': CURR_USR.toString(),
        'final_total': widget.entryFee,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var json=jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        if(!json['error']){
          showDialog(context: context, builder: (ctx)  {
            Future.delayed(Duration(seconds: 2)).then((value)
            {Navigator.pop(ctx);
            Navigator.pop(context,{'discAmt':json['final_discount'],'code':json['code'],'finalTotal':json['final_total']});

            });
            return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded,color: AppColors.primary,size: 150),
                  const Divider(color: Colors.transparent),
                  Text("Coupon Applied Successfully",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );});
        }else{
          showDialog(context: context, builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Icon(Icons.error_outline_rounded,color: AppColors.primary,size: 150),
                  const Divider(color: Colors.transparent),
                  Text(json['message'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),);
        }
      }
      else {
        print(response.reasonPhrase);
      }

    }catch(e){
      throw Exception(e);
    }
  }

 late Future my;
  @override
  void initState() {
    // TODO: implement initState
    print("UserID: ${CURR_USR}");
    my=getPromo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpace,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text("Coupons".tr,
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: my,
          builder: (context,s) {

            if(s.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
           else{
              return promoCodes.length==0?Center(child: NoDataFound()) :ListView.builder(
                itemCount: promoCodes.length,
                itemBuilder: (context, index) => Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 16),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.whit,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.greyColor,
                          blurRadius: 5,
                          offset: Offset(1, 1)),
                    ],
                  ),
                  child: Row(

                    children: [
                      Container(
                        width: 25,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(

                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.secondary,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            )
                        ),
                        child: RotatedBox(
                            quarterTurns: 3,
                            child: Text("#"
                                "${promoCodes[index].promoCode}",style: TextStyle(color: AppColors.whit,fontWeight: FontWeight.bold),)),
                      ),
                      VerticalDivider(color: Colors.transparent,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              promoCodes[index].title.toString(),
                              style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            Row(
                              children: [
                                Text(
                                  "Expiry: ",
                                  style:
                                  TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(DateTime.parse(promoCodes[index].validTill.toString())),
                                  style:
                                  TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                applyPromo(promoCode: promoCodes[index].promoCode.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.secondary,
                                      ]
                                  ),
                                ),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      SizedBox.square(
                          dimension: MediaQuery.of(context).size.height * .12,
                          child: Image.asset("assets/icons/gift.png")),
                    ],
                  ),
                ),
              );
            }
          }
        ),
      ),
    );
  }
}
