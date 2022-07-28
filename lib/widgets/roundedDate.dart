
import 'package:flutter/material.dart';
import 'package:students_lab/widgets/textField.dart';
import '../constants.dart';


class RoundedDateField extends StatelessWidget {

  late String selectedDate;
  final VoidCallback press;
  final IconData icon;
  RoundedDateField({
    Key? key,
    required this.selectedDate,
    required this.press,
    this.icon = Icons.card_giftcard,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: buttonColor,),
          Text(
               selectedDate,
            style: TextStyle(fontSize: 16, color: Colors.black45),),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.lightGreen,

            ),
            child: IconButton(
              onPressed: press,
              icon: Icon(Icons.today,),
              tooltip: 'Odaberi datum!',
            ),
          ),

        ],
      ),
    );
  }





}
