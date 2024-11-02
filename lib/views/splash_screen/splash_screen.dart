import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../helper.dart';
import '../welcome_screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick >= _controller.value.duration.inSeconds) {
        replace(context, const WelcomeScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/chakra_splash.mp4');
    _controller.initialize().then((_) {
      _controller.play();
      _controller.setLooping(false);
      _controller.setVolume(1);
      startTimer();
      setState(() {
        _isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffc1c1c1),
      backgroundColor: Colors.white,
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
