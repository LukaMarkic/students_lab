
import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';
import 'package:students_lab/shared/methods/ungroupedSharedMethods.dart';
import 'package:students_lab/widgets/containers/textFieldWrapper.dart';
import '../../constants.dart';
import '../../shared/methods/stringManipulationMethods.dart';


class RoundedDateField extends StatelessWidget {

  late DateTime? selectedDate;
  final VoidCallback press;
  final IconData icon;
  bool isValidateShown;


  RoundedDateField({
    Key? key,
    required this.selectedDate,
    required this.press,
    this.icon = Icons.card_giftcard,
    this.isValidateShown = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: buttonColor,),
          ConstrainedBox(
            constraints: new BoxConstraints(
              maxWidth: 140.0,
            ),
            child: Text(
                selectedDate != null ? getTimeFormat(selectedDate!) : 'Unesite datum rođenja',
                softWrap: true,
                style: TextStyle(fontSize: 16, color: !(selectedDate == null && isValidateShown) ? Colors.black45 : Colors.red), textAlign: TextAlign.center,),
          ),
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
