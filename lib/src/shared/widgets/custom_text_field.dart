import 'package:flutter/material.dart';

import '../common.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.readOnly = false,
    this.iconAsset,
    this.iconData,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autoValidate = false,
    this.focusNode,
    this.textInputType = TextInputType.number,
    this.controller,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final bool readOnly;
  final String? labelText;
  final String? iconAsset;
  final IconData? iconData;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final GestureTapCallback? onTap;
  final bool autoValidate;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextFormField(
        keyboardType: textInputType,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        obscureText: textInputType == TextInputType.visiblePassword,
        readOnly: readOnly,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          labelText: labelText,
          prefixIcon: IconButton(
            icon: iconData != null
                ? Icon(iconData, color: Colors.white)
                : Image.asset(iconAsset!, width: 20, height: 20),
            onPressed: null,
          ),
          hintStyle: const TextStyle(color: Colors.white),
          hintText: hintText,
          fillColor: kAccentAppColor.withOpacity(0.4),
          contentPadding: const EdgeInsets.only(
            left: 10,
            top: 4,
            bottom: 4,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        cursorColor: Colors.white,
      ),
    );
  }
}
