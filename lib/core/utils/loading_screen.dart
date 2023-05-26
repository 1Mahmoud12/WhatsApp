import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key, required this.enabled}) : super(key: key);
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    double heightMedia=MediaQuery.of(context).size.height;
    double widthMedia=MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: const Color.fromRGBO(208, 200, 200, .5),
      highlightColor: const Color.fromRGBO(140, 160, 140, 1),
      enabled: enabled,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(7, (index) => item(heightMedia,widthMedia)),
      ),
    );
  }

  Widget item(double withMedia,double heightMedia) {

    return SizedBox(
      height: heightMedia*.12,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: withMedia*.02,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.0),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Container(
              width: double.infinity,
              height:heightMedia*.02,
              color: Colors.white,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
            ),
            Container(
              width: double.infinity,
              height: heightMedia*.01,
              color: Colors.white,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
            ),
            Container(
              width: withMedia*.01,
              height: heightMedia*.01,
              color: Colors.white,
            ),
          ],
        ))
      ]),
    );
  }
}
