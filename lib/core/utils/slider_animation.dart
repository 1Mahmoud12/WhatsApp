import 'package:flutter/material.dart';

class AnimatedSliderMe extends StatefulWidget {
  const AnimatedSliderMe({super.key});

  @override
  _AnimatedSliderMeState createState() => _AnimatedSliderMeState();
}

class _AnimatedSliderMeState extends State<AnimatedSliderMe>
    with SingleTickerProviderStateMixin {
  late AnimationController controllerSlider;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    controllerSlider = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    controllerSlider.dispose();
    super.dispose();
  }

  void _handleSlide(double newValue) {
    setState(() {
      _sliderValue = newValue;
    });
  }

  void _handleSlideStart(double startValue) {
    controllerSlider.forward();
  }

  void _handleSlideEnd(double endValue) {
    controllerSlider.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) =>
          _handleSlideStart(details.localPosition.dx),
      onHorizontalDragUpdate: (details) =>
          _handleSlide(details.localPosition.dx),
      onHorizontalDragEnd: (details) =>
          _handleSlideEnd(details.velocity.pixelsPerSecond.dx),
      child: Container(
        height: 50.0,
        width: double.infinity,
        color: Colors.grey[300],
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: controllerSlider,
              builder: (context, child) {
                return Positioned(
                  left: _sliderValue - 10.0,
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
