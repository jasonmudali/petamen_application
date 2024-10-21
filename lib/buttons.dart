import 'package:flutter/material.dart';
import 'package:aplikasi_petamen/colors.dart';

class OKButton extends StatelessWidget {
  const OKButton({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(),
      color: tdBGColor,
      child: Text("Save"),
    );
  }
}
