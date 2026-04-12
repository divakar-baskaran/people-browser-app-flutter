import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:people_browser_app/core/network/logging_interceptor.dart';
import 'package:people_browser_app/features/people/data/model/person.dart';
import '../../domain/repository/people_repo.dart';

class PeopleRepoImpl implements PeopleRepo {
  PeopleRepoImpl({Dio? dio}) : _dio = dio ?? _createDioWithLogging();

  final Dio _dio;

  static Dio _createDioWithLogging() {
    final dio = Dio();
    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor());
    }
    return dio;
  }

  @override
  Future<PeopleModel> fetchPeople() async {
    final response = await _dio.get('https://randomuser.me/api/?results=5');
    return PeopleModel.fromJson(response.data);
  }
}
