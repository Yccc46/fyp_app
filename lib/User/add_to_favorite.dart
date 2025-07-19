import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Layout/app_header.dart';

class FavoriteItem {
  final String imagePath;
  final String itemName;
  final String category;

  FavoriteItem({
    required this.imagePath,
    required this.itemName,
    required this.category,
  });
}

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<FavoriteItem> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    // simulate db, after will change
    favoriteItems = [
      FavoriteItem(
        imagePath: 'assets/Image/sample.jfif',
        itemName: 'Plastic Bottle',
        category: 'Recyclable',
      ),
      FavoriteItem(
        imagePath: 'assets/Image/sample.jfif',
        itemName: 'Banana Peel',
        category: 'Organic',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const darkColor = Color(0xFF425855);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),

              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: darkColor),
                  label: const Text("Back", style: TextStyle(color: darkColor)),
                ),
              ),

              SizedBox(height: 8.h),

              // Title
              Center(
                child: Text(
                  "Favourite Item",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: darkColor,
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              // Total Items
              Center(
                child: Text(
                  "Total Favorite Items: ${favoriteItems.length} items",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black87,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Favorite Items List
              Expanded(
                child: ListView.builder(
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = favoriteItems[favoriteItems.length - 1 - index]; // 反转顺序
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image(
                              image: item.imagePath.startsWith('assets/')
                                  ? AssetImage(item.imagePath) as ImageProvider
                                  : FileImage(File(item.imagePath)),
                              width: 60.w,
                              height: 60.w,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(width: 12.w),

                          // Item name & Category
                          Expanded(
                            child: Row(
                              children: [
                                // Item name
                                Expanded(
                                  child: Text(
                                    item.itemName,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: darkColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40.h,
                                  width: 1,
                                  color: Colors.grey[400],
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                ),
                                // Category
                                Text(
                                  item.category,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
