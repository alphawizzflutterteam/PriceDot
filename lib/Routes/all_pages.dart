import 'package:pricedot/Routes/routes.dart';
import 'package:pricedot/Routes/screen_bindings.dart';
import 'package:pricedot/Screens/AddMoney/add_money.dart';
import 'package:pricedot/Screens/Auth_Views/Forgot_Password/forgot_password_view.dart';
import 'package:pricedot/Screens/Auth_Views/Login/login_view.dart';
import 'package:pricedot/Screens/Auth_Views/Otp_Verification/otp_verify_view.dart';
import 'package:pricedot/Screens/Auth_Views/Signup/signup_view.dart';
import 'package:pricedot/Screens/Bookings/my_booking_view.dart';
import 'package:pricedot/Screens/ChnagePassword/chnage_password_view.dart';
import 'package:pricedot/Screens/Dashboard/dashboard_view.dart';
import 'package:pricedot/Screens/Enqury/enquir_view.dart';
import 'package:pricedot/Screens/Home/home_view.dart';
import 'package:pricedot/Screens/Language/language.dart';
import 'package:pricedot/Screens/Notice/notice_View.dart';
import 'package:pricedot/Screens/Privacy_Policy/privacy_view.dart';
import 'package:pricedot/Screens/Profile/contactus.dart';
import 'package:pricedot/Screens/Profile/profile_controller.dart';
import 'package:pricedot/Screens/Profile/profile_view.dart';
import 'package:pricedot/Screens/Splash/splash_screen.dart';
import 'package:pricedot/Screens/Terms_Condition/terms_condition_view.dart';
import 'package:pricedot/Screens/Winner/WinnerViewNew.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../Screens/FaQ/faq_view.dart';
import '../Screens/InviteFriend/invite_view.dart';
import '../Screens/MyInvitation/my_invitation_view.dart';
import '../Screens/PlayVideo/video_view.dart';
import '../Screens/ReferAndEran/referAndEran_view.dart';
import '../Screens/Result/result_view.dart';

class AllPages {
  static List<GetPage> getPages() {
    return [
      GetPage(
          name: splashScreen,
          page: () => SplashScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: loginScreen,
          page: () => const LoginScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: selectLang,
          page: () => const LanguageScreen(
                isProfile: false,
              ),
          binding: ScreenBindings()),
      GetPage(
          name: forgotPasswordScreen,
          page: () => const ForgotPasswordScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: otpScreen,
          page: () => const OTPVerificationScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: signupScreen,
          page: () => const SignupScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: bottomBar,
          page: () => DashBoardScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: homeScreen,
          page: () => const HomeScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: privacyScreen,
          page: () => const PrivacyPolicyScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: termConditionScreen,
          page: () => const TermsAndConditionScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: bookings,
          page: () => const MyBookingsScreen(isFrom: true),
          binding: ScreenBindings()),
      GetPage(
          name: changePasswordScreen,
          page: () => const ChangePasswordScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: profileScreen,
          page: () => ProfileScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: resultScreen,
          page: () => const ResultScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: winnerScreen,
          page: () => WinnerScreenNew(),
          binding: ScreenBindings()),
      GetPage(
          name: referAndEranScreen,
          page: () => const ReferAndEran(),
          binding: ScreenBindings()),
      GetPage(
          name: addMoney,
          page: () => const AddMoney(),
          binding: ScreenBindings()),
      GetPage(
          name: inviteFriend,
          page: () => const InviteFriend(),
          binding: ScreenBindings()),
      GetPage(
          name: invitation,
          page: () => const MyInvitation(),
          binding: ScreenBindings()),
      GetPage(
          name: faq, page: () => const FaqScreen(), binding: ScreenBindings()),
      GetPage(
          name: video, page: () => const Video(), binding: ScreenBindings()),
      GetPage(
          name: contact,
          page: () =>  ContactUsScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: notice,
          page: () => const NoticeScreen(),
          binding: ScreenBindings()),
      GetPage(
          name: enquiry,
          page: () => const Enquiry(),
          binding: ScreenBindings()),
      GetPage(
          name: walletScreen,
          page: () => const AddMoney(),
          binding: ScreenBindings()),
    ];
  }
}
