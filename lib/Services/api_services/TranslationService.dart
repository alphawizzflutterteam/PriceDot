import 'package:pricedot/Language/gu_IN.dart';
import 'package:pricedot/Language/hi_IN.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../Language/en_US.dart';
import '../../Language/ta_IN.dart';
import '../../Language/te_IN.dart';

class TranslationService extends Translations {
  // Load translation data from JSON files
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _parseJsonToMap(enUS),
        'hi_IN': _parseJsonToMap(hiIN),
        // 'gu_IN': _parseJsonToMap(guIN),
        'ta_IN': _parseJsonToMap(taIN),
        'te_IN': _parseJsonToMap(teIN),
      };

  // Helper function to parse JSON string to Map<String, String>
  Map<String, String> _parseJsonToMap(String jsonString) {
    final Map<String, dynamic> map = json.decode(jsonString);
    return map.map((key, value) => MapEntry(key, value.toString()));
  }
}
// English translations
