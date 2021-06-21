import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lp_resto_final_2/custom_icons.dart';
import 'package:lp_resto_final_2/services/menu_service.dart';
import 'package:lp_resto_final_2/src/models/pedidosModel.dart';
import 'package:lp_resto_final_2/src/pages/clientePage.dart';
import 'package:lp_resto_final_2/src/pages/manuPage.dart';
import 'package:lp_resto_final_2/src/pages/pedidosEnCursoPage.dart';
import 'package:provider/provider.dart';

class PadrePage extends StatefulWidget {
  PadrePage({Key key}) : super(key: key);

  @override
  _PadrePageState createState() => _PadrePageState();
}

Size size;

var currentIndex = 2;
PageController pageController = PageController(initialPage: 2);

var idPedido;
var clienteSeleccionado;
bool menuView = false;
var menuService;

Pedidos pedidoSeleccionado;

class _PadrePageState extends State<PadrePage> {
  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    menuService = Provider.of<MenuService>(context).getMenu;
    List<String> _namePage =["Cliente","Menú","Pedidos en Curso"];
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          color: Colors.transparent,
          child: Icon(CustomIcons.logo,size: 55),
        ),
        leadingWidth: 80,
        title: Text(
          _namePage[currentIndex],
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          pageController.animateToPage(value, duration: Duration(milliseconds: 500), curve: Curves.ease);
          currentIndex = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.clientes),
            label: "Cliente",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.pedidos),
            label: "Pedidos",
          )
        ]
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
              ),
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  currentIndex = value;
                  setState(() {});
                },
                children: [
                  Clientepage(),
                  menuLoading(),
                  PedidosEnCursoPage()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget menuLoading(){

    if (currentIndex == 1 && menuService.length != 0) {

      Timer(Duration(seconds: 1), () {
        setState(() {
          menuView = true;
        });
      }); 
    } else {
      menuView = false;
    }

    if (menuView) {
      return MenuPage();
    } else {
      return Container(color: Colors.white,  child: Center(child: CircularProgressIndicator(strokeWidth: 2,)));
    }

  }
  
}