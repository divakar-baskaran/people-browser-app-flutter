import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:people_browser_app/features/people/presentation/pages/person_detail_screen.dart';
import '../provider/people_provider.dart';

class PeopleListScreen extends ConsumerStatefulWidget {
  const PeopleListScreen({super.key});

  @override
  ConsumerState<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends ConsumerState<PeopleListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(peopleProvider.notifier).loadPeople());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(peopleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("People")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (v) =>
                  ref.read(peopleProvider.notifier).search(v),
              decoration: const InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!),
            ElevatedButton(
              onPressed: () =>
                  ref.read(peopleProvider.notifier).loadPeople(),
              child: const Text("Retry"),
            )
          ],
        ),
      );
    }

    if (state.filtered.isEmpty) {
      return const Center(child: Text("No results found"));
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(peopleProvider.notifier).loadPeople(),
      child: ListView.builder(
        itemCount: state.filtered.length,
        itemBuilder: (context, index) {
          final person = state.filtered[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(person.avatar),
            ),
            title: Text(person.name),
            subtitle: Text(person.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PersonDetailScreen(person: person),
                ),
              );
            },
          );
        },
      ),
    );
  }
}