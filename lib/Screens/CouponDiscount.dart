import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pricedot/Utils/Colors.dart';

import '../Widgets/designConfig.dart';

class CouponDiscountScreen extends StatefulWidget {
  const CouponDiscountScreen({super.key});

  @override
  State<CouponDiscountScreen> createState() => _CouponDiscountScreenState();
}

class _CouponDiscountScreenState extends State<CouponDiscountScreen> {
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
        child: ListView.builder(
          itemCount: 5,
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
                      child: Text("#ABCDE",style: TextStyle(color: AppColors.whit,fontWeight: FontWeight.bold),)),
                ),
                VerticalDivider(color: Colors.transparent,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Free Coupon",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      Text(
                        "11/06/2024",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.bold),
                      ),  
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
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
                                fontSize: 12,
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
        ),
      ),
    );
  }
}
