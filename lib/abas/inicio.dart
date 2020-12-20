import 'package:Confidence/widgets/tela_inicial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {   
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
            return TelaInicial(snapshot.data.docs.reversed.toList());
          }           
        }
       }
       ),
     );
  }
}
     