import 'package:flutter/material.dart';

import '../Utils/Colors.dart';

Widget FlexibleSpace=Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[AppColors.primary, AppColors.secondary]),
  ),
);