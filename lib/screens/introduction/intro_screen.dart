import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/screens/introduction/on_boarding_screen.dart';

import '../../models/on_boarding_model.dart';

class IntroScreen extends StatelessWidget {
  static const String routeName = '/introScreen';
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OnBoardingItem page = OnBoardingItem.generateIntroItem();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(page.image, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black.withAlpha(100)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    page.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    page.description == null ? "" : page.description!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withAlpha(80),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          onBoardingScreen.routeName,
                        );
                      },
                      child: Text("Explore Now"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
