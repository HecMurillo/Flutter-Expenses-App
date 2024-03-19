import 'package:flutter/material.dart';

class ReasonsButton extends StatefulWidget {
  final Function()? onTap;

  const ReasonsButton({Key? key, required this.onTap}) : super(key: key);

  @override
  State<ReasonsButton> createState() => _ReasonsButtonState();
}

class _ReasonsButtonState extends State<ReasonsButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color.fromARGB(130, 60, 60, 60)
                : const Color.fromARGB(160, 88, 88, 88),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
