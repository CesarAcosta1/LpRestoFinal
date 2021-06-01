class Producto {
    Producto({
        this.idProducto,
        this.idCategoria,
        this.producto,
        this.descripcion,
        this.precio,
        this.urlFoto,
        this.cantidad,
        this.observaciones,
        this.entregado,
        this.eliminar
    });

    int idProducto;
    int idCategoria;
    String producto;
    String descripcion;
    double precio;
    String urlFoto;
    int cantidad;
    String observaciones;
    bool entregado;
    bool eliminar;

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        idProducto: json["idProducto"],
        idCategoria: json["idCategoria"],
        producto: json["producto"],
        descripcion: json["descripcion"],
        precio: json["precio"],
        urlFoto: json["urlFoto"],
        cantidad: json["cantidad"],
        observaciones : json["observaciones"],
        entregado : json["entregado"],
        eliminar : false,
    );

    Map<String, dynamic> toJson() => {
        "idProducto": idProducto,
        "idCategoria": idCategoria,
        "producto": producto,
        "descripcion": descripcion,
        "precio": precio,
        "urlFoto": urlFoto,
        "cantidad" : cantidad,
        "observaciones" : observaciones,
        "entregado" : entregado,
        "aliminar" : eliminar,
    };
}

