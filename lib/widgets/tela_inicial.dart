import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TelaInicial extends StatefulWidget {

  List<QueryDocumentSnapshot> listaContos;

  TelaInicial(this.listaContos);


  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: ListView.separated(
              padding: EdgeInsets.only(top: 5.0),
              itemCount: widget.listaContos.length,
              separatorBuilder: (context, index) => Divider( height: 5.0, color: Colors.black, thickness: 1.0,),
              itemBuilder: (context, index){                             
                return Container(
                  padding: EdgeInsets.all(12),
                  color:  Color(0xff0f1b1b), 
                  child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [

                    SizedBox(height: 8,),

                    Wrap(
                      children: [
                        Text(widget.listaContos[index]['titulo'],
                          maxLines: 2,                     
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                            ),
                        ),
                        Text(widget.listaContos[index]['categoria'],
                          maxLines: 1,                     
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0
                            ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8,),

                   Text(DateTime.now().toString(),
                      style: TextStyle(
                        color: Color(0xffb34700),
                      ),
                    ),

                    SizedBox(height: 8,),

                    Divider( height: 5.0, color: Colors.grey[600], thickness: 1.0,),

                    SizedBox(height: 8,),

                    Image.network(widget.listaContos[index]['imagem'], fit: BoxFit.cover, width: MediaQuery.of(context).size.width,),

                    SizedBox(height: 8,),

                    Wrap(
                      children: [
                        Text(widget.listaContos[index]['texto'],
                          maxLines: 2,                
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.0
                            ),
                        ),

                        GestureDetector(
                          child: Text('ver mais',                
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.0
                            ),
                        ),
                          onTap: (){

                          },
                        )
                      ],
                    ),

                    SizedBox(height: 8,),

                    Divider( height: 5.0, color: Colors.grey[600], thickness: 1.0,),

                    SizedBox(height: 8,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Row(
                          children: [
                            Text(widget.listaContos[index]['curtidas'].toString(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                          color: Color(0xffb34700),
                          fontSize: 18.0
                          ),
                        ),
                        
                        IconButton(
                          icon: Icon(Icons.thumb_up_alt_outlined,
                            color: Color(0xffb34700),
                          ),
                           onPressed: (){}
                           ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(widget.listaContos[index]['comentarios'].toString(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                          color: Color(0xffb34700),
                          fontSize: 18.0
                          ),
                        ),

                        IconButton(
                          icon: Icon(Icons.mode_comment_outlined,
                            color: Color(0xffb34700)
                          ),
                           onPressed: (){}
                           ),
                          ],
                        ),   

                        IconButton(
                          icon: Icon(Icons.more_vert_outlined,
                            color: Color(0xffb34700),
                          ),
                           onPressed: (){}
                           ),

                      ],                    
                    ),
                    SizedBox(height: 8,),
                  ],
                ),
           );
        }
      ),  
     );  
  }
}