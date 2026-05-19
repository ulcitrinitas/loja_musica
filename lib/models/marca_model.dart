class Marca {
  String nome;
  String? pais;

  Marca({required this.nome, this.pais});

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
        nome: json["nome"] ?? "", 
        pais: json["pais"] ?? ""
      );
  }

   Map<String, String> toJson(){
    return {
      "nome": this.nome,
      "pais": this.pais ?? ""
    };
  }
}
