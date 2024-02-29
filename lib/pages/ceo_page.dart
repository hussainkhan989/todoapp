import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';
import 'home.dart';

class ceo extends StatefulWidget {
  const ceo({super.key});

  @override
  State<ceo> createState() => _ceoState();
}

class _ceoState extends State<ceo> {
  Stream? datastream;
  int total_funtions = 0;
  getalldata() async {
    datastream = await DatabaseMethods().getonlycurrentfunction();
    setState(() {});
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

  /*Widget ceodata() {
    return StreamBuilder(
      stream: datastream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text('No data available'));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              int data = ds['functionPrice'];
              return Material(
                elevation: 2.0,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text('hello'),
                      Text('all data: $data'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }*/

  // Define a function to calculate the total function price
  Future<double> calculateTotalFunctionPrice() async {
    double totalFunctionPrice = 0.0;

    // Use Firestore to query the collection and retrieve documents
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Funtiondetails').get();

    // Iterate through the documents and sum up the function prices
    for (var document in querySnapshot.docs) {
      if (document.exists) {
        int? functionPrice =
            (document.data() as Map<String, dynamic>)['functionPrice'];

        totalFunctionPrice += functionPrice!;
      }
    }

    return totalFunctionPrice;
  }

  Future<double> totalfunctionprice() async {
    double price = 0.0;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Funtiondetails').get();
    for (var documents in querySnapshot.docs) {
      int? functionprices =
          (documents.data() as Map<String, dynamic>)['functionPrice'];
      price += functionprices!;
    }

    return price;
  }

  Future<QuerySnapshot> totalfunctions() async {
    DateTime dateTime = DateTime.now();
    QuerySnapshot querySnapshot = (await FirebaseFirestore.instance
        .collection('Funtiondetails')
        .where('functionDate', isGreaterThan: Timestamp.fromDate(dateTime))
        .get());
    return querySnapshot;
  }

  Widget data() {
    double totalprice = 0;
    double spend = 0.0;
    return StreamBuilder(
        stream: datastream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // spend = (snapshot.data())['spend_on_this_function'];

            for (var spendd in snapshot.data.docs) {
              spend += (spendd.data())['spend_on_this_function'];
            }
            for (var document in snapshot.data.docs) {
              totalprice += (document.data())['functionPrice'];
            }
          }
          return snapshot.hasData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'All Function prices: $totalprice',
                      style: const TextStyle(
                          fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      'Total Functions : ${snapshot.data.docs.length}',
                      style: const TextStyle(
                          fontSize: 17, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      'My total profit : ${totalprice - spend}',
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                    )
                  ],
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const homepage(),));
      },),
      appBar: AppBar(
        title: const Text('CEO Insights'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('Total Number of Functions: $total_funtions' , style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 2.0,
                child: data(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
