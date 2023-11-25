import 'package:flutter/material.dart';
import '../../../view_model/utils/app_colors.dart';
class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? color;
  final Widget? child;
const CustomButton ({super.key,required this.onPressed, this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), ),
        ),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 20)),
        backgroundColor: MaterialStateProperty.all(color ??AppColors.blueDegree), // Background color
        padding: MaterialStateProperty.all(const EdgeInsets.all(16)), // Padding around the button
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      onPressed:onPressed,
      child: child,
    );
  }
}
