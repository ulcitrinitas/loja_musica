import "package:flutter/material.dart";

import 'package:loja_musica/models/instrumento_model.dart';
import 'package:loja_musica/services/instrumento.dart';
import 'package:loja_musica/screens/instrumentos/form_instrumentos.dart';

class ListaInstrumentos extends StatefulWidget {
  const ListaInstrumentos({super.key});

  @override
  State<StatefulWidget> createState() => _ListaInstrumentosState();
}

class _ListaInstrumentosState extends State<ListaInstrumentos> {
  List<Instrumento> _instrumentos = [];

  bool _carregando = true;

  void _snack(String msg, {var erro = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: erro ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
    });

    try {
      final lista = await InstrumentoService.listar();
      setState(() => _instrumentos = lista);
    } catch (e) {
      _snack("Erro ao carregar: $e", erro: true);
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _excluir(Instrumento i) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirmar exclusão"),
        content: Text("Deseja excluir ${i.nome}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await InstrumentoService.excluir(i);
        _snack("Instrumento excluido");
        _carregar();
      } catch (e) {
        _snack("Erro ao excluir $e", erro: true);
      }
    }
  }

  void _abrirForm({Instrumento? instrumento}) async {
    final atualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormInstrumento(instrumento: instrumento),
      ),
    );
    if (atualizado == true) _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("medicos do hospital"),
        backgroundColor: const Color(0xFF5611E1),
        foregroundColor: const Color(0xFFE8F2F3),
        actions: [IconButton(onPressed: _carregar, icon: Icon(Icons.refresh))],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _instrumentos.isEmpty
          ? const Center(
              child: Text(
                "Nenhum medico cadastrado",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemCount: _instrumentos.length,
              itemBuilder: (context, i) {
                final ins = _instrumentos[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      ins.nome[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    ins.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${ins.categoria}"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _abrirForm(instrumento: ins),
                        icon: const Icon(Icons.edit, color: Colors.amber),
                      ),
                      IconButton(
                        onPressed: () => _excluir(ins),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
