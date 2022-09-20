import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<DocumentSnapshot> documents = [];

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              color: Color(0xFF4BC0C8)
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('List of deliveries',style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.black87)),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {

                      },
                      child: Text("Road Map"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("delivery").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(!snapshot.hasData)
                      {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      documents = snapshot.data!.docs;
                      return ListView(
                        children: documents.map((document){
                          //String name = document['name'].toString();
                          return Padding(
                            padding: const EdgeInsets.all(14),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey, width: 1),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Center(
                                  child: ListTile(
                                    onTap: ((){

                                    }),
                                    title: Padding(
                                        padding: const EdgeInsets.only(bottom: 3.0),
                                        child: Row(
                                          children: [
                                            Text(document['name'],style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.black87)),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.euro, color: Colors.black54,),
                                                  Text(document['bill'].toString(),style: new TextStyle(color: Colors.black87))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    subtitle: Text(document['address'].toString(),style: new TextStyle(color: Colors.black87))
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
