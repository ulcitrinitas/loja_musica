class Categoria {
  String nome;

  Categoria({required this.nome});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(nome: json["nome"]);
  }

  Map<String, String> toJson(){
    return {
      "nome": this.nome
    };
  }
}
