import 'package:flutter/material.dart';

class PagoFacturacionPage extends StatefulWidget {
  @override
  _PagoFacturacionPageState createState() => _PagoFacturacionPageState();
}

class _PagoFacturacionPageState extends State<PagoFacturacionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("PAGO Y FACTURACION",style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    Text("MESA 8",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    Text("TOTAL: 00.000.000 Gs",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("añadir otra factura"),
                  Icon(Icons.add_circle_sharp)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}