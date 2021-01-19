import 'package:Confidence/telas/tela_lista_biblioteca.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class TelaBiblioteca extends StatefulWidget {

  String uid;

  TelaBiblioteca(this.uid);

  @override
  _TelaBibliotecaState createState() => _TelaBibliotecaState();
}

class _TelaBibliotecaState extends State<TelaBiblioteca> {



  @override
  Widget build(BuildContext context) {

    print('uid recebido ' + widget.uid);
    return Container(
      color:  Color(0xff0f1b1b), 
       child: StreamBuilder<QuerySnapshot>(
       stream: FirebaseFirestore.instance.collection('contos').orderBy('data').snapshots(),
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
          List<QueryDocumentSnapshot> queryDocumentSnapshot = List();
                  snapshot.data.docs.forEach((element) {
                    if(element.data()['autor'] == widget.uid){
                      queryDocumentSnapshot.add(element);
                      }
                  });
          if(queryDocumentSnapshot.length ==0 ){
            
            print('nada encontrado');
                  return Center(
                    child: Text('Nada encontrado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }else{
                  print('encontrado dados' + snapshot.data.docs.length.toString() );  
                  List<QueryDocumentSnapshot> queryDocumentSnapshot = List();
                  snapshot.data.docs.forEach((element) {
                    if(element.data()['autor'] == widget.uid){
                      queryDocumentSnapshot.add(element);
                      }
                  });
            return TelaListaBiblioteca(queryDocumentSnapshot.reversed.toList());
          }           
        }
       }
       ),
     );
  }
}

