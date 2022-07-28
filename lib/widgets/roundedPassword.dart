
import 'package:flutter/material.dart';
import 'package:students_lab/widgets/textField.dart';
import '../constants.dart';


class RoundedHiddenField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final IconData icon;
  const RoundedHiddenField({
    Key? key,
    required this.onChanged,
    required this.hintText,
    this.icon = Icons.lock,

  }) : super(key: key);

  @override
  State<RoundedHiddenField> createState() => _RoundedHiddenFieldState();
}

class _RoundedHiddenFieldState extends State<RoundedHiddenField> {
  bool obscureTextStatus = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: obscureTextStatus,
        onChanged: widget.onChanged,
        cursorColor: buttonColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black45),
          icon: Icon (widget.icon, color: buttonColor,),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.visibility,
              color: Colors.black54,
            ),
            tooltip: 'Prikaži!',
            onPressed: () {
              setState(() {
                obscureTextStatus = !obscureTextStatus;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}