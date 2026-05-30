import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.people), label: 'Clientes'),
          NavigationDestination(
            icon: Icon(Icons.monetization_on),
            label: 'Vendas',
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Aba atual: $_currentIndex',
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
