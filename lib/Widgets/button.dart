import 'package:pricedot/Utils/Colors.dart';
import 'package:flutter/material.dart';

class AppButton1 extends StatelessWidget {
  const AppButton1({Key? key, this.onTap, this.title}) : super(key: key);

  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: double.maxFinite,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 55,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0XffB9271B), Color(0XffFF5148)],
                // Define the colors
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title ?? '',
                  style: const TextStyle(
                    color: AppColors.whit,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),

        // ElevatedButton(
        //   onPressed: onTap,
        //   style: ElevatedButton.styleFrom(
        //       elevation: 5,
        //       backgroundColor: AppColors.secondary,
        //       shape: RoundedRectangleBorder(
        //         borderRadius:
        //         BorderRadius.circular(30),
        //       )),
        //   child: Text(
        //     title ?? '',
        //     style: const TextStyle(
        //       //decoration: TextDecoration.underline,
        //       color: AppColors.whit,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 18,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
