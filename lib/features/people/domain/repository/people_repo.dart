import '../../data/model/person.dart';

abstract class PeopleRepo{
  Future<List<Person>> fetchPeople();
}