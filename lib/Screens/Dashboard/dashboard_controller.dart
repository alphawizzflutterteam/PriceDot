import 'package:pricedot/Controllers/app_base_controller/app_base_controller.dart';
import 'package:pricedot/Screens/Auth_Views/Login/login_view.dart';
import 'package:pricedot/Screens/Bookings/my_booking_view.dart';
import 'package:pricedot/Screens/Home/home_view.dart';
import 'package:pricedot/Screens/Profile/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashboardController extends AppBaseController {


List <Widget>  pages = [
const HomeScreen(),
const MyBookingsScreen(isFrom: false),
   ProfileScreen(),
   ProfileScreen()
];

RxInt currentIndex = 1.obs ;
int bottomIndex = 0;

}