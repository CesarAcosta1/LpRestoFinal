import 'package:flutter/material.dart';

import 'package:lp_resto_final_2/widgets/BottomNav.dart';


class Pruebas extends StatefulWidget {
  Pruebas({Key key}) : super(key: key);

  @override
  _PruebasState createState() => _PruebasState();
}

class _PruebasState extends State<Pruebas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
      ),
      appBar: AppBar(
        title: Text("Pruebas"),
      ),
      body: Column(
        children: [
          Center(

          )
        ],
      ),
    );
  }
}