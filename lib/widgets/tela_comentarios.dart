import 'package:flutter/material.dart';

class TelaComentarios extends StatefulWidget {
  @override
  _TelaComentariosState createState() => _TelaComentariosState();
}

class _TelaComentariosState extends State<TelaComentarios> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Text('Comentarios'),
      ),
    );
  }
}