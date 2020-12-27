import 'dart:ui';

import 'package:Confidence/widgets/tela_inicial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate<String> {

  @override
   String get searchFieldLabel => 'Pesquisar';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Color(0xff0f1b1b),
      backgroundColor: Color(0xff0f1b1b),
      accentColor: Color(0xff0f1b1b),
      primaryIconTheme: IconThemeData(
      color: Colors.white,
      ),
      textTheme: TextTheme(
          headline6: TextStyle(color: Colors.white)
          ),
     inputDecorationTheme: InputDecorationTheme(
      hintStyle:
        Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey[600]),
       ),  
      );
    }

  @override
  List<Widget> buildActions(BuildContext context) {
      return [       
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            query = ' ';
          }
          )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            close(context, ' ');
          }
        );
    }
  
    @override
    Widget buildResults(BuildContext context) {
       return Container();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {

     if(query.isNotEmpty){
      return FutureBuilder<QuerySnapshot>(
       future: FirebaseFirestore.instance.collection('contos').orderBy('data').get(),
       builder: (context, snapshot){
         switch(snapshot.connectionState){
          case ConnectionState.none:            
          case ConnectionState.waiting:
            return Container(
              color: Color(0xff0f1b1b),
            );
            break;
          default:
          List<QueryDocumentSnapshot> queryDocumentSnapshot = List();
                  snapshot.data.docs.forEach((element) {
                    if(element.data()['titulo'].toString().toLowerCase().contains(query.toLowerCase())){
                      queryDocumentSnapshot.add(element);
                      }
                  });
          if(queryDocumentSnapshot.length == 0 ){
                  return Container(
                    color: Color(0xff0f1b1b),
                    child: Center(
                    child: Text('Nada encontrado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  );
                }else{
                    
            return Container(
               color: Color(0xff0f1b1b),
              child: TelaInicial(queryDocumentSnapshot.reversed.toList()),
            );
          }           
        }
       }
       );
     }else{
       return Container(
          color: Color(0xff0f1b1b),
       );
     }    
  }
}