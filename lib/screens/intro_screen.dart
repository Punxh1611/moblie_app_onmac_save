import 'package:flutter/material.dart';
import 'package:moblie_kakkak/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'profile_screen.dart';
import '../constant/my_constant.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> pages = [
      PageViewModel(
        title: "Welcome to Task Manager",
        body: "Organize your daily tasks efficiently and boost your productivity with our easy-to-use to-do list app.",
        image: Center(
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_alt,
              size: 150,
              color: const Color(0xFF4A90E2),
            ),
          ),
        ),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4A90E2),
          ),
          bodyTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
          imagePadding: EdgeInsets.only(top: 80, bottom: 20),
          pageColor: Colors.white,
          contentMargin: EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
      PageViewModel(
        title: "Track Your Progress",
        body: "Mark tasks as complete, see your achievements, and stay motivated as you accomplish your daily goals.",
        image: Center(
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF5BA3F5).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 150,
              color: const Color(0xFF5BA3F5),
            ),
          ),
        ),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5BA3F5),
          ),
          bodyTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
          imagePadding: EdgeInsets.only(top: 80, bottom: 20),
          pageColor: Colors.white,
          contentMargin: EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
      PageViewModel(
        title: "Stay Organized",
        body: "Keep all your tasks in one place, set priorities, and never miss an important deadline again.",
        image: Center(
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF6BB6FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today,
              size: 150,
              color: const Color(0xFF6BB6FF),
            ),
          ),
        ),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6BB6FF),
          ),
          bodyTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
          imagePadding: EdgeInsets.only(top: 80, bottom: 20),
          pageColor: Colors.white,
          contentMargin: EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
    ];

    return IntroductionScreen(
      pages: pages,
      dotsDecorator: DotsDecorator(
        size: Size(10, 10),
        color: Colors.grey.shade300,
        activeSize: Size(22, 10),
        activeColor: const Color(0xFF4A90E2),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
      ),
      showSkipButton: true,
      skip: Text(
        "Skip",
        style: TextStyle(
          color: const Color(0xFF4A90E2),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      showNextButton: true,
      next: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF4A90E2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
      done: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF4A90E2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Get Started",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      onDone: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      },
      controlsMargin: EdgeInsets.all(16),
      dotsContainerDecorator: BoxDecoration(
        color: Colors.transparent,
      ),
    );
  }
}