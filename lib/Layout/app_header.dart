import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;

    final logoWidthSize = isWeb ? 70.w : 50.w;
    final logoHeightSize = isWeb ? 70.w : 50.w;
    final fontSize = isWeb ? 28.sp : 20.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Name + Logo
        Row(
          children: [
            Image.asset(
              'assets/Image/FYP_logo.png',
              width: logoWidthSize ,
              height: logoHeightSize,
            ),

            SizedBox(width: 12.w),
            Text(
              'Garbage Classification',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF425855),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
