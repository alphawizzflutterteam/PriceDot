import 'package:flutter/material.dart';
import 'package:pricedot/Utils/PrefUtils.dart';

import '../Local_Storage/shared_pre.dart';

class NoDataFound extends StatefulWidget {
  const NoDataFound({super.key});

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  String image = '';
  Future<void> getImage() async {
    String lang = PreferenceUtils.getString(PrefKeys.language);
    print("Language.... $lang");
    switch (lang.toString()) {
      case "1":
        image = 'assets/images/nodata-hi.png';
        break;
      case "2":
        image = 'assets/images/nodata-en.png';
        break;
      case "3":
        image = 'assets/images/nodata-ta.png';
        break;
      case "4":
        image = 'assets/images/nodata-te.png';
        break;
      default:
        image = 'assets/images/nodata-hi.png';
        break;
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImage(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? CircularProgressIndicator()
              : Image.asset(
                  image,
                  height: MediaQuery.of(context).size.height * .3,
                ),
    );
  }
}

