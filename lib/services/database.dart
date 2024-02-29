import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future adddetails(Map<String , dynamic> adddetailsMap, String id) async{
    return await FirebaseFirestore.instance.collection("Funtiondetails").doc(id).set(adddetailsMap);

  }
  Future<Stream<QuerySnapshot>> getalldetails() async{
    return await FirebaseFirestore.instance.collection('Funtiondetails').snapshots();
  }

   DateTime dateTime = DateTime.now();
  Future<Stream<QuerySnapshot>> getonlycurrentfunction() async{
    return await FirebaseFirestore.instance.collection('Funtiondetails').where('functionDate',isGreaterThan: Timestamp.fromDate(dateTime)).snapshots();
  }
}