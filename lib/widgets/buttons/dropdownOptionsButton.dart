import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models.dart';


class DropdownOptionsButton extends StatefulWidget {

  List<DropdownItem> menuItems;
  var onChange;
  DropdownOptionsButton({
    Key? key,
    this.menuItems = const [],
    required this.onChange }) : super(key: key);

  @override
  State<DropdownOptionsButton> createState() => _DropdownOptionsButtonState();
}

class _DropdownOptionsButtonState extends State<DropdownOptionsButton> {



  static const String _cancelText = 'Poništi';
  DropdownItem cancel = DropdownItem(text: _cancelText, icon: const Icon(Icons.cancel), iconCancel: const Icon(Icons.cancel));
  late List<DropdownItem> secondItems = [cancel,];


  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.menu,
          size: 34,
          color: Colors.white,
        ),
        customItemsIndexes: [widget.menuItems.length],
        customItemsHeight: 8,
        items: [
          ...widget.menuItems.map(
                (item) =>
                DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: buildItem(item),
                ),
          ),
          const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          ...secondItems.map(
                (item) =>
                DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: buildItem(item),
                ),
          ),
        ],
        onChanged: widget.onChange,
        itemPadding: const EdgeInsets.only(left: 12, right: 8),
        dropdownWidth: 180,
        itemHeight: 54,
        dropdownPadding: const EdgeInsets.only(bottom: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        dropdownElevation: 8,
        offset: const Offset(40, -4),
      ),
    );
  }

  Widget buildItem(DropdownItem item) {
    return Row(
      children: [
        item.isActive ? item.icon : item.iconCancel,
        const SizedBox(
          width: 10,
        ),

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 110.0,
          ),
          child: Text(
            item.text,
            softWrap: true,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

}