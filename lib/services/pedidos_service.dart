import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:lp_resto_final_2/src/models/pedidosModel.dart';


class PedidosService with ChangeNotifier {
  
  List<Pedidos> _pedido = [];

  get getpedido => this._pedido;

  PedidosService(){
    _getpedido();
  }

  _getpedido() async {

    final resp = await http.get(Uri.parse('https://cdn.laplata.com.py/LpResto/api/PedidosEnCurso'));
    final newsResponse = pedidosFromJson(resp.body);
    this._pedido.addAll(newsResponse);
    notifyListeners();
    
  }
}