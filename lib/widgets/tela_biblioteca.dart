import 'package:Confidence/widgets/tela_inicial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          if(snapshot.data.docs.length ==0 ){
                  return Center(
                    child: Text('Nada encontrado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }else{  
                  List<QueryDocumentSnapshot> queryDocumentSnapshot = List();
                  snapshot.data.docs.forEach((element) {
                    if(element.data()['autor'] == widget.uid){
                      queryDocumentSnapshot.add(element);
                      }
                  });
            return TelaInicial(queryDocumentSnapshot.reversed.toList());
          }           
        }
       }
       ),
     );
  }
}

