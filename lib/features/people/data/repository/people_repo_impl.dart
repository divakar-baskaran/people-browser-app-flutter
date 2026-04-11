import 'package:dio/src/dio.dart';
import 'package:people_browser_app/features/people/data/model/person.dart';
import '../../domain/repository/people_repo.dart';

class PeopleRepoImpl implements PeopleRepo {
  Dio get dio => throw UnimplementedError();

  @override
  Future<List<Person>> fetchPeople() async {
    final response = await dio.get('https://randomuser.me/api/?results=20');
    return Person.fromList(response.data);
  }

}