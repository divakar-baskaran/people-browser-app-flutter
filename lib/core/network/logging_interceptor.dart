import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/check_null.dart';
import 'server.dart' as server;

class LoggingInterceptor {
  // ══════════════════════════════╡ REQUEST ╞══════════════════════════════
  static void onRequest(
    server.Request requestType,
    String url,
    Map<String, String>? header,
    Object? body,
  ) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();

    buffer.writeln(_title('REQUEST START'));

    buffer.writeln('METHOD  : ${requestType.name}');
    buffer.writeln('URL     : $url');

    if (header != null && header.isNotEmpty) {
      buffer.writeln('HEADERS :');
      buffer.writeln(_jsonString(header));
    }

    if (body != null && body.toString().isNotEmpty) {
      buffer.writeln('BODY    :');
      buffer.writeln(_jsonString(body));
    }

    buffer.writeln(_title('REQUEST END'));

    log(buffer.toString(), name: 'API');
  }

  // ══════════════════════════════╡ RESPONSE ╞══════════════════════════════
  static void onResponse(Response response) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();

    buffer.writeln(_title('RESPONSE START'));

    buffer.writeln('METHOD  : ${response.requestOptions.method}');
    buffer.writeln('URL     : ${response.requestOptions.uri}');
    buffer.writeln(
        'STATUS  : ${response.statusCode} (${response.statusMessage})');

    if (response.data != null && response.data.toString().isNotEmpty) {
      buffer.writeln('BODY    :');
      buffer.writeln(_jsonString(response.data));
    }

    buffer.writeln(_title('RESPONSE END'));

    log(buffer.toString(), name: 'API');
  }

  // ══════════════════════════════╡ ERROR ╞══════════════════════════════
  static void onError(DioException err) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();

    buffer.writeln(_title('ERROR'));

    buffer.writeln('METHOD  : ${err.requestOptions.method}');
    buffer.writeln('URL     : ${err.requestOptions.uri}');
    buffer.writeln('STATUS  : ${err.response?.statusCode ?? 'UNKNOWN'}');

    if (CheckNull.string(err.message).isNotEmpty) {
      buffer.writeln('MESSAGE : ${err.message}');
    }

    if (err.response?.data != null) {
      buffer.writeln('BODY    :');
      buffer.writeln(_jsonString(err.response?.data));
    }

    buffer.writeln(_title('ERROR END'));

    log(buffer.toString(), name: 'API');
  }

  // ══════════════════════════════╡ HELPER ╞══════════════════════════════

  static String _jsonString(dynamic jsonObject) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObject);
  }

  static String _title(String title) {
    return '══════════════════════════════╡ $title ╞══════════════════════════════';
  }
}

class DioLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoggingInterceptor.onRequest(
      _methodToRequest(options.method),
      options.uri.toString(),
      options.headers.map(
        (k, v) => MapEntry(k, v?.toString() ?? ''),
      ),
      options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LoggingInterceptor.onResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggingInterceptor.onError(err);
    handler.next(err);
  }
}

server.Request _methodToRequest(String method) {
  switch (method.toUpperCase()) {
    case 'GET':
      return server.Request.get;
    case 'POST':
      return server.Request.post;
    case 'PUT':
      return server.Request.put;
    case 'PATCH':
      return server.Request.patch;
    case 'DELETE':
      return server.Request.delete;
    case 'HEAD':
      return server.Request.head;
    default:
      return server.Request.get;
  }
}
