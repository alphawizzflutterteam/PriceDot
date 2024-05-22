import 'package:pricedot/Constants.dart';
import 'package:pricedot/Routes/routes.dart';
import 'package:pricedot/Screens/Dashboard/dashboard_controller.dart';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/commen_widgets.dart';
import 'package:pricedot/Widgets/custom_appbar.dart';
import 'package:pricedot/Widgets/drawer_icon_tab_widget.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Bookings/my_booking_view.dart';
import '../Home/home_view.dart';
import '../Profile/profile_view.dart';
import '../Result/result_view.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  //final GlobalKey<ScaffoldState> _key = GlobalKey();
  int currentIndex = 1;

  int bottomIndex = 0;

  List<Widget> pageList = [
    HomeScreen(),
    ResultScreen(),
    //MyBookingsScreen(isFrom: false),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Display a confirmation dialog when the back button is pressed.
        if (bottomIndex > 0) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreen(),
              ),
              (route) => false);
        } else {
          return true;
        }
        // bool exit = await showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: Text('Exit App'),
        //       content: Text('Are you sure you want to exit the app?'),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop(false); // Cancel exit
        //           },
        //           child: Text('No'),
        //         ),
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop(true); // Confirm exit
        //           },
        //           child: Text('Yes'),
        //         ),
        //       ],
        //     );
        //   },
        // );

        // return exit ??
        return false; // Exit if the user confirmed (true) or continue if canceled (false).
      },
      child: Scaffold(
          bottomNavigationBar: Material(
              elevation: 4,
              color: AppColors.whit,
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: CURR_USR == '243'
                        ? Icon(Icons.home_filled)
                        : Image.asset(
                            "assets/icons/logo.png",
             height: 30,
                          ),
                    label: "Home".tr,
                  ),
                  BottomNavigationBarItem(
                      icon: CURR_USR == '243'
                          ? Icon(Icons.task)
                          : bottomIndex == 1
                              ? Image.asset(
                                  "assets/images/reward.png",
                                  scale: 1.6,
                        color: AppColors.primary,
                                )
                              : Image.asset(
                                  "assets/images/reward1.png",
                                  scale: 1.6,
                                ),
                      label: CURR_USR == '243' ? "My Tasks" : "My Contest".tr),
                  BottomNavigationBarItem(
                      icon: bottomIndex == 2
                          ? Image.asset(
                              "assets/images/person.png", color: AppColors.primary,
                              scale: 1.6,
                            )
                          : Image.asset(
                              "assets/images/person1.png",
                              scale: 1.6,
                            ),
                      label: "My Profile".tr)
                ],
                currentIndex: bottomIndex,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                selectedItemColor: AppColors.primary,
                onTap: (index) {
                  setState(() {
                    bottomIndex = index;
                  });
                },
              )

              // CurvedNavigationBar(
              //   //buttonBackgroundColor: Colors.white,
              //   color: AppColors.whit,
              //   backgroundColor: AppColors.secondary,
              //
              //   items: const [
              //     CurvedNavigationBarItem(
              //         child: ImageIcon(AssetImage(AppConstants.homeIcon),
              //             color: AppColors.secondary),
              //         label: 'Home',
              //         labelStyle: TextStyle(color: AppColors.secondary)
              //
              //     ),
              //     CurvedNavigationBarItem(
              //         child: ImageIcon(AssetImage(AppConstants.calenderIcon),
              //             color: AppColors.secondary),
              //         label: 'Result',
              //         labelStyle: TextStyle(color: AppColors.secondary)),
              //     // CurvedNavigationBarItem(
              //     //     child: ImageIcon(AssetImage(AppConstants.myLotteryIcon),
              //     //         color: AppColors.whit),
              //     //     label: 'My Lotteries',
              //     //     labelStyle: TextStyle(color: AppColors.whit)
              //     // ),
              //     CurvedNavigationBarItem(
              //         child: ImageIcon(AssetImage(AppConstants.profileIcon),
              //             color: AppColors.secondary),
              //         label: 'Account',
              //         labelStyle: TextStyle(color: AppColors.secondary)),
              //   ],
              //   onTap: (index) {
              //     setState(() {
              //       bottomIndex = index;
              //     });
              //   },
              // ),
              ),
          key: _key,
          backgroundColor: AppColors.whit,
          body: pageList[bottomIndex]),
    );
  }
}
