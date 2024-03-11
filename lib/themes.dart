import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'misc/utils.dart';

class Themes {
  static light(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.white,
      primarySwatch: createMaterialColor(AppColors.primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        elevation: 0,
        //! textTheme: GoogleFonts.caveatBrushTextTheme(
        //   Theme.of(context).textTheme.copyWith(
        //         headline6: TextStyle(
        //           color: AppColors.primary,
        //         ),
        //       ),
        // ),
        iconTheme: IconTheme.of(context).copyWith(
          color: AppColors.primary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
        backgroundColor: Colors.black,
        selectedItemColor: AppColors.primary,
      ),
      brightness: ThemeData.light().brightness,
      textTheme: GoogleFonts.caveatBrushTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

  // ThemeData.light().copyWith(
  //   primaryColor: createMaterialColor(AppColors.primary),
  //   primaryColorLight: createMaterialColor(AppColors.primary),
  //   visualDensity: VisualDensity.adaptivePlatformDensity,
  //   appBarTheme: AppBarTheme(elevation: 0),
  // );

  static dark(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.black,
      //! accentColor: AppColors.primary,
      primarySwatch: createMaterialColor(AppColors.primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      canvasColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        elevation: 0,
        //!  textTheme: GoogleFonts.caveatBrushTextTheme(
        //   Theme.of(context).textTheme,
        // ).copyWith(
        //   headline6: TextStyle(
        //     color: Colors.white,
        //     fontStyle: FontStyle.italic,
        //   ),
        // ),
        centerTitle: true,
        iconTheme: IconTheme.of(context).copyWith(
          color: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: Colors.black,
      backgroundColor: Colors.black,
      bottomNavigationBarTheme:
          ThemeData.dark().bottomNavigationBarTheme.copyWith(
                backgroundColor: Colors.black,
                selectedItemColor: AppColors.primary,
              ),
      bottomAppBarColor: Colors.black,
      brightness: ThemeData.dark().brightness,
      textTheme: GoogleFonts.caveatBrushTextTheme(
        Theme.of(context).textTheme.copyWith(
              headline5: TextStyle(
                color: Colors.white,
              ),
              headline6: TextStyle(
                color: Colors.white,
              ),
            ),
      ),
    );
  }
}
