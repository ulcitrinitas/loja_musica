import 'categoria_model.dart';
import 'marca_model.dart';

class Instrumento {
  int? id;
  String nome;
  double preco;
  int estoque;
  Marca marca;
  Categoria categoria;

  Instrumento({
    this.id,
    required this.nome,
    required this.preco,
    required this.estoque,
    required this.categoria,
    required this.marca,
  });

  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "preco": preco,
      "estoque": estoque,
      "marca": marca.toJson(),
      "categoria": categoria.toJson(),
      "marca_nome": marca.nome,
      "marca_pais": marca.pais ?? "",
      "cat_nome": categoria.nome,
    };
  }

  factory Instrumento.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? asMap(dynamic valor) {
      if (valor is Map<String, dynamic>) return valor;
      if (valor is Map) return Map<String, dynamic>.from(valor);
      return null;
    }

    final categoriaMap = asMap(json["categoria"]);
    final marcaMap = asMap(json["marca"]);

    return Instrumento(
      id: json["id"] != null ? int.parse(json["id"].toString()) : null,
      nome: json["nome"]?.toString() ?? "",
      preco: (json["preco"] as num?)?.toDouble() ??
          double.tryParse(json["preco"]?.toString() ?? "") ??
          0.0,
      estoque: (json["estoque"] as num?)?.toInt() ??
          int.tryParse(json["estoque"]?.toString() ?? "") ??
          0,
      categoria: Categoria.fromJson(
        categoriaMap ?? {"nome": json["cat_nome"]?.toString() ?? ""},
      ),
      marca: Marca.fromJson(
        marcaMap ??
            {
              "nome": json["marca_nome"]?.toString() ?? "",
              "pais": json["marca_pais"]?.toString() ?? "",
            },
      ),
    );
  }
}
