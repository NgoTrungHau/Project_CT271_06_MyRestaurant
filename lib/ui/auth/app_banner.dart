import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 70,left: 70),
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              child: Image.asset(
                'assets/images/chef1.png',
                height: 260.0,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
        ),
      ],
    );
  }
}
