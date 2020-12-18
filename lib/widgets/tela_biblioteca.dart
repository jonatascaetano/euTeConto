import 'package:flutter/material.dart';

class TelaBiblioteca extends StatefulWidget {
  @override
  _TelaBibliotecaState createState() => _TelaBibliotecaState();
}

class _TelaBibliotecaState extends State<TelaBiblioteca> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Text('Biblioteca'),
      ),
    );
  }
}