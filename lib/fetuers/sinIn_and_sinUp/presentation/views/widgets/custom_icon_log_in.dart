import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconLogIn extends StatelessWidget {
  const CustomIconLogIn({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: FittedBox(fit: BoxFit.scaleDown, child: SvgPicture.asset(image)),
    );
  }
}
