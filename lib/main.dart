import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Utils/NoInternet.dart';
import 'package:pricedot/Utils/demo_localization.dart';
import 'package:pricedot/Utils/session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pricedot/firebase_options.dart';
import 'Routes/all_pages.dart';
import 'Routes/routes.dart';
import 'Routes/screen_bindings.dart';
import 'Screens/PushNotification/notification_service.dart';
import './firebase_options.dart';
import 'Services/api_services/TranslationService.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();

  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  LocalNotificationService.initialize();
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print("-----------token:-----${token}");
  } on FirebaseException {
    print('__________FirebaseException_____________');
  }
  await GetStorage.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return InternetWidget(
      offline: const FullScreenWidget(child: NoInternetScreen()),
      online: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: splashScreen,
        getPages: AllPages.getPages(),
        translations: TranslationService(),
        locale: Locale('en', 'US'), // Set initial locale
        fallbackLocale: Locale('en', 'US'),
        initialBinding: ScreenBindings(),
        title: 'Drawmoney',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary,
            ),
            scaffoldBackgroundColor: AppColors.bgColor,
            textTheme: const TextTheme(
              bodySmall: TextStyle(fontFamily: 'Gilroy'),
              bodyLarge: TextStyle(fontFamily: 'Gilroy'),
              bodyMedium: TextStyle(fontFamily: 'Gilroy'),
              displayLarge: TextStyle(fontFamily: 'Gilroy'),
              displayMedium: TextStyle(fontFamily: 'Gilroy'),
              displaySmall: TextStyle(fontFamily: 'Gilroy'),
            ),
            checkboxTheme: CheckboxThemeData()),
      ),
    );
  }
}
