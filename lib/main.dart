import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lp_resto_final_2/services/menu_service.dart';
import 'package:lp_resto_final_2/services/pedidos_service.dart';
import 'package:lp_resto_final_2/src/pages/manuPage.dart';
import 'package:lp_resto_final_2/src/pages/padrePage.dart';
import 'package:lp_resto_final_2/src/pages/pagoFacturacionPage.dart';
import 'package:lp_resto_final_2/src/pages/pedidosDetallesPage.dart';
import 'package:lp_resto_final_2/src/pages/pruebas.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuService()),
        ChangeNotifierProvider(create: (_) => PedidosService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pantalla de prueba',
        initialRoute: 'PagoFacturacion',
        theme: ThemeData(
          fontFamily: GoogleFonts.montserrat().fontFamily
        ),
        routes: {
          'Menu'            : (BuildContext c) => MenuPage(),
          'pruebas'         : (BuildContext c) => Pruebas(),
          'Padre'           : (BuildContext c) => PadrePage(),
          'PedidoDetalle'   : (BuildContext c) => PedidosDetalles(),
          'PagoFacturacion' : (BuildContext c) => PagoFacturacionPage(),
        },
      ),
    );
  }
}