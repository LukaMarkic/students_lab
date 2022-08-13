
import 'package:flutter/material.dart';
import 'package:students_lab/widgets/containers/textFieldWrapper.dart';
import '../../constants.dart';


class RoundedSelectYear extends StatelessWidget {

  late int? godinaStudija;
  final ValueChanged onChanged;
  bool isValidateShown;
  RoundedSelectYear({
    Key? key,
    this.godinaStudija,
    required this.onChanged,
    this.isValidateShown = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.school, color: buttonColor,),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 140.0,
            ),
            child: Text(
              godinaStudija == null ? 'Odaberite godinu studija' : '$godinaStudija. godina studija',
              softWrap: true,
              style: TextStyle(fontSize: 16, color: !(godinaStudija == null && isValidateShown) ? Colors.black45 : Colors.red), textAlign: TextAlign.center,),
          ),
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
