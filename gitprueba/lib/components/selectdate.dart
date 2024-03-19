import 'package:flutter/material.dart';
import 'package:gitprueba/components/textfield.dart'; // Asegúrate de importar MyTextField o el componente que estés usando

class MySelectDate extends StatefulWidget {
  final TextEditingController controller;

  const MySelectDate({Key? key, required this.controller}) : super(key: key);

  @override
  _MySelectDateState createState() => _MySelectDateState();
}

class _MySelectDateState extends State<MySelectDate> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: MyTextField(
          controller: widget.controller,
          hintText: 'Date',
          obscureText: false,
        ),
      ),
    );
  }
}

