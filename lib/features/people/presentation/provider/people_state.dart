import '../../data/model/person.dart';

const _unsetError = Object();

class PeopleState {
  final bool isLoading;
  final PeopleModel? peopleData;
  final PeopleModel? filtered;
  final String? error;

  const PeopleState({
    this.isLoading = false,
    this.peopleData,
    this.filtered,
    this.error,
  });

  PeopleState copyWith({
    bool? isLoading,
    PeopleModel? peopleData,
    PeopleModel? filtered,
    Object? error = _unsetError,
  }) {
    return PeopleState(
      isLoading: isLoading ?? this.isLoading,
      peopleData: peopleData ?? this.peopleData,
      filtered: filtered ?? this.filtered,
      error: identical(error, _unsetError) ? this.error : error as String?,
    );
  }
}