import 'package:pricedot/Utils/Colors.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * .65,
                child: Image.asset(
                  "assets/images/nonet.png",
                ),
              ),
              const Text(
                "Ooops!",
                style: TextStyle(
                    fontSize: 32,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "No Internet Connection Found.\nCheck Your Connection",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.greyColor,
                ),
              ),
              const Divider(
                color: Colors.transparent,
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bgColor,
                  ),
                  child: const Text(
                    "Try Again",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
