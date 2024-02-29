import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';
import 'data.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Stream? datastream;
  getalldata() async{
    datastream = await DatabaseMethods().getalldetails();
    setState(() {

    });
  }
 @override
  void initState() {
    getalldata();
    super.initState();
  }
  @override
  void dispose() {
    getalldata();
    super.dispose();
  }

  // Define a function to calculate the total function price
  Future<double> calculateTotalFunctionPrice() async {
    double totalFunctionPrice = 0.0;

    // Use Firestore to query the collection and retrieve documents
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Funtiondetails').get();

    // Iterate through the documents and sum up the function prices
    for (var document in querySnapshot.docs) {
      if (document.exists) {
        int? functionPrice = (document.data() as Map<String, dynamic>)['functionPrice'];

        totalFunctionPrice += functionPrice!;
      }
    }

    return totalFunctionPrice;
  }
  String time = 'Day';



  Widget alldetails(){
    return StreamBuilder(
        stream: datastream,
        builder: (context , AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context , index){
            DocumentSnapshot ds =  snapshot.data.docs[index];
            int func = ds['functionPrice'];
            int adv = ds['advanceReceived'];
            int mob =ds['customerMobileNum'];
            Timestamp date = ds['functionDate'];
            DateTime dateTime = date.toDate();
            String excatdate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
            bool dayornight =  ds['dayornight'];
            if(dayornight == true){
             time = 'Day';
            }else
            {
              time = 'Night';
            }

            return Padding(
              padding: const EdgeInsets.only(left: 20 , right: 20 , top: 20),
              child: Material(
                elevation: 5.0,

                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name :'  +ds['CustomerName'] , style: const TextStyle(color: Colors.black ,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('Mobile Number : $mob' , style: const TextStyle(color: Colors.black ,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('Funtion Price :$func'  , style: const TextStyle(color: Colors.black ,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('Advance Recieved :$adv' , style: const TextStyle(color: Colors.black ,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('Function Date :$excatdate'  , style: const TextStyle(color: Colors.black ,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text('Function Time : $time'  , style: const TextStyle(color: Colors.black ,fontWeight: FontWeight.bold,fontSize: 20),),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }) : Container();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Data(),));},child: Icon(Icons.add),),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Galaxy ',style: TextStyle(fontWeight: FontWeight.bold , color: Colors.teal),),
            Text('Weeding ',style: TextStyle(fontWeight: FontWeight.bold , color: Colors.deepPurple),),
            Text('Hall ',style: TextStyle(fontWeight: FontWeight.bold , color: Colors.orange),),

          ],
        )
      ),
      body: Column(
        children: [
          Expanded(child: alldetails()),
          ElevatedButton(onPressed: () async {
            double total = await calculateTotalFunctionPrice();
            print('Total Function Price: $total');
          }, child: const Text('click'))
        ],
      ),
    );
  }
}
