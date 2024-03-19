import 'package:flutter/material.dart';

class MyTextFieldPro extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  MyTextFieldPro({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration
        (
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(100.0)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(202, 189, 189, 189)),
            ),
            fillColor: const Color.fromRGBO(87, 101, 129, 0.6),
            filled: true,
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Color.fromARGB(183, 255, 255, 255))),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
