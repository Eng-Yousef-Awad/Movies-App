import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoaderWithTimeout extends StatefulWidget {
  const LoaderWithTimeout({super.key});

  @override
  State<LoaderWithTimeout> createState() => _LoaderWithTimeoutState();
}

class _LoaderWithTimeoutState extends State<LoaderWithTimeout> {
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isError
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.red, size: 48.sp),
          SizedBox(height: 8.h),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              child: Text("something went wrong",
              style: Theme.of(context).textTheme.headlineSmall,
              )),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isError = false;
                  initState();
                });
              },
              child: const Text("try again"),
            ),
          ),
          SizedBox(height: 8.h),
          TextButton(onPressed:(){Navigator.pop(context);}, child: Text("Back"))
        ],
      )
          : const CircularProgressIndicator(),
    );
  }
}
