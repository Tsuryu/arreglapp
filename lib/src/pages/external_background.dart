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
