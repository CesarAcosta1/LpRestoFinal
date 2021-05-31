
import 'dart:convert';

import 'package:lp_resto_final_2/src/Models/producto_model.dart';

PedidosEnviar pedidosEnviarFromJson(String str) => PedidosEnviar.fromJson(json.decode(str));

String pedidosEnviarToJson(PedidosEnviar data) => json.encode(data.toJson());

class PedidosEnviar {
    PedidosEnviar({
        this.nombreCliente,
        this.idTipo,
        this.tipo,
        this.idPedidoPadre,
        this.productos,
    });

    String nombreCliente;
    int idTipo;
    String tipo;
    int idPedidoPadre;
    List<Producto> productos;

    factory PedidosEnviar.fromJson(Map<String, dynamic> json) => PedidosEnviar(
        nombreCliente: json["nombreCliente"],
        idTipo: json["idTipo"],
        tipo: json["tipo"],
        idPedidoPadre: json["idPedidoPadre"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "nombreCliente": nombreCliente,
        "idTipo": idTipo,
        "tipo": tipo,
        "idPedidoPadre" : idPedidoPadre,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}


