import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _MenuView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(''),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _MenuView extends StatelessWidget {
  const _MenuView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Base del proyecto'));
  }
}
