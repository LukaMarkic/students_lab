
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';


class SortWidget extends StatefulWidget {

  late String? parameter;
  final ValueChanged onChanged;
  List<String> list;
  Widget child;

  SortWidget({
    Key? key,
    required this.onChanged,
    this.parameter,
    this.list = const [],
    required this.child,
  }) : super(key: key);

  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  final controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: size.width*0.92,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.black26),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8,),
        child:
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
            decoration: BoxDecoration(
              color: Colors.white10,
          ),child:
                SelectWidget(title: 'Sortiraj prema',child: DropdownButton<String>(
                  underline: Container(),
                  iconEnabledColor: Colors.black,
                  dropdownColor: Colors.white,
                  alignment: AlignmentDirectional.center,
                  value: widget.parameter,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  onChanged: widget.onChanged,
                  items: widget.list
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ),
            ),

            Container(
              height: 32,
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(border:  Border(
                left: BorderSide(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),),
                child: widget.child,
            ),
          ],
        ),
        ),
    );
  }
}


class SelectWidget extends StatelessWidget{
  final String title;
  final child;

  SelectWidget({this.title = '', this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
       ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            softWrap: true,
            style: TextStyle(fontSize: 16, color: Colors.black45),textAlign: TextAlign.center,),
          Container(
              height: 32,
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.circular(5),
                border: Border.all(color: Colors.black26),
              ),
              alignment: Alignment.center,
              child: child,
          ),
        ],
      ),
    );
  }


}