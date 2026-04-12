import 'package:flutter_riverpod/legacy.dart';
import 'package:people_browser_app/features/people/data/model/person.dart';
import 'package:people_browser_app/features/people/data/repository/people_repo_impl.dart';
import 'package:people_browser_app/features/people/domain/repository/people_repo.dart';
import 'package:people_browser_app/features/people/presentation/provider/people_state.dart';

final peopleProvider = StateNotifierProvider<PeopleProvider, PeopleState>(
    (ref) => PeopleProvider(PeopleRepoImpl()));

class PeopleProvider extends StateNotifier<PeopleState> {
  PeopleProvider(this._repo) : super(const PeopleState());

  final PeopleRepo _repo;

  Future<void> loadPeople() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _repo.fetchPeople();

      state = state.copyWith(
        isLoading: false,
        peopleData: data,
        filtered: data,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong',
      );
    }
  }

  void search(String query) {
    final data = state.peopleData;
    if (data == null) return;

    if (query.isEmpty) {
      state = state.copyWith(filtered: data);
      return;
    }

    final q = query.toLowerCase();
    final filteredResults = data.results
        .where((e) {
          final fullName =
              '${e.name.first} ${e.name.last}'.toLowerCase();
          return fullName.contains(q);
        })
        .toList();

    state = state.copyWith(
      filtered: PeopleModel(results: filteredResults, info: data.info),
    );
  }
}
