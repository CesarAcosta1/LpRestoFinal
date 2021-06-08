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
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.red,
            )
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: Colors.blue,
              child: ListView(
                children: List.generate(10, (index) => Container(height: 50,width: 50,color: Colors.white,margin: EdgeInsets.all(10),)),
              ),

            )
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
            )
          )
        ],
      ),
    );
  }
}