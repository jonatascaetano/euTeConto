import 'package:Confidence/telas/conto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MeusComentarios extends StatefulWidget {

  List<QueryDocumentSnapshot> listaComentarios;

  MeusComentarios(this.listaComentarios);

  @override
  _MeusComentariosState createState() => _MeusComentariosState();
}

class _MeusComentariosState extends State<MeusComentarios> {

    Map<String, dynamic> comentarios = Map();

    int comentariosNum;

    comentariosNumero(idConto) async {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('contos').doc(idConto).get();
      setState(() {
        comentariosNum = documentSnapshot.data()['comentarios'];
      });
    }

  String autor;

    recuperarUsuario(){
      setState(() {
        autor = FirebaseAuth.instance.currentUser.uid;
      });
    }

    @override
    void initState() {
      super.initState();
      recuperarUsuario();
    }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(           
              itemCount: widget.listaComentarios.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
                color: Colors.black,
                thickness: 1.0,
              ),
              itemBuilder: (context, index){
                 initializeDateFormatting('pt_BR');
                 var formatador = DateFormat('d/M/y H:mm');
                 String dataFormatada = formatador.format(widget.listaComentarios[index]['data'].toDate());
                 
                return Container(
                    padding: EdgeInsets.all(12),
                    width: MediaQuery.of(context).size.width * 0.8,
                    //color: Colors.black26,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Text(
                              widget.listaComentarios[index]['titulo'],
                              maxLines: 3,
                              style: TextStyle(color: Colors.white, fontSize: 14.0),
                            ),
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> Conto(widget.listaComentarios[index]['conto']))
                              );
                            },
                        ),
                        SizedBox(
                          height: 8,
                        ),

                        Text(
                         widget.listaComentarios[index]['texto'],                     
                          style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            
                            Text(
                              dataFormatada.toString(),
                              style: TextStyle(color: Color(0xffb34700), fontSize: 14.0),
                            ),

                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: Color(0xffb34700),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: (context),
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Excluir comentario',
                                                style: TextStyle(
                                                  fontSize: 14
                                                ),
                                              ),
                                              
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancelar')),
                                                FlatButton(
                                                    onPressed: () {
                                                      comentariosNumero(widget.listaComentarios[index]['conto']);
                                                      if(comentariosNum!= null){
                                                        FirebaseFirestore.instance.collection('comentarios').doc(autor).collection('comentarios').doc(widget.listaComentarios[index].reference.id).delete();
                                                        FirebaseFirestore.instance.collection('contos').doc(widget.listaComentarios[index]['conto']).collection('comentarios').doc(widget.listaComentarios[index].reference.id).delete();
                                                        FirebaseFirestore.instance.collection('contos').doc(widget.listaComentarios[index]['conto']).update({
                                                          'comentarios' : comentariosNum - 1
                                                        });
                                                        comentariosNumero(widget.listaComentarios[index]['conto']);
                                                        Navigator.of(context).pop();
                                                      }else{
                                                        FirebaseFirestore.instance.collection('comentarios').doc(autor).collection('comentarios').doc(widget.listaComentarios[index].reference.id).delete();
                                                        Navigator.of(context).pop();
                                                      }
                                                      
                                                    },
                                                    child: Text('Excluir')),
                                              ],
                                            );
                                          }
                                          );
                                    }
                                    ),
                              ],
                            ))
                          ],
                        ),                                            
                      ],
                    ),
                  );
              },
              );
  }
}