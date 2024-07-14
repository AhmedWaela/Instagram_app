import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget{
  const CustomTextFormField({super.key, required this.controller, required this.hintText, required this.keyboardType,  this.isPass = false, this.validator, this.onSaved, this.fillColor= const Color(0xffdddbde), required this.icon});
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPass;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Color? fillColor;
  final IconData icon;
  @override
  Widget build(BuildContext context){
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: buildBorder(),
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: buildBorder(),
        filled: true,
        fillColor: fillColor
      ),
      keyboardType: keyboardType,
      obscureText: isPass,
    );
  }

  OutlineInputBorder buildBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        width: 0,
        style: BorderStyle.none
      )
    );
  }
}