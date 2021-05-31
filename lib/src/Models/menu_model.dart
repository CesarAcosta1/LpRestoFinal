// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);

import 'dart:convert';

import 'package:lp_resto_final_2/src/Models/producto_model.dart';

List<Menu> menuFromJson(String str) => List<Menu>.from(json.decode(str).map((x) => Menu.fromJson(x)));

String menuToJson(List<Menu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Menu {
    Menu({
        this.idCategoria,
        this.categoria,
        this.productos,
    });

    int idCategoria;
    String categoria;
    List<Producto> productos;

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        idCategoria: json["idCategoria"],
        categoria: json["categoria"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idCategoria": idCategoria,
        "categoria": categoria,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}





