import 'package:flutter/material.dart';
import '../../data/model/person.dart';

class PersonDetailScreen extends StatelessWidget {
  final Person person;

  const PersonDetailScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: Column(
        children: [
          Image.network(person.avatar),
          const SizedBox(height: 16),
          Text(person.name, style: const TextStyle(fontSize: 20)),
          Text(person.email),
        ],
      ),
    );
  }
}