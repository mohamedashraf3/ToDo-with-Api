import 'package:flutter/material.dart';
import '../../../view_model/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final AutovalidateMode? autovalidateMode;
 final String? Function(String?)? validator;
 final Widget? prefixIcon;
  final int maxLines;
 final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final bool readOnly;
  final String? labelText;
  final Widget? suffixIcon;

   const CustomTextField({
    Key? key,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
    this.labelText,
    this.readOnly = false,
    this.validator, this.autovalidateMode,
     this.obscureText=false, this.prefixIcon, this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTap: onTap,
      obscureText:obscureText,
      validator:validator,
      readOnly: readOnly,
      autovalidateMode:autovalidateMode,
      cursorColor: AppColors.blueDegree,
      decoration: InputDecoration(
        suffixIcon:suffixIcon ,
        prefixIcon:prefixIcon ,
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blueDegree, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.whitegrey, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
      ),
      maxLines: maxLines,
    );
  }
}
