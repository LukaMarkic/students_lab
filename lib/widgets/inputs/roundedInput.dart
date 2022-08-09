
import 'package:flutter/material.dart';
import 'package:students_lab/widgets/containers/textFieldWrapper.dart';
import '../../constants.dart';


class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final Color color;
  final Color textColor;
  final Color textHintColor;
  final Color iconColor;
  final double borderRadius;
  final String validatorMessage;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.email_outlined,
    required this.onChanged,
    this.color = keyPrimaryColor,
    this.textColor = Colors.black,
    this.textHintColor = Colors.black45,
    this.iconColor = buttonColor,
    this.borderRadius = 20.0,
    this.validatorMessage = 'Potrebno ispuniti'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldWrapper(
      borderRadius: borderRadius,
      color: color,
      child: TextFormField(
        validator: (title) => title != null && title.isEmpty ? validatorMessage : null,
        style: TextStyle(color: textColor),
        onChanged: onChanged,
        onSaved: (value) {
          onChanged;
        },
        cursorColor: iconColor,
        minLines: 1,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: iconColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: textHintColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}