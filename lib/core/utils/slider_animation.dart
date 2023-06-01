import 'package:flutter/material.dart';

class AnimatedSliderMe extends StatefulWidget {
  final double moveSlider;
  final double endPosition;
  const AnimatedSliderMe(
      {required this.endPosition, required this.moveSlider, super.key});

  @override
  _AnimatedSliderMeState createState() => _AnimatedSliderMeState();
}

class _AnimatedSliderMeState extends State<AnimatedSliderMe>
    with SingleTickerProviderStateMixin {
  late AnimationController controllerSlider;

  @override
  void initState() {
    super.initState();

    controllerSlider = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    controllerSlider.dispose();
    super.dispose();
  }

  void _handleSlideStart(double startValue) {
    controllerSlider.forward();
  }

  void _handleSlideEnd(double endValue) {
    controllerSlider.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;

    return GestureDetector(
      onHorizontalDragStart: (details) => _handleSlideStart(0),
      onHorizontalDragEnd: (details) => _handleSlideEnd(widget.endPosition),
      child: Container(
        height: 20,
        width: widthMedia * .6,
        color: Colors.grey.withOpacity(0.2),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: controllerSlider,
              builder: (context, child) {
                return Positioned(
                  left: widget.moveSlider *
                      (widthMedia * .6 / widget.endPosition),
                  child: Container(
                    height: 15.00,
                    width: 15.0,
                    decoration: const BoxDecoration(
                      color: Colors.black,
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
