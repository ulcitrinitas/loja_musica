import 'package:loja_musica/models/instrumento_model.dart';
import 'package:loja_musica/services/api.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class InstrumentoService {
  static final String url = "${ApiService.baseUrl}/instrumentos";

  static Future<List<Instrumento>> listarInstrumentos() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = response.body.trim();

      if (body.startsWith("<")) {
        throw Exception(
          "A API retornou HTML ao invés de JSON.\n"
          "Verifique se a API está retornando um json",
        );
      }

      final List<dynamic> dados = json.decode(body);
      return dados.map((json) => Instrumento.fromJson(json)).toList();
    }
    throw Exception("Erro ao listar os instrumentos: ${response.statusCode}");
  }

  static Future<void> inserirInstrumento(Instrumento instrumento) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(instrumento.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception(
        "Erro ao inserir instrumentos: ${response.statusCode}\n${response.body}",
      );
    }
  }

  static Future<void> atualizarPaciente(Instrumento instrumento) async {
    final response = await http.put(
      Uri.parse("$url?id=${instrumento.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(instrumento.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Erro ao atualizar instrumento: ${response.statusCode}\n${response.body}",
      );
    }
  }

  static Future<void> excluirPaciente(Instrumento instrumento) async {
    final response = await http.delete(Uri.parse("$url?id=${instrumento.id}"));

    if (response.statusCode != 200) {
      throw Exception(
        "Erro ao excluir instrumento: ${response.statusCode}\n${response.body}",
      );
    }
  }
}
