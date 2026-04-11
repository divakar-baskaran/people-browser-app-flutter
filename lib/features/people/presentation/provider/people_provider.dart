import 'package:flutter_riverpod/legacy.dart';
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
        data: data,
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
    if (query.isEmpty) {
      state = state.copyWith(filtered: state.data);
    } else {
      final result = state.data
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filtered: result);
    }
  }
}
