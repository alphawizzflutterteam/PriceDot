// import 'dart:async';
//
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:pricedot/Screens/Splash/splash_controller.dart';
// import 'package:pricedot/Utils/Colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:page_transition/page_transition.dart';
//
// import '../../Local_Storage/shared_pre.dart';
// import '../../Routes/routes.dart';
//
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     final heightSize = MediaQuery
//         .sizeOf(context)
//         .height;
//     final widthSize = MediaQuery
//         .sizeOf(context)
//         .width;
//     return GetBuilder(
//         init: SplashController(),
//         builder: (controller) {
//           return Container(
//
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//
//               image: DecorationImage(
//                 image: AssetImage("assets/images/splashback.png"),
//                 fit: BoxFit.fill,
//               ),
//             ),
//             child: AnimatedSplashScreen.withScreenFunction(
//               splash: 'assets/images/SPLASH LOGO.png',
//               screenFunction: () async {
//                 return checkLogin();
//               },
//               splashTransition: SplashTransition.scaleTransition,
//               pageTransitionType: PageTransitionType.scale,
//               animationDuration: Duration(seconds: 2),
//               splashIconSize: 250,
//               backgroundColor: AppColors.secondary,
//
//               // pageTransitionType: PageTransitionType.scale,
//             ),
//           );
//
//
//             /*Animate(
//           effects: [FadeEffect(), ScaleEffect()],
//           child: Text("Hello World!"),
//         );*/
//             // AnimatedSplashScreen(
//             //     duration: 3000,
//             //     splash: 'assets/images/SPLASH LOGO.png',
//             //     nextScreen: checkLogin(),
//             //     splashTransition: SplashTransition.fadeTransition,
//             //     pageTransitionType: PageTransitionType.scale,
//             //     );
//             AnimatedSplashScreen.withScreenFunction(
//               splash: 'assets/images/SPLASH LOGO.png',
//               screenFunction: () async {
//                 return checkLogin();
//               },
//               //splashTransition: SplashTransition.rotationTransition,
//               pageTransitionType: PageTransitionType.leftToRight,
//
//               animationDuration: Duration(seconds: 30),
//
//               // pageTransitionType: PageTransitionType.scale,
//             );
//         });
//   }
//
//    checkLogin() async {
//      final isLogin2 = await SharedPre.getStringValue('userId');
//
//      Future.delayed(const Duration(seconds: 1), () async {
//        final isLogin = await SharedPre.getStringValue('userId');
//
//        if (isLogin != null && isLogin != '') {
//          Get.offAllNamed(bottomBar);
//        } else {
//          Get.offAllNamed(loginScreen);
//        }
//      });
//      //  Timer(const Duration(seconds: 3), () async {
//    }
//
// }

import 'dart:async';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pricedot/Utils/Colors.dart';
import '../../Local_Storage/shared_pre.dart';
import '../../Routes/routes.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final heightSize = MediaQuery.sizeOf(context).height;
    final widthSize = MediaQuery.sizeOf(context).width;
    return GetBuilder(
        init: SplashController(),
        builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/logo.png',height: MediaQuery.of(context).size.height*.2,width: MediaQuery.of(context).size.width*.7,),
            ],
          );
        });
  }

  String? id;
  
}
