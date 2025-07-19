import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import '../Layout/app_header.dart';

class ClassificationResultPage extends StatefulWidget {
  final String imagePath;
  const ClassificationResultPage({super.key, required this.imagePath});

  @override
  State<ClassificationResultPage> createState() => _ClassificationResultPageState();
}

class _ClassificationResultPageState extends State<ClassificationResultPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF425855);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),

            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: primaryColor),
              label: const Text("Back", style: TextStyle(color: primaryColor)),
            ),

            SizedBox(height: 8.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 图片显示
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        File(widget.imagePath),
                        height: 200.h,
                        width: 200.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Item Name
                    Text(
                      "Item Name",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // 分类栏（可展开）
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.category, color: primaryColor),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "Category",
                                      style: TextStyle(color: primaryColor, fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                                AnimatedRotation(
                                  duration: const Duration(milliseconds: 200),
                                  turns: _isExpanded ? 0.5 : 0,
                                  child: const Icon(Icons.expand_more, color: primaryColor),
                                ),
                              ],
                            ),
                            if (_isExpanded)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(color: Colors.grey, thickness: 1),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: Text(
                                      "This is the detailed description of the category. It explains the classification.",
                                      style: TextStyle(color: Colors.black87, fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // OK 按钮
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName('/image-recognition'));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle),
                        label: Text("OK", style: TextStyle(fontSize: 16.sp)),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Add to Favorite button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // 显示成功消息
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Add to Favorite Successful"),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.green[400],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                            ),
                          );

                          // 不再跳转页面
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        icon: const Icon(Icons.favorite_border),
                        label: Text("Add to Favorite", style: TextStyle(fontSize: 16.sp)),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
