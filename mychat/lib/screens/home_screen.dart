import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text('MyChat'),
        actions: [
          // search button
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          // more button
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
        ],
      ),
      // floating add button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 0,top: 0,right: 10,bottom: 15),
        child: FloatingActionButton(
          onPressed: (){},
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
