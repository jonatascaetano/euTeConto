import 'package:Confidence/telas/tela_lista_salvos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TelaSalvo extends StatefulWidget {

  String uid;
  TelaSalvo(this.uid);

  @override
  _TelaSalvoState createState() => _TelaSalvoState();
}

class _TelaSalvoState extends State<TelaSalvo> {


  @override
  Widget build(BuildContext context) {
  return Container(
       color:  Color(0xff0f1b1b),
       child: FutureBuilder<QuerySnapshot>(
       future: FirebaseFirestore.instance.collection('usuarios').doc(widget.uid).collection('salvos').orderBy('data').get(),
       builder: (context, snapshot){
         switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
             return Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xffb34700),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffb34700))
              ),
              
            );
            break;
          default:
          if(snapshot.data.docs.length ==0 ){
                  return Center(
                    child: Text('Nada encontrado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }else{
                  List<DocumentSnapshot> documentSnapshot = List();
                  snapshot.data.docs.forEach((element) async {
                      String idConto = element.data()['conto']; 
                      DocumentSnapshot document = await FirebaseFirestore.instance.collection('contos').doc(idConto).get();                  
                      print(document.data()['titulo']);
                      documentSnapshot.add(document);
                      });
                  
            return TelaListaSalvos(documentSnapshot);
          }           
        }
       }
       ),
     );
  }
}