import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = const Color.fromARGB(255, 0, 0, 0);
Color secondaryColor = const Color.fromARGB(255, 255, 255, 255);

Color lightBackgroundColor = const Color.fromARGB(255, 169, 236, 253);
Color darkBackgroundColor = const Color.fromARGB(255, 123, 123, 123);

Color lightTextColor = const Color.fromARGB(255, 255, 255, 255);
Color darkTextColor = const Color.fromARGB(255, 0, 0, 0);

Color lightBlue = const Color.fromARGB(255, 173, 216, 230);
Color darkBlue = const Color.fromARGB(255, 94, 207, 245);

TextStyle headingStyle = TextStyle(
  fontFamily: GoogleFonts.openSans().fontFamily,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: primaryColor,
);

TextStyle bodyTextStyle = TextStyle(
  fontFamily: GoogleFonts.openSans().fontFamily,
  fontSize: 16.0,
  color: primaryColor,
);

TextStyle optionTextStyle = TextStyle(
  fontFamily: GoogleFonts.openSans().fontFamily,
  fontSize: 16.0,
  color: primaryColor,
  fontWeight: FontWeight.bold,
);

TextStyle logoutTextStyle = TextStyle(
  fontFamily: GoogleFonts.openSans().fontFamily,
  fontSize: 16.0,
  color: Colors.red,
  fontWeight: FontWeight.bold,
);

TextStyle profileTextStyle = TextStyle(
  fontFamily: GoogleFonts.openSans().fontFamily,
  fontSize: 20.0,
  color: secondaryColor,
  fontWeight: FontWeight.bold,
);

class ProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60); // จุดเริ่มต้นด้านซ้าย

    // วาดเส้นโค้ง Bezier
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 60);

    path.quadraticBezierTo(
      controlPoint.dx, 
      controlPoint.dy, 
      endPoint.dx, 
      endPoint.dy
    );

    path.lineTo(size.width, 0); // ลากไปมุมขวาบน
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
