import 'package:flutter/material.dart';

class Utilities{
  static textfield(String hinttext ,TextEditingController controller, TextInputType type ){
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
          hintText: hinttext,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
          )
      ),
    );

  }
  static button(VoidCallback buttonaction, String buttonname){
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(10),
        foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.teal)
      ),
        
        onPressed: buttonaction, child: Text(buttonname));
  }

  static Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }


  static radiobutton(bool value, bool groupValue, Function(bool?) onChanged){

    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

}