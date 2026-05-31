import 'package:flutter/material.dart';
import 'package:loja_musica/screens/instrumentos/lista_instrumentos.dart';

class NavigationBarScreen extends StatelessWidget {
  const NavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NavigationHome());
  }
}

class NavigationHome extends StatefulWidget {
  const NavigationHome({super.key});

  @override
  State<NavigationHome> createState() => _NavigationHomeState();
}

class _NavigationHomeState extends State<NavigationHome> {
  int _currentIndex = 0;

  // Lista de páginas — cada índice corresponde a um item do NavigationBar
  final List<Widget> _pages = const [
    ListaInstrumentos(),
    ClientesPage(),
    VendasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: _currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.music_video_sharp),
            label: 'Instrumentos',
          ),
          NavigationDestination(icon: Icon(Icons.people), label: 'Clientes'),
          NavigationDestination(
            icon: Icon(Icons.monetization_on),
            label: 'Vendas',
          ),
        ],
      ),
      // Troca o body conforme o índice selecionado
      body: _pages[_currentIndex],
    );
  }
}

// ─────────────────────────────────────────────
// Página: Listar Instrumentos
// ─────────────────────────────────────────────
// class ListarInstrumentosPage extends StatelessWidget {
//   const ListarInstrumentosPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Página: Listar Instrumentos'));
//   }
// }

// ─────────────────────────────────────────────
// Página: Clientes (placeholder)
// ─────────────────────────────────────────────
class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Página: Clientes (em breve)'));
  }
}

// ─────────────────────────────────────────────
// Página: Vendas (placeholder)
// ─────────────────────────────────────────────
class VendasPage extends StatelessWidget {
  const VendasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Página: Vendas (em breve)'));
  }
}
