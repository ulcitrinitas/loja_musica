import 'package:loja_musica/models/categoria_model.dart';
import 'package:loja_musica/models/instrumento_model.dart';
import 'package:loja_musica/models/marca_model.dart';
import 'package:loja_musica/services/instrumento.dart';

import 'package:flutter/material.dart';

class FormInstrumento extends StatefulWidget {
  final Instrumento? instrumento;

  const FormInstrumento({super.key, this.instrumento});

  @override
  State<StatefulWidget> createState() {
    return _FormInstrumentoState();
  }
}

class _FormInstrumentoState extends State<FormInstrumento> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  final _estoqueCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  final _marcaCtrl = TextEditingController();

  var _salvando = false;

  @override
  void initState() {
    super.initState();

    if (widget.instrumento != null) {
      _nomeCtrl.text = widget.instrumento!.nome;
      _precoCtrl.text = widget.instrumento!.preco.toString();
      _estoqueCtrl.text = widget.instrumento!.estoque.toString();
      _categoriaCtrl.text = widget.instrumento!.categoria.nome;
      _marcaCtrl.text = widget.instrumento!.marca.nome;
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _precoCtrl.dispose();
    _estoqueCtrl.dispose();
    _categoriaCtrl.dispose();
    _marcaCtrl.dispose();
    super.dispose();
  }

  double? _parsePreco(String val) {
    var texto = val.trim().replaceAll(" ", "");
    if (texto.isEmpty) return null;

    final temVirgula = texto.contains(",");
    final temPonto = texto.contains(".");

    if (temVirgula && temPonto) {
      final ultimaVirgula = texto.lastIndexOf(",");
      final ultimoPonto = texto.lastIndexOf(".");
      if (ultimaVirgula > ultimoPonto) {
        texto = texto.replaceAll(".", "").replaceAll(",", ".");
      } else {
        texto = texto.replaceAll(",", "");
      }
    } else if (temVirgula) {
      texto = texto.replaceAll(",", ".");
    }

    return double.tryParse(texto);
  }

  double _converterPreco(String val) {
    return _parsePreco(val) ?? 0.0;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _salvando = true;
    });

    final instrumento = Instrumento(
      id: widget.instrumento?.id,
      nome: _nomeCtrl.text.trim(),
      preco: _converterPreco(_precoCtrl.text),
      estoque: int.parse(_estoqueCtrl.text.trim()),
      categoria: Categoria(nome: _categoriaCtrl.text.trim()),
      marca: Marca(nome: _marcaCtrl.text.trim()),
    );

    try {
      if (widget.instrumento == null) {
        await InstrumentoService.inserir(instrumento);
        if (mounted) _mostrarMsg("Instrumento Cadastrado");
      } else {
        await InstrumentoService.atualizar(instrumento);
        if (mounted) _mostrarMsg("Instrumento Atualizado");
      }
    } catch (e) {
      if (mounted) _mostrarMsg("Erro: $e", erro: true);
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  void _mostrarMsg(String msg, {var erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: erro ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.instrumento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? "Editar Instrumento" : "Novo Instrumento"),
        backgroundColor: const Color(0xFF5611E1),
        foregroundColor: const Color(0xFFE8F2F3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de nome
              TextFormField(
                controller: _nomeCtrl,
                decoration: const InputDecoration(
                  labelText: "Nome *",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Informe o nome" : null,
              ),
              const SizedBox(height: 16),

              // Campo de Preço
              TextFormField(
                controller: _precoCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Preço",
                  prefixIcon: Icon(Icons.currency_exchange),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Informe o preço";
                  }
                  if (_parsePreco(v) == null) {
                    return "Formato inválido! Use: 10, 10,5 ou 10.50";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo de Estoque
              TextFormField(
                controller: _estoqueCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Estoque",
                  prefixIcon: Icon(Icons.shopping_cart_checkout_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Informe o estoque";
                  }
                  if (int.tryParse(v) == null) {
                    return "Precisa ser um número";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo de Categoria
              TextFormField(
                controller: _categoriaCtrl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Categoria",
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Informe a categoria";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo de Estoque
              TextFormField(
                controller: _marcaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Marca do Instrumento",
                  prefixIcon: Icon(Icons.catching_pokemon_sharp),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Informe a marca do instrumento";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _salvando ? null : _salvar,
                  icon: _salvando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.save),
                  label: Text(_salvando ? "Salvando..." : "Salvar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
