import 'package:flutter/material.dart';
import 'package:lp_resto_final_2/src/pages/manuPage.dart';
import 'package:lp_resto_final_2/src/pages/padrePage.dart';

import 'package:lp_resto_final_2/widgets/OptionButton.dart';

class PedidosDetalles extends StatefulWidget {
  PedidosDetalles({Key key}) : super(key: key);

  @override
  _PedidosDetallesState createState() => _PedidosDetallesState();
}

Size size;
TextStyle _style = TextStyle(fontWeight: FontWeight.bold,fontSize: 16);
TextStyle _style2 = TextStyle(fontSize: 15);

bool allSelect = false;
bool select = false;

List<int> cantidad = [];
List<TextEditingController> controllers = [];

bool selectProductos = false;

class _PedidosDetallesState extends State<PedidosDetalles> {

  @override
  Widget build(BuildContext context) {
  
    size = MediaQuery.of(context).size;

      

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles del Pedido",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        centerTitle: true,
        backgroundColor: Colors.red,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: selectProductos ? Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 100,
            child: GestureDetector(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Center(
                  child: Icon(Icons.delete_forever,color: Colors.white,),
                ),
              ),
              onTap: () {
                pedidoSeleccionado.productos.removeWhere((productos) => productos.select == true);
                selectProductos = false;
                setState(() {});
              },
            ),
          )
        ],
      ) : Container(),
      body: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(pedidoSeleccionado.tipo,style: _style2,),
                          SizedBox(width: 10),
                          Text(pedidoSeleccionado.nombreCliente,style: _style2,),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text("(PAGADO)",style: _style2.copyWith(color: Colors.grey),),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.ac_unit),
                              Text(pedidoSeleccionado.idPedido.toString())
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.ac_unit),
                              Text("Alejandro")
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.ac_unit),
                              Text("Auto")
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                Container(
                  //color: Colors.green,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            child: Text("Cant.",style: _style),
                          ),
                        )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          //color: Colors.green,
                          child: Text("Productos",style: _style),
                        )
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          //color: Colors.blue,
                          child: Text("SubTotal",style: _style),
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          child: Checkbox(
                            value: allSelect, 
                            onChanged: (value) {
                              for (var i = 0; i < pedidoSeleccionado.productos.length; i++) {
                                if (value) {
                                  pedidoSeleccionado.productos[i].entregado = true;
                                  select = true;
                                } else {
                                  pedidoSeleccionado.productos[i].entregado = false;
                                  select = false;
                                }
                              }
                              allSelect = !allSelect;
                              setState(() {});
                            },
                          ),
                        )
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    //color: Colors.blue,
                    child: ListView(
                      children: List.generate(pedidoSeleccionado.productos.length, (i) {
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: 
                              pedidoSeleccionado.productos[i].select == true 
                              ? Colors.red[200] 
                              : pedidoSeleccionado.productos[i].entregado == true 
                              ?
                              Colors.grey 
                              :
                              Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Text(pedidoSeleccionado.productos[i].cantidad.toString(),style: _style2),
                                    ),
                                  )
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.black87),
                                        children: <TextSpan>[
                                          TextSpan(text: pedidoSeleccionado.productos[i].producto),
                                          TextSpan(text: pedidoSeleccionado.productos[i].observaciones,style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    //color: Colors.blue,
                                    child: Text(nf.format(pedidoSeleccionado.productos[i].precio).toString(),style: _style2),
                                  )
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Checkbox(
                                        value: pedidoSeleccionado.productos[i].entregado, 
                                        onChanged: (value) {

                                          pedidoSeleccionado.productos[i].entregado = !pedidoSeleccionado.productos[i].entregado;

                                          int tselect = 0;

                                          for (var a = 0; a < pedidoSeleccionado.productos.length; a++) {
                                            if (pedidoSeleccionado.productos[a].entregado) {
                                              tselect++;
                                            }
                                          }

                                          if(tselect > 0){
                                            select = true;
                                          } else {
                                            select = false;
                                          }

                                          if (tselect == pedidoSeleccionado.productos.length) {
                                            allSelect = true;
                                          } else {
                                            allSelect = false;
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                          onLongPress: () {
                            if (selectProductos == false) {
                              selectProductos = true;
                            }
                            pedidoSeleccionado.productos[i].select = true;
                            setState(() {
                              
                            });
                          },
                          onTap: () {
                            int countselect = 0;
                            bool value = pedidoSeleccionado.productos[i].select;

                            if (value == null) {
                              value = false;
                            }

                            if(selectProductos){
                              pedidoSeleccionado.productos[i].select = !value;
                              for (var q = 0; q < pedidoSeleccionado.productos.length; q++) {
                                if (pedidoSeleccionado.productos[q].select == false || pedidoSeleccionado.productos[q].select == null) {
                                  countselect++;
                                }
                              }
                            }

                            if (countselect == pedidoSeleccionado.productos.length) {
                              selectProductos = false;
                            }
                            setState(() {});
                          },
                        );
                      }),
                    )
                  )
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("TOTAL",style: _style.copyWith(color: Colors.red)),
                      Text( nf.format(total()).toString(),style: _style.copyWith(color: Colors.red)),
                    ],
                  ),
                ),
                Container(
                  //color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OptionButton(
                        icon: Icons.edit,
                        activeColor: Colors.red,
                        inactiveColor: Colors.grey,
                        text: 'Editar',
                        active: selectProductos,
                        onTap: () {
                          cantidad = [];
                          for (var a = 0; a < pedidoSeleccionado.productos.length; a++) {
                            cantidad.add(pedidoSeleccionado.productos[a].cantidad);
                            controllers.add(TextEditingController(text: pedidoSeleccionado.productos[a].producto + ',' + pedidoSeleccionado.productos[a].observaciones));
                          }
                          if (selectProductos) {
                            editPopPup();
                          }
                        }
                      ),
                      OptionButton(
                        icon: Icons.add_circle,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.grey,
                        text: 'Añadir',
                        active: true,
                        onTap: (){
                          pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                          Navigator.of(context).pop();
                          idPedido = pedidoSeleccionado.idPedido;
                          clienteSeleccionado = pedidoSeleccionado.nombreCliente;
                        }
                      ),
                      OptionButton(
                        icon: Icons.paid,
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey,
                        text: 'Pagar',
                        active: select,
                        onTap: (){
                          print("Pruebas");
                        }
                      )
                    ]
                  )
                ),
                SizedBox(height: 10,)
              ]
            )
          )
        ]
      )
    );  
  }

  editPopPup(){

    return showDialog(
      context: context,          
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Container(
              height: size.height * 0.9,
              width: size.width * 0.95,
              //color: Colors.blue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width,
                    //margin: EdgeInsets.symmetric(vertical: 10),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Text(
                              "Editar Pedido",
                              style: _style.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: Container(
                              height: 40,
                              width: 40,
                              color: Colors.red,
                              child: Icon(Icons.close,color: Colors.white,),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    )
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  //color: Colors.green,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            //color: Colors.green,
                            child: Text("Productos",style: _style),
                          )
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Container(
                              child: Text("Cant.",style: _style),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    flex: 8,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      //color: Colors.blue,
                      child: ListView(
                        children: List.generate(pedidoSeleccionado.productos.length, (i) {
                          if (pedidoSeleccionado.productos[i].select == true) {
                            
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      child: TextField(
                                        controller: controllers[i],   
                                        decoration: InputDecoration(
                                          labelText: ''
                                        ),
                                        maxLines: null,
                                      )
                                    )
                                  ),
                                  Container(
                                    //padding: EdgeInsets.all(1),
                                    width: 120,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1,color: Colors.grey)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove,size: 15,), 
                                          onPressed: () {
                                            if( cantidad[i] > 0){
                                              cantidad[i]--;
                                              //cambiarPrecio();

                                              if (cantidad[i] == 0) {
                                                // productList.removeWhere((item) => item.idProducto == pedidoSeleccionado.productos[i].idProducto);
                                                // pedidoSeleccionado.productos[i].observaciones = '';
                                              }

                                            }
                                            setState(() {});
                                          },
                                        ),
                                        Text(
                                          '${cantidad[i]}',
                                          style: TextStyle(
                                            fontSize: 18
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add,size: 15,), 
                                          onPressed: () {
                                            cantidad[i] += 1;
                                            setState(() {});
                                            print(cantidad[i]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                              return Container();
                          }
                        }),
                      )
                    )
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OptionButton(
                        active: true,
                        activeColor: Colors.red,
                        icon: Icons.cancel_outlined, 
                        text: 'Cancelar', 
                        onTap: (){}
                      ),
                      OptionButton(
                        active: true,
                        activeColor: Colors.green,
                        icon: Icons.save, 
                        text: 'Confirmar', 
                        onTap: (){}
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          );
        },
      )
    );
  }

  int total(){
    double _total = 0;

    for (var i = 0; i < pedidoSeleccionado.productos.length; i++) {
      _total += pedidoSeleccionado.productos[i].precio * pedidoSeleccionado.productos[i].cantidad;
    } 

    return _total.toInt();

  }

}
