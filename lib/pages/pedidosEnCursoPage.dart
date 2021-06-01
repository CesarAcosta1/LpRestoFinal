import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lp_resto_final_2/custom_icons.dart';
import 'package:lp_resto_final_2/pages/padrePage.dart';
import 'package:lp_resto_final_2/src/models/pedidosModel.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:http/http.dart' as http;

class PedidosEnCursoPage extends StatefulWidget {
  PedidosEnCursoPage({Key key}) : super(key: key);

  @override
  _PedidosEnCursoPageState createState() => _PedidosEnCursoPageState();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
}

Size size;

List<ParaEliminar> eliminar = [
  ParaEliminar(index: 0,eliminar: false),
];

class _PedidosEnCursoPageState extends State<PedidosEnCursoPage> {

  BottomDrawerController _drawerController = BottomDrawerController();
  bool _openDrawer = true;

  final nf = NumberFormat.currency(locale: "es", symbol: "Gs.", decimalDigits: 0);

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();


  Stream<http.Response> getPedidos() async* {
    yield* Stream.periodic(Duration(seconds: 2), (_) {
      return http.get(Uri.parse('https://cdn.laplata.com.py/LpResto/api/PedidosEnCurso'));
    }).asyncMap((event) async => await event);
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    var streamPedidos;
   
    return  Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            //borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
          ),
          child: ListView(
            children: [
              Column( 
                children: [
                  SizedBox(height: 30),
                  StreamBuilder<http.Response>(
                    stream: getPedidos(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return Container(
                          height: size.height * 0.7,
                          width: size.width,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      } else {
                         streamPedidos = pedidosFromJson(snapshot.data.body);
                        return Column(
                          children: List.generate(
                            streamPedidos.length, (i){
                              return pedidosEnCursoWidget(streamPedidos[i]);
                            }
                          ),
                        );
                      }
                      
                    } 
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ],
          ),
        ),
        drowerBottom()
      ],
    );
  }

  Widget pedidosEnCursoWidget(Pedidos pedido) {

    double _total = 0;
    for (var i = 0; i < pedido.productos.length; i++) {
      _total += pedido.productos[i].precio * pedido.productos[i].cantidad; 
    }

    var limites = [5,10];
    var colorsLimites = [Colors.green,Colors.orange,Colors.red];

    var diferencia = int.parse(dateTimeConverter(pedido.fechahoraPedido));
    var estadoColor = Colors.green;

    if (diferencia > 0 && diferencia <= limites[0]) {
      estadoColor = colorsLimites[0];
    }
    else if (diferencia > limites[0] && diferencia <= limites[1]) {
      estadoColor = colorsLimites[1];
    }
    else {
      estadoColor = colorsLimites[2];
    }

    return GestureDetector(
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(bottom: 10,top: 10,left: 20,right: 30),
            decoration: BoxDecoration(
              border: Border.all(width: 1,color: Colors.grey),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 15,
                  decoration: BoxDecoration(
                    color: estadoColor,
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  width: 170,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pedido.tipo.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),  
                      ),
                      Row(
                        children: [
                          Text('Cliente: ',style: TextStyle(color: Colors.grey[800]),),
                          Expanded(
                            child: Container(
                              child: Text(
                                pedido.nombreCliente,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey[800]
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('Total: ',style: TextStyle(color: Colors.grey[800]),),
                          Text(nf.format(_total).toString(),style: TextStyle(color: Colors.grey[800]),)
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 50),
                    color: Colors.transparent,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                        ),
                        onPressed: () {
                          
                        }, 
                        child: Text('Pendiente')
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
          Positioned(
            top: 18,
            right: 13,
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border:Border.all(width: 1,color: Colors.grey)
              ),
              child: Stack(
                children: [
                  Center(child: Icon(CustomIcons.reloj,size: 57,color: estadoColor,)),
                  Center(child: Text((diferencia > 99) ? '99\'' :  '$diferencia\'',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)))
                ],
              ),
            )
          )
        ],
      ),
      onTap: () {
        bool eliminarElementos = false;
        TextStyle _style = TextStyle(
          fontSize: 14
        );

        eliminar = [];

        for (var i = 0; i < pedido.productos.length; i++) {
          eliminar.add(ParaEliminar(index: i,eliminar: false)); 
        }


        showDialog(
          context: context,          
          builder: (_) => StatefulBuilder(
            builder: (context, setState) {

              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                content: Container(
                  width: size.width * 0.95,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.red,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Align(
                        child: Center(
                          child: Text(
                            'Destalle del Pedido',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(pedido.tipo, style: _style.copyWith(fontWeight: FontWeight.bold),),
                          SizedBox(width: 10),
                          Text(pedido.nombreCliente, style: _style,)
                        ],
                      ),
                      SizedBox(height: 5,),
                      Center(
                        child: Text(
                          "(Pagado)",
                          style: _style.copyWith(color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.ac_unit),
                                Text("001",style: _style,)
                              ],
                            )
                          ),
                          Expanded(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.ac_unit),
                                  Text("Alejandro",style: _style,)
                                ],
                              ),
                            )
                          ),
                          Container(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.ac_unit),
                                Text("Auto",style: _style,)
                              ],
                            )
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            child: Center(
                              child: Text('Cant.',style: _style.copyWith(fontWeight: FontWeight.bold,fontSize: 16))
                            ),
                          ),
                          Container(
                            width: 150,
                            color: Colors.blue,
                            child: Text('Producto',style: _style.copyWith(fontWeight: FontWeight.bold,fontSize: 16)),
                          ),
                          Container(
                            color: Colors.green,
                            width: 70,
                            child: Text('SubTotal',style: _style.copyWith(fontWeight: FontWeight.bold,fontSize: 16)),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text("Todos"),
                                Checkbox(
                                  value: true, 
                                  onChanged: (value) {
                                  
                                  },
                                )
                              ],
                            ),
                          )
                          // GestureDetector(
                          //   child: Container(
                          //     width: 40,
                          //     child: Center(child: (eliminarElementos) ? Icon(Icons.delete_forever,color: Colors.red) : Icon(Icons.delete)),
                          //   ),
                          //   onTap: () {
                          //     pedido.productos.removeWhere((productos) => productos.eliminar == true);
                          //     eliminarElementos = false;
                          //     setState(() {

                          //     });
                          //   },
                          // )
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: size.height * 0.3,  
                        child: ListView(
                          children: List.generate(pedido.productos.length, (i) {
                            String _descript = pedido.productos[i].producto.toString();
                            String _observa = pedido.productos[i].observaciones;
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    child: Center(
                                      child: Text(
                                        pedido.productos[i].cantidad.toString(),
                                        style: _style,
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: DefaultTextStyle.of(context).style,
                                        children:  <TextSpan>[
                                          TextSpan(text: '$_descript,'),
                                          TextSpan(text: '$_observa', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Text(
                                      nf.format(pedido.productos[i].precio * pedido.productos[i].cantidad).toString(),
                                      style: _style,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      //color: Colors.blue,
                                      width: 40,
                                      child: Center(
                                        child: Icon(Icons.delete,color: (pedido.productos[i].eliminar) ? Colors.red : Colors.grey),
                                      ),
                                    ),
                                    onTap: () {
                                      eliminarElementos = false;
                                      pedido.productos[i].eliminar = !pedido.productos[i].eliminar ;

                                      for (var x = 0; x < pedido.productos.length; x++) {
                                        //print(eliminar[x].index.toString() + ' : ' + eliminar[x].eliminar.toString());
                                        if (pedido.productos[x].eliminar) {
                                          eliminarElementos = true;
                                        }
                                      }                                

                                      setState(() {
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            child: Center(
                              child: Text(
                                'TOTAL',
                                style: _style.copyWith(fontWeight: FontWeight.bold,color: Colors.red),
                              )
                            ),
                          ),
                          Expanded(
                            child: Container()
                          ),
                          Container(
                            width: 120,
                            child: Text(
                              nf.format(_total).toString(),
                              //nf.format(pedido.productos[i].precio * pedido.productos[i].cantidad).toString(),
                              style: _style.copyWith(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: Text("Cancelar")
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red
                              ),
                              child: Text("Añadir +"),
                              onPressed: () {
                                pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                                Navigator.of(context).pop();
                                idPedido = pedido.idPedido;
                                clienteSeleccionado = pedido.nombreCliente;
                              }, 
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red
                              ),
                              onPressed: () {}, 
                              child: Text("Entregar")
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        );
      },
    );
  }

  dateTimeConverter(String date){
    final now = DateTime.parse(date);
    final date2 = DateTime.now();
    final difference = date2.difference(now).inMinutes;
    return difference.toString();
  }

  Widget drowerBottom() {
    return BottomDrawer(
      color: Colors.transparent,
      controller: _drawerController,
      header: GestureDetector(
        child: Container(
          height: size.height * 0.08,
          width: size.width,
          color: Colors.transparent,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: size.height * 0.02,
                  width: size.width,
                  color: Colors.red,
                ),
              ),
              Align(
                child: Container(
                  height: size.height * 0.08,
                  width: size.width * 0.5,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.filter_list_rounded,color: Colors.white),
                              SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    "Filtros",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ),
        onTap: () {
          _openDrawer ? _drawerController.open() : _drawerController.close();
          _openDrawer = !_openDrawer;
        }
      ), 
      body: Container(
        color: Colors.white,
      ),
      headerHeight: 60, 
      drawerHeight: size.height * 0.7,
      callback: (opened) {
        _openDrawer = !opened;
      }
    );
  }
}

class ParaEliminar {

  int index;
  bool eliminar;

  ParaEliminar({this.index,this.eliminar});

}