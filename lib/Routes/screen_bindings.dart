import 'package:pricedot/Screens/Auth_Views/Forgot_Password/forgot_password_controller.dart';
import 'package:pricedot/Screens/Auth_Views/Login/login_controller.dart';
import 'package:pricedot/Screens/Auth_Views/Otp_Verification/otp_verify_controller.dart';
import 'package:pricedot/Screens/Auth_Views/Signup/signup_controller.dart';
import 'package:pricedot/Screens/Dashboard/dashboard_controller.dart';
import 'package:pricedot/Screens/Home/HomeController.dart';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class ScreenBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
     Get.lazyPut(() => SplashController() );
     Get.lazyPut(() => LoginController() );
     Get.lazyPut(() => ForgotPasswordController() );
     Get.lazyPut(() => OTPVerifyController() );
     Get.lazyPut(() => SignupController() );
     Get.lazyPut(() => DashboardController() );
      //Get.lazyPut(() => OTPVerifyController());
    // Get.lazyPut(() => const LoginScreen() );
    // Get.lazyPut(() =>  SignupScreen() );
    // Get.lazyPut(() =>  const BottomBar() );
    // Get.lazyPut(() =>  const OtpScreen() );
    // Get.lazyPut(() =>  const ForgotPasswordScreen() );
    // Get.lazyPut(() =>  const PortfolioScreen() );
    // Get.lazyPut(() =>  const IntroScreen() );
  }

}