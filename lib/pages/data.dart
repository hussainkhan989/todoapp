import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:random_string/random_string.dart';
import 'package:todoapp/services/database.dart';
import 'package:todoapp/utilities/util.dart';

class Data extends StatefulWidget {
  const Data({Key? key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  late DateTime selectedDate = DateTime.now(); // Variable to hold the selected date

  TextEditingController customerName = TextEditingController();
  TextEditingController customerMobileNumber = TextEditingController();
  TextEditingController functionDate = TextEditingController();
  TextEditingController functionPrice = TextEditingController();
  TextEditingController advance = TextEditingController();
  bool _isDay = true;
  String text_for_function_date = 'Select Function date';
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate; // Update the selected date variable
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add ', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.teal)),
            Text('Function ', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.deepPurple)),
            Text('data ', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.redAccent)),
            Text('here ', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.green)),
          ],
        ),
      ),
      body: Column(
        children: [
          const Gap(20),
          Utilities.textfield('Enter Customer name', customerName, TextInputType.text),
          const Gap(10),
          Utilities.textfield('Enter mobile number', customerMobileNumber, TextInputType.number),
          const Gap(10),
          InkWell(onTap: ()  {_selectDate(context);
            },
            child:   Container(
              width: 200,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 2.0,
                    color: Colors.black
                  )
                ),
                child:  Center(child: Text(text_for_function_date , style: TextStyle(fontSize: 15 ,fontWeight: FontWeight.bold),)))),
          const Gap(4),
          Container(
            width: 180,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: Colors.black
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Day'),
                Radio(value: true, groupValue: _isDay, onChanged: (bool? value) {
                  setState(() {
                    _isDay = value!;
                  });
                },),
                Text('Night'),
                const Gap(10),
                Radio(value: false, groupValue: _isDay, onChanged: (bool? value) {
                  setState(() {
                    _isDay = value!;
                  });
                },),

              ],),
          ),

          // Utilities.textfield('Function date', functionDate, TextInputType.datetime),
         // showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate)
             const Gap(10),
          Utilities.textfield('Function Price', functionPrice, TextInputType.number),
          const Gap(10),
          Utilities.textfield('Advance received', advance, TextInputType.number),
          const Gap(10),

          
          
          
          
          Utilities.button(() async {
            int functionPriceValue = int.parse(functionPrice.text.toString());
            int advanceValue = int.parse(advance.text.toString());
            int mobileNumber = int.parse(customerMobileNumber.text.toString());




            Map<String , dynamic> addDetailsMap = {
              'CustomerName' : customerName.text,
              'customerMobileNum' : mobileNumber,
              'functionDate' : selectedDate,
              'functionPrice' : functionPriceValue,
              'advanceReceived' : advanceValue,
              'dayornight' : _isDay
            };

            await DatabaseMethods().adddetails(addDetailsMap, customerMobileNumber.text).then((value) {
              Fluttertoast.showToast(
                  msg: "Details added successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            });
          }, 'Add Data'),
        ],
      ),
    );
  }
}
