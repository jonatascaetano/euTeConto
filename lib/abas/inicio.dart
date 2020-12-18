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
       child: StreamBuilder<QuerySnapshot>(
       stream: FirebaseFirestore.instance.collection('contos').snapshots(),
       builder: (context, snapshot){
         switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
          if(!snapshot.hasData){
            return Center(
              child: Text('Não existem contos',
                style: TextStyle(fontSize: 32, color: Colors.grey),
              ),
            );
          }else{
            return TelaInicial(snapshot.data.docs);
          }           
        }
       }
       ),
     );
  }
}
     