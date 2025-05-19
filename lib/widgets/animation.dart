import 'package:flutter/material.dart';

class BannerAnimation extends StatefulWidget {
  final String imagePath;
  final double screenHeight;
  final double screenWidth;

  const BannerAnimation({
    super.key,
    required this.imagePath,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  _BannerAnimationState createState() => _BannerAnimationState();
}

class _BannerAnimationState extends State<BannerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SizedBox(
        height: widget.screenHeight * 0.25,
        width: widget.screenWidth,
        child: Image.asset(widget.imagePath, fit: BoxFit.cover),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
