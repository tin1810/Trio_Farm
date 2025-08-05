import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trio_farm_app/core/util/app_color.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle headlineLargeBold = GoogleFonts.poppins(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColor.textBlack,
  );

  static TextStyle headlineMediumSemibold = GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColor.textBlack,
  );

  static TextStyle bodyRegular = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColor.textBlack,
  );

  static TextStyle bodyBold = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColor.textBlack,
  );
  static TextStyle smallRegular = GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColor.textBlack,
  );
  static TextStyle smallBold = GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColor.textBlack,
  );
}
