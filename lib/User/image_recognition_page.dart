import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

class ImageRecognitionPage extends StatefulWidget {
  const ImageRecognitionPage({super.key});

  @override
  State<ImageRecognitionPage> createState() => _ImageRecognitionPageState();
}

class _ImageRecognitionPageState extends State<ImageRecognitionPage> {
  late CameraController _controller;
  bool _isInitialized = false;
  int _cameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(
      cameras[_cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  Future<void> _switchCamera() async {
    _cameraIndex = (_cameraIndex + 1) % cameras.length;
    _isInitialized = false;
    await _controller.dispose();
    await _initCamera();
  }

  Future<void> _captureImage() async {
    try {
      final image = await _controller.takePicture();
      Navigator.pushNamed(
        context,
        '/preview',
        arguments: {'imagePath': image.path},
      );
    } catch (e) {
      debugPrint("Capture error: $e");
    }
  }

  Future<void> _openGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      Navigator.pushNamed(
        context,
        '/preview',
        arguments: {'imagePath': picked.path},
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized
          ? Stack(
        children: [
          CameraPreview(_controller),

          // 中间扫描提示图
          Center(
            child: Image.asset(
              'assets/Image/scan.png',
              width: 300.w,
              height: 300.h,
              fit: BoxFit.contain,
            ),
          ),

          // 顶部返回 + 标题
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Image Recognition",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 40), // 占位
                ],
              ),
            ),
          ),

        // 底部控制按钮
        Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 切换镜头
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flip_camera_android, color: Colors.white, size: 30),
                    SizedBox(height: 4.h),
                    Text("Change", style: TextStyle(color: Colors.white)),
                  ],
                ).let((widget) => GestureDetector(
                  onTap: _switchCamera,
                  child: widget,
                )),

                // 拍照按钮
                GestureDetector(
                  onTap: _captureImage,
                  child: Container(
                    width: 75.w,
                    height: 75.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Container(
                        width: 55.w,
                        height: 55.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // 相册
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo, color: Colors.white, size: 30),
                    SizedBox(height: 4.h),
                    Text("Album", style: TextStyle(color: Colors.white)),
                  ],
                ).let((widget) => GestureDetector(
                  onTap: _openGallery,
                  child: widget,
                )),
              ],
            ),
        )
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// 快速 let 函数用于包裹 widget 的扩展（可选）
extension LetWidget<T> on T {
  R let<R>(R Function(T) op) => op(this);
}




