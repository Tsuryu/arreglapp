import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ExternalBackground extends StatelessWidget {
  final Widget child;

  const ExternalBackground({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          FlareActor(
            "assets/flare/background.flr",
            fit: BoxFit.fill,
            alignment: Alignment.center,
          ),
          this.child,
        ],
      ),
    );
  }
}

// class _LoginBackgroundPainter extends CustomPainter {
//   final Color color;

//   _LoginBackgroundPainter({this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint();
//     paint.color = this.color;
//     paint.style = PaintingStyle.fill;
//     paint.strokeWidth = 5.0;

//     final path = Path();
//     path.lineTo(size.width * 0, size.height * 0.5);
//     path.quadraticBezierTo(size.width * 0.1, size.height * 0.15, size.width * 0.5, size.height * 0.15);
//     path.quadraticBezierTo(size.width * 1, size.height * 0.15, size.width * 1.1, size.height * 0.05);
//     path.lineTo(size.width * 1, size.height * 0);

//     final path2 = Path();
//     path2.lineTo(size.width * 0, size.height * 0.85);
//     path2.quadraticBezierTo(size.width * 0.2, size.height * 0.7, size.width * 0.4, size.height * 0.85);
//     path2.quadraticBezierTo(size.width * 0.15, size.height * 0.9, size.width * 0.1, size.height * 1);
//     path2.lineTo(size.width * 0, size.height * 1);

//     final path3 = Path();
//     path3.lineTo(0, size.height * 1);
//     path3.lineTo(size.width * 0.15, size.height * 1);
//     path3.quadraticBezierTo(size.width * 0.4, size.height * 0.8, size.width * 0.7, size.height * 1);
//     path3.lineTo(0, size.height * 1);
//     path3.lineTo(1, 1);

//     canvas.drawPath(path, paint);
//     canvas.drawPath(path2, paint);
//     canvas.drawPath(path3, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     throw true;
//   }
// }
