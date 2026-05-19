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
      "marca_nome": marca.nome,
      "marca_pais": marca.pais ?? "",
      "cat_nome": categoria.nome,
    };
  }

  factory Instrumento.fromJson(Map<String, dynamic> json) {
    return Instrumento(
      nome: json["nome"] ?? "",
      preco: json["preco"] ?? "",
      estoque: json["estoque"] ?? "",
      categoria: Categoria.fromJson(json["categoria"]),
      marca: Marca.fromJson(json["marca"]),
      id: json["id"] != null ? int.parse(json["id"].toString()) : null,
    );
  }
}
