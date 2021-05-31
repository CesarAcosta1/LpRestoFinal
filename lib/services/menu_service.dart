import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:lp_resto_final_2/src/models/menu_model.dart';


class MenuService with ChangeNotifier {
  
  List<Menu> _menu = [];

  get getMenu => this._menu;

  MenuService(){
    _getMenu();
  }

  _getMenu() async {

    final resp = await http.get(Uri.parse('https://cdn.laplata.com.py/LpResto/api/Menu'));
    final newsResponse = menuFromJson(resp.body);
    this._menu.addAll(newsResponse);
    notifyListeners();
    
  }
}