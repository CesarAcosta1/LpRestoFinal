import 'dart:convert';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:lp_resto_final_2/custom_icons.dart';
import 'package:lp_resto_final_2/pages/padrePage.dart';
import 'package:lp_resto_final_2/services/menu_service.dart';
import 'package:lp_resto_final_2/src/Models/clienteModel.dart';
import 'package:lp_resto_final_2/src/Models/pedidosEnviar_model.dart';
import 'package:lp_resto_final_2/src/Models/producto_model.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:http/http.dart' as http;

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

Size size;
Color primary = Colors.red;
List<Producto> productList = [];
double precioTotal = 0;
String marcaSeleccionada = '';

BottomDrawerController _drawerController = BottomDrawerController();
bool _openDrawer = true;
final ItemScrollController itemScrollController = ItemScrollController();
final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
final textController = TextEditingController();
final clienteTextController = TextEditingController();
final _formCliente = GlobalKey<FormState>();


final nf = NumberFormat.currency(locale: "es", symbol: "Gs.", decimalDigits: 0);

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {

  size = MediaQuery.of(context).size;

  return Stack(
    children: [
    Container(
      height: size.height * 0.83,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 2.5),
              width: double.infinity,
              height: 35,
              color: Colors.white,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: menuService.length,
                itemBuilder: (context, index) => categoriaCard(index,menuService[index].categoria),
              ),
            ),
            Container(
              height: size.height * 0.72,
              width: size.width,
              color: Colors.white,
              child: ScrollablePositionedList.builder(
                //physics: BouncingScrollPhysics(),
                itemCount: menuService.length,
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemBuilder: (context, index) => Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        width: 400,
                        child: Text(menuService[index].categoria,
                          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Column(
                        children: List.generate(menuService[index].productos.length, (i) => cardProduct(menuService[index].productos[i],false)),
                      ),
                      SizedBox(height: 15)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    ),
      drowerBottom(),
    ],
  ); 

}

Widget categoriaCard(int index,nombre){
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      // width: 100,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [_shadow]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            nombre,
            style: TextStyle(
              color: Colors.white
            ),
          )
        ],
      )
    ),
    onTap: () {
      itemScrollController.scrollTo(
        index: index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic
      );
    },
  );
}

  Container cardProduct(Producto producto,bool isDrawer) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      width: size.width,
      //height: 110,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey,
          width: 1
        )
        // boxShadow: [_shadow]
      ),
      child: Column(
        children: [
          Row(    
            crossAxisAlignment: CrossAxisAlignment.start,                
            children: [
               Container(
                height: 100,
                width: size.width * 0.3,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(19),bottomLeft: Radius.circular(19)),
                  color: Colors.transparent,
                ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(producto.urlFoto),
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: size.width * 0.50,
                  height: 100,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          producto.producto,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 3,),
                      Container(
                        child: Text(
                          nf.format(producto.precio).toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: size.width * 0.4,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1,color: Colors.grey)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove), 
                              onPressed: () {
                                if( producto.cantidad > 0){
                                  producto.cantidad--;
                                  cambiarPrecio();

                                  if (producto.cantidad == 0) {
                                    productList.removeWhere((item) => item.idProducto == producto.idProducto);
                                    producto.observaciones = '';
                                  }

                                }
                                setState(() {});
                              },
                            ),
                            Text(
                              '${producto.cantidad}',
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add), 
                              onPressed: () {
                                agregarPedidos(producto);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(  
                child: IconButton(
                  icon: Icon(Icons.edit,  color: (producto.cantidad > 0) ? Colors.red : Colors.grey),
                  onPressed: () {
                    if(producto.cantidad > 0){
                      textController.text = producto.observaciones;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Observacion de preparacion'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                    labelText: ''
                                  ),
                                  maxLines: null,
                                )
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: primary
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, 
                                child: Text('Cancelar')
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: primary
                                ),
                                onPressed: () {
                                  producto.observaciones = textController.text;
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Agregar'
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                ),
              ) 
            ],
          ),
        ],
      ),
    );
  }

  void enviarPedidos( Cliente cliente) async {
    PedidosEnviar pedidosEnviar =  PedidosEnviar(nombreCliente: cliente.nombre,idTipo: cliente.idTipo,tipo: cliente.tipo,idPedidoPadre: idPedido,productos: productList,);

    Map data = pedidosEnviar.toJson();
    var body = json.encode(data);

    var response = await http.post(Uri.parse('https://cdn.laplata.com.py/LpResto/api/Pedido'),
        headers: {"Content-Type": "application/json"},
        body: body
    );

  }


  void eliminarTodo(){
    for (var i = 0; i < productList.length; i++) {
      productList[i].cantidad = 0;
      productList[i].observaciones = '';
    }
    productList = [];
    idPedido = null;
    clienteSeleccionado = null;
    cambiarPrecio();
    setState(() {});
  }

  
  void agregarPedidos( Producto producto ){

    bool agregar = true;
    var position = 0;

    for (var i = 0; i < productList.length; i++) {
      if (productList[i].idProducto == producto.idProducto) {
        agregar = false;
        position = i;
      }  
    }

    if (agregar) {
      producto.cantidad++;
      producto.observaciones = '';
      productList.add(producto);
    } else {
      productList[position].cantidad++;
    }

    cambiarPrecio();

  }

    void cambiarPrecio(){
    double precioT = 0; 
    for (var i = 0; i < productList.length; i++) {
      precioT += productList[i].precio * productList[i].cantidad; 
    }
    precioTotal = precioT;
  }

  Widget drowerBottom() {
    return BottomDrawer(
      headerHeight: size.height * 0.08, 
      drawerHeight: size.height * 0.75,
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
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                          //margin: EdgeInsets.only(top: 0),
                          //color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(CustomIcons.pedidos,color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                nf.format(precioTotal).toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
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
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalles del Pedido',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: primary
                    ),
                    icon: Icon(Icons.delete_forever),
                    label: Text('Eliminar todo'),
                    onPressed: () {
                      eliminarTodo();
                    },
                  )
                ],
              )
            ),
            (idPedido != null) ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Cliente seleccionado: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  Text(
                    clienteSeleccionado,
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  )
                ],
              ),
            ) : Container(),
            Column(children: List.generate(productList.length, (i) => detallePedidoCard(productList[i])),),
            SizedBox(height: 20,),
            (productList.length == 0) ? Container() :Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green
                    ),
                    onPressed: () {
                      //enviarPedidos();
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => PagoFacturacionPage(data: data,)),);

                        List<String> tipos = ['Mostrador','Mesa','Auto','Delivery',];
                        String dropdownValue = tipos[0];

                        Color currentColor = Colors.blue;
                        
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text("Crear pedido"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Form(
                                        key: _formCliente,
                                        child: TextFormField(
                                          controller: clienteTextController,
                                          decoration: InputDecoration(
                                            labelText: 'Nombre del cliente',
                                            //errorText: 'asd'
                                          ),
                                          validator: (value) {
                                            return (value == '' || value == null) ? 'Ups... Completa el campo' : null;
                                          }
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text('Canal de venta: '),
                                          SizedBox(width: 10),
                                          DropdownButton<String>(
                                            value: dropdownValue,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                dropdownValue = newValue;
                                              });
                                            },
                                            items: List.generate(tipos.length, (index) => 
                                              DropdownMenuItem(
                                                child: Text(tipos[index]),
                                                value: tipos[index],
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                      (dropdownValue == 'Mesa')
                                        ? 
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    scrollable: true,
                                                    title: Text('Seleccionar Mesa'),
                                                    content: Center(
                                                      child: Wrap(
                                                        children: List.generate(9, (index) {
                                                          return Container(
                                                            margin: EdgeInsets.all(10),
                                                            height: 60,
                                                            width: 60,
                                                            decoration: BoxDecoration(
                                                              color: (index % 2 == 0) ?Colors.red : Colors.green,
                                                              borderRadius: BorderRadius.circular(20)
                                                            ),
                                                            child: Center(
                                                              child: Text((index + 1).toString()),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }, 
                                            child: Text('Seleccionar mesa')
                                          )
                                        : 
                                      (dropdownValue == 'Auto')
                                      ?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child:Row(
                                                children: [
                                                  Text('Marca: '),
                                                  GestureDetector(
                                                    child: (marcaSeleccionada == '') ? Container(
                                                      height:40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(25),
                                                        border: Border.all(width: 1,color: Colors.black)
                                                      ),
                                                    ) : Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image(image: NetworkImage(marcaSeleccionada)),
                                                    ),
                                                    onTap: () {
                                                      String url = 'https://cdn.laplata.com.py/LPDigital/LpResto/Marcas/';
                                                      List<String> marcas = [ url +'BMW.svg', url +'Chevrolet.svg',url +'Fiat.svg',url +'Honda.svg',url +'Hyundai.svg',url +'JEEP.svg',url +'Kia.svg',url +'MercedesBenz.svg',url +'Nissan.svg',url +'Peugeot.svg',url +'Renault.svg',url +'Suzuki.svg',url +'Toyota.svg',url +'Volkswagen.svg'];

                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Seleccione la marca'),
                                                            content: SingleChildScrollView(
                                                              child: Center(
                                                                child: Wrap(
                                                                  children: List.generate(14, (index) {
                                                                    return Container(
                                                                      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                                                      padding: EdgeInsets.all(2),
                                                                      height: 60,
                                                                      width: 60,
                                                                      color: Colors.transparent,
                                                                      child: GestureDetector(
                                                                          child: Image(
                                                                          image: NetworkImage(marcas[index]),
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                        onTap: () {
                                                                          marcaSeleccionada = marcas[index];
                                                                          Navigator.of(context).pop();
                                                                          setState(() {
                                                                          });
                                                                        },
                                                                      ),
                                                                    );
                                                                  }),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  )  
                                                ],
                                              ) ,
                                            ),
                                            Container(
                                              child:Row(
                                                children: [
                                                  Text('Color: '),
                                                  GestureDetector(
                                                    child: Container(
                                                      height:40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: currentColor,
                                                        borderRadius: BorderRadius.circular(25)
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Select a color'),
                                                            content: SingleChildScrollView(
                                                              child: BlockPicker(
                                                                pickerColor: currentColor,
                                                                onColorChanged: (value) {
                                                                  setState(() {
                                                                    currentColor = value;
                                                                    print(currentColor.toString());
                                                                  });
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  )  
                                                ],
                                              ) ,
                                            ),
                                          ],
                                        )
                                      : 
                                      Container(),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context); 
                                            }, 
                                            child: Text('Pagar ahora') 
                                          ),
                                          ElevatedButton(
                                            onPressed: () {

                                              if (dropdownValue == 'Mostrador' && _formCliente.currentState.validate()) {
                                                clienteSeleccionado = null;
                                                idPedido = null; 
                                                enviarPedidos(Cliente(idCliente: 1,nombre: clienteTextController.text,idTipo: 1,tipo: "Mostrador"));
                                                Navigator.pop(context);
                                                clienteTextController.text = '';
                                                eliminarTodo();
                                              } 
                                            }, 
                                            child: Text('Pagar depues') 
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      
                    },
                    child: Text(
                      'Nuevo Pedido',style: TextStyle(fontSize: 16),
                    )
                  ),
                  SizedBox(width: 20,),
                  (clienteSeleccionado != null) ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue
                    ),
                    child: Text("Añadir a " + clienteSeleccionado,style: TextStyle(fontSize: 16),),
                    onPressed: () {
                      enviarPedidos(Cliente(idCliente: 1,nombre: '',idTipo: 1,tipo: "Mostrador"));
                      eliminarTodo();
                    }, 
                  ) : Container()
                ],
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
      callback: (opened) {
        _openDrawer = !opened;
      }
    );
  }

  Widget detallePedidoCard(Producto producto){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1,color: Colors.grey),
        borderRadius: BorderRadius.circular(25)
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          producto.producto,
                          style: TextStyle(
                            //fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 3,),
                      Container(
                        child: Text(
                          nf.format(producto.precio).toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1,color: Colors.grey)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove), 
                          onPressed: () {
                            if( producto.cantidad > 0){
                              producto.cantidad--;
                              cambiarPrecio();

                              if (producto.cantidad == 0) {
                                productList.removeWhere((item) => item.idProducto == producto.idProducto);
                                producto.observaciones = '';
                              }

                            }
                            setState(() {});
                          },
                        ),
                        Text(
                          '${producto.cantidad}',
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add), 
                          onPressed: () {
                            agregarPedidos(producto);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 1,color: Colors.grey)
              )
            ),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Observaciones:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      Container(  
                        //color: Colors.blue,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.edit,  color: (producto.cantidad > 0) ? Colors.red : Colors.grey),
                          onPressed: () {
                            if(producto.cantidad > 0){
                              textController.text = producto.observaciones;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Observacion de preparacion'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: textController,
                                          decoration: InputDecoration(
                                            labelText: ''
                                          ),
                                          maxLines: null,
                                        )
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: primary
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }, 
                                        child: Text('Cancelar')
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: primary
                                        ),
                                        onPressed: () {
                                          producto.observaciones = textController.text;
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Agregar'
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        ),
                      )
                    ],
                  ),
                ),
                (producto.observaciones != '') ?Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        producto.observaciones
                      ),
                    ),
                  ),
                ) : Container()
              ],
            ),
          )
          // Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             "Observaciones:",
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 16
          //             ),
          //           ),
          //           Container(  
          //             color: Colors.white,
          //             child: IconButton(
          //               disabledColor: Colors.grey,
          //               icon: Icon(Icons.edit,  color: (producto.cantidad > 0) ? Colors.red : Colors.grey),
          //               onPressed: () {
          //                 if(producto.cantidad > 0){
          //                   textController.text = producto.observaciones;
          //                   showDialog(
          //                     context: context,
          //                     builder: (BuildContext context) {
          //                       return AlertDialog(
          //                         title: Text('Observacion de preparacion'),
          //                         content: Column(
          //                           mainAxisSize: MainAxisSize.min,
          //                           children: [
          //                             TextField(
          //                               controller: textController,
          //                               decoration: InputDecoration(
          //                                 labelText: ''
          //                               ),
          //                               maxLines: null,
          //                             )
          //                           ],
          //                         ),
          //                         actions: [
          //                           ElevatedButton(
          //                             style: ElevatedButton.styleFrom(
          //                               primary: primary
          //                             ),
          //                             onPressed: () {
          //                               Navigator.of(context).pop();
          //                             }, 
          //                             child: Text('Cancelar')
          //                           ),
          //                           ElevatedButton(
          //                             style: ElevatedButton.styleFrom(
          //                               primary: primary
          //                             ),
          //                             onPressed: () {
          //                               producto.observaciones = textController.text;
          //                               setState(() {});
          //                               Navigator.of(context).pop();
          //                             },
          //                             child: Text(
          //                               'Agregar'
          //                             ),
          //                           ),
          //                         ],
          //                       );
          //                     },
          //                   );
          //                 }
          //               }
          //             ),
          //           ) 
          //         ],
          //       ),
          //       Align(
          //         alignment: Alignment.topLeft,
          //         child: Container(
          //           margin: EdgeInsets.only(bottom: 10),
          //           child: Text(
          //             producto.observaciones,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
        
        ],
      ),
    );
  }

}