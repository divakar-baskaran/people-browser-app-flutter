import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/people/presentation/pages/people_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: PeopleBrowserApp()));
}

class PeopleBrowserApp extends StatelessWidget {
  const PeopleBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'People Browser',
      home: const PeopleListScreen(),
    );
  }
}