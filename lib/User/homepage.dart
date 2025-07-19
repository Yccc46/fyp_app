import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/Image/FYP_logo.png',
                        width: 44.w,
                        height: 44.h,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Garbage Classification",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject()
                      as RenderBox;
                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromRect(
                          Rect.fromPoints(
                            details.globalPosition,
                            details.globalPosition,
                          ),
                          Offset.zero & overlay.size,
                        ),
                        items: [
                          const PopupMenuItem<String>(
                            value: 'profile',
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Profile'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'settings',
                            child: ListTile(
                              leading: Icon(Icons.settings),
                              title: Text('Settings'),
                            ),
                          ),
                        ],
                      ).then((value) {
                        if (value == 'profile') {
                          Navigator.pushNamed(context, '/profile');
                        } else if (value == 'settings') {
                          Navigator.pushNamed(context, '/settings');
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 24.r,
                      backgroundImage:
                      const AssetImage('assets/Image/Profile_logo.png'),
                    ),
                  ),
                ],
              ),
            ),

            // News board
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SizedBox(
                height: 140.h,
                child: PageView(
                  children: List.generate(3, (index) => _buildNewsCard(index)),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Keyword",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                      padding: EdgeInsets.all(14.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child:
                    Icon(Icons.search, color: const Color(0xFF425855), size: 22.sp),
                  )
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Scrollable feature buttons
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Wrap(
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: [
                    _buildFeatureButton(
                        "Image Recognition", Icons.camera_alt, () {
                      Navigator.pushNamed(context, '/image-recognition');
                    }),
                    _buildFeatureButton("Point Reward", Icons.star, () {}),
                    _buildFeatureButton("History Records", Icons.history, () {
                      Navigator.pushNamed(context, '/history');
                    }),
                    _buildFeatureButton("Add To Favorite", Icons.favorite_border, () {
                      Navigator.pushNamed(context, '/favorite');
                    }),
                    _buildFeatureButton("Recycle Center Locator", Icons.location_on, () {}),
                    _buildFeatureButton("Classification Test", Icons.quiz, () {}),
                    _buildFeatureButton("Feedback", Icons.feedback, () {
                      Navigator.pushNamed(context, '/feedback');
                    }),
                    _buildFeatureButton("FAQs", Icons.help_outline, () {}),
                  ]
                      .map(
                        (e) => SizedBox(
                      width: (1.sw - 16.w * 2 - 16.w) / 2,
                      height: 130.h,
                      child: e,
                    ),
                  )
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              "News Item ${index + 1}: Latest update goes here...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(
      String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.green[200],
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28.sp, color: Colors.black54),
              SizedBox(height: 8.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF425855),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
