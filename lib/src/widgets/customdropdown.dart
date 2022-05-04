import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> dropdownMenuItemList;
  final ValueChanged<T> onChanged;
  final T value;
  final bool isEnabled;
  CustomDropdown({
    Key key,
    @required this.dropdownMenuItemList,
    @required this.onChanged,
    @required this.value,
    this.isEnabled = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
        decoration: BoxDecoration(
          
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            color: Color(0xFFF7F7F7),),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            itemHeight: 55.0,
            style: TextStyle(
                fontSize: 15.0,
                color: isEnabled ? Colors.grey[700] : Colors.grey[700]),
            items: dropdownMenuItemList,
            onChanged: onChanged,
            value: value,
          ),
        ),
      ),
    );
  }
}
