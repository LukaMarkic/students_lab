
import 'package:flutter/material.dart';
import 'package:students_lab/widgets/containers/textFieldWrapper.dart';
import '../../constants.dart';


class RoundedDoubleInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedDoubleInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.email_outlined,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldWrapper(
      borderRadius: 5,
      color: Colors.white,
      child: TextFormField(
        validator: (title) => title != null && title.isEmpty ? 'Potrebno unijeti trajanje' : null,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        onSaved: (value) {
          onChanged;
        },
        cursorColor: buttonColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: buttonColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black45),
          border: InputBorder.none,
        ),
      ),
    );
  }
}