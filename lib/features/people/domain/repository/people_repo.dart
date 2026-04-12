import '../../data/model/person.dart';

abstract class PeopleRepo{
  Future<PeopleModel> fetchPeople();
}