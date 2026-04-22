import 'package:flutter/material.dart';

import '../enum/enum.dart';

class AppColors {

  static const Map<appColors, Color> theme = {
    appColors.background        : Color(0xFFF5F0E8),
    appColors.primary_action    : Color(0xFF2C2C2C),
    appColors.accent_success    : Color(0xFF6B7C4A),
    appColors.highlight         : Color(0xFFC9A96E),
    appColors.card              : Color(0xFFFAF7F2),
    appColors.border            : Color(0xFFD4CFC7),

    appColors.sidebar_bg        : Color(0xFF2C2C2C),
    appColors.active_nav_item    : Color(0xFF6B7C4A),
    appColors.low_stock          : Color(0xFFFAEEDA),
    appColors.out_of_stock       : Color(0xFFFCEBEB),
    appColors.active_stock       : Color(0xFFEAF3DE),
    appColors.low_stock_text     : Color(0xFF633806),
    appColors.out_of_stock_text  : Color(0xFF791F1F),
    appColors.active_stock_text  : Color(0xFF27500A),
  };

  static Color get(appColors key) => theme[key]!;

  //Use like this:
  //AppColors.get(appColors.accent)

}

