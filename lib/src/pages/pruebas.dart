import 'package:flutter/material.dart';

import 'package:lp_resto_final_2/widgets/BottomNav.dart';
import 'package:lp_resto_final_2/widgets/Tags.dart';


class Pruebas extends StatefulWidget {
  Pruebas({Key key}) : super(key: key);

  @override
  _PruebasState createState() => _PruebasState();
}

List<Categorias> categorias = [
  Categorias(
    active: false,
    categoria: "Bebidas",
    tags: [
      "SinAlcohol",
      "ConAlcohol",
      "ConAzucar",
      "SinAzucar"
    ]
  ),
  Categorias(
    active: false,
    categoria: "Hamburguesas",
    tags: [
      "ConTomate",
      "SinTomate"
    ]
  ),
  Categorias(
    active: false,
    categoria: "Bebidas",
    tags: [
      "SinAlcohol",
      "ConAlcohol",
      "ConAzucar",
      "SinAzucar"
    ]
  ),
  Categorias(
    active: false,
    categoria: "Hamburguesas",
    tags: [
      "ConTomate",
      "SinTomate"
    ]
  ),
  Categorias(
    active: false,
    categoria: "Bebidas",
    tags: [
      "SinAlcohol",
      "ConAlcohol",
      "ConAzucar",
      "SinAzucar"
    ]
  ),
  Categorias(
    active: false,
    categoria: "Hamburguesas",
    tags: [
      "ConTomate",
      "SinTomate"
    ]
  )
];

List<Products> productos = [
  Products(
    categoria: "Bebidas",
    nombre: "Pilsen 1L",
    precio: 10000,
    tags: [
      "ConAlcohol"
    ] 
  ),
  Products(
    categoria: "Bebidas",
    nombre: "Pilsen 1.5L",
    precio: 15000,
    tags: [
      "ConAlcohol"
    ] 
  ),
  Products(
    categoria: "Bebidas",
    nombre: "Coca Cola 2l",
    precio: 10000,
    tags: [
      "SinAlcohol"
    ] 
  ),
];

int categoriaSeleccionada;
List<bool> actives = [];

List<Products> productFilter = [];

class _PruebasState extends State<Pruebas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(" MENÚ ",style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.white,
        // elevation: 0,
        // shadowColor: Colors.transparent,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Text("Categorias",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.grey[800])),
              ),
              Wrap(
                children: List.generate(
                  categorias.length, (i) => GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(1.0, 2.0), 
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.fastfood,size: 60,color: Colors.grey[800],),
                          Text(categorias[i].categoria,style: TextStyle(color: Colors.grey[800]),)
                        ],
                      )
                    ),
                    onTap: () {
                      categoriaSeleccionada = i;
                      actives.clear();
                      Navigator.push(context,MaterialPageRoute(builder: (context) => SecondRoute()),);
                      setState(() {});
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text("Destacado",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.grey[800])),
              ),
              // Container(
              //   margin: EdgeInsets.all(10),
              //   child: Text("Tags",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              // ),
              // (categoriaSeleccionada != null) ? Container(
              //   margin: EdgeInsets.symmetric(vertical: 5),
              //   child: Align(
              //     alignment: Alignment.topCenter,
              //     child: Wrap(
              //       children: List.generate(categorias[categoriaSeleccionada].tags.length, (i) {

              //         List<String> tags = categorias[categoriaSeleccionada].tags;

              //         for (var i = 0; i < categorias[categoriaSeleccionada].tags.length; i++) {
              //           actives.add(false);
              //         }

              //         return GestureDetector(
              //           child: Tag(
              //             text: tags[i],
              //             active: actives[i],
              //             activeColor: Colors.red,
              //             inactiveColor: Colors.grey,
              //           ),
              //           onTap: () {
              //             actives[i] = !actives[i];
 

              //             setState(() {});
              //           },
              //         );
              //       }),
              //     ),
              //     // child: Wrap(
              //     //   alignment: WrapAlignment.center,
              //     //   children: List.generate(tags.length, (index) => 
              //     //     GestureDetector(
              //     //       child: Tag(
              //     //         text: tags[index].nombre,
              //     //         activeColor: Colors.red,
              //     //         inactiveColor: Colors.grey,
              //     //         active: tags[index].active,
              //     //       ),
              //     //       onTap: () {
              //     //         tags[index].active = !tags[index].active; 
              //     //         setState(() {
                            
              //     //         });
              //     //       },
              //     //     ),
              //     //   ),
              //     // ),
                
              //   ),
              // ) : Container(),
              // Container(
              //   margin: EdgeInsets.all(10),
              //   child: Text("Productos",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              // ),
              // Column(
              //   children: List.generate(10, (o) {
              //     return Container(
              //       margin: EdgeInsets.symmetric(vertical: 5),
              //        height: 50,
              //        color: Colors.black,
              //     );
              //   }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class Categorias {

  String categoria;
  List<String> tags;
  bool active;

  Categorias({this.active,this.categoria,this.tags});

}

class Products {

  String nombre;
  double precio;
  String categoria;
  List<String> tags;

  Products(
    {
      this.nombre,
      this.precio,
      this.categoria,
      this.tags
    }
  );

}
class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categorias[categoriaSeleccionada].categoria,style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
              Navigator.pop(context);
          }, 
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (categoriaSeleccionada != null) ? Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Wrap(
                    children: List.generate(categorias[categoriaSeleccionada].tags.length, (i) {

                      List<String> tags = categorias[categoriaSeleccionada].tags;

                      for (var i = 0; i < categorias[categoriaSeleccionada].tags.length; i++) {
                        actives.add(false);
                      }

                      return GestureDetector(
                        child: Tag(
                          text: tags[i],
                          active: actives[i],
                          activeColor: Colors.red,
                          inactiveColor: Colors.grey,
                        ),
                        onTap: () {
                          actives[i] = !actives[i];
 
                          for (var d = 0; d < categorias[categoriaSeleccionada].tags.length; d++) {
                            if (actives[d]) {
                              print(categorias[categoriaSeleccionada].tags[d]);
                            }
                          }
                          setState(() {});
                        },
                      );
                    }),
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      )
    );
  }
}