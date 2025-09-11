import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/cache_helper/cache_helper.dart';

import '../../models/on_boarding_model.dart';
import '../Auth/login_screen.dart';

class onBoardingScreen extends StatefulWidget {
  static const String routeName = '/onBoardingScreen';
  onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  final PageController _controller = PageController();

  int _currentPage = 0;
  final List<OnBoardingItem> pages = OnBoardingItem.generateOnBoardingItems();

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _finish() {
    SharedPreferencesHelper.setOnBoardingSeen(true);
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          final isLastPage = index == pages.length - 1;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(page.image, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        page.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 24.h),
                      if (page.description != null)
                        Column(
                          children: [
                            Text(
                              page.description == null ? "" : page.description!,
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      if (!isLastPage)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),
                            onPressed: _nextPage,
                            child: Text("Next"),
                          ),
                        ),
                      if (isLastPage)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _finish,
                            child: Text("Finish"),
                          ),
                        ),
                      SizedBox(height: 16.h),
                      if (_currentPage > 0)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            onPressed: _prevPage,
                            child: Text("Back"),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
