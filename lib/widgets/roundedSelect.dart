
import 'package:flutter/material.dart';
import 'package:students_lab/widgets/textField.dart';
import '../constants.dart';


class RoundedSelect extends StatelessWidget {

  late int? godinaStudija;
  final ValueChanged onChanged;
  RoundedSelect({
    Key? key,
    this.godinaStudija,
    required this.onChanged,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.school, color: buttonColor,),
          Text(
           godinaStudija == null ? 'Odaberite\ngodinu studija' : '$godinaStudija. godina studija',
            style: TextStyle(fontSize: 16, color: Colors.black45),textAlign: TextAlign.center,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.lightGreen,

            ),
            alignment: Alignment.center,
            width: 45,
            child: DropdownButton<int>(
            value: godinaStudija,
            elevation: 16,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            onChanged: onChanged,
            items: <int>[1, 2, 3, 4, 5]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value.'),
              );
            }).toList(),
          )
          ),

        ],
      ),
    );
  }





}
