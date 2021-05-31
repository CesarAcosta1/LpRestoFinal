// To parse this JSON data, do
//
//     final pedidos = pedidosFromJson(jsonString);

import 'dart:convert';

import 'package:lp_resto_final_2/src/Models/producto_model.dart';

List<Pedidos> pedidosFromJson(String str) => List<Pedidos>.from(json.decode(str).map((x) => Pedidos.fromJson(x)));

String pedidosToJson(List<Pedidos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pedidos {
    Pedidos({
        this.idPedido,
        this.fechahoraPedido,
        this.nombreCliente,
        this.idTipo,
        this.tipo,
        this.productos,
    });

    int idPedido;
    String fechahoraPedido;
    String nombreCliente;
    int idTipo;
    String tipo;
    List<Producto> productos;

    factory Pedidos.fromJson(Map<String, dynamic> json) => Pedidos(
        idPedido: json["idPedido"],
        fechahoraPedido: json["fechahoraPedido"],
        nombreCliente: json["nombreCliente"],
        idTipo: json["idTipo"],
        tipo: json["tipo"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idPedido": idPedido,
        "fechahoraPedido": fechahoraPedido,
        "nombreCliente": nombreCliente,
        "idTipo": idTipo,
        "tipo": tipo,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}

