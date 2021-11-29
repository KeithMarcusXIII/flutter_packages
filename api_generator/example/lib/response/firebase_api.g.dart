// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_api.dart';

// **************************************************************************
// ApiGenerator
// **************************************************************************

class _FirebaseApi implements FirebaseApi {
  _FirebaseApi(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://test-b9ce2.firebaseio.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Response<dynamic, FirebaseApiError>> createUser(id,
      {required email, phoneNo, fullName}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'id': id,
      'email': email,
      'phone_no': phoneNo,
      'full_name': fullName
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Response<dynamic, FirebaseApiError>>(
            Options(method: 'PUT', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/users/{id}.json',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Response<dynamic, FirebaseApiError>.fromJson(
      _result.data!,
      (json) => json as dynamic,
      (json) => FirebaseApiError.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<Response<User, FirebaseApiError>> getUser(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'id': id};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Response<User, FirebaseApiError>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/users/{id}.json',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Response<User, FirebaseApiError>.fromJson(
      _result.data!,
      (json) => User.fromJson(json as Map<String, dynamic>),
      (json) => FirebaseApiError.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<Response<User, FirebaseApiError>> updateUser(id,
      {phoneNo, fullName}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'id': id, 'phone_np': phoneNo, 'full_name': fullName};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Response<User, FirebaseApiError>>(Options(
                method: 'PATCH', headers: <String, dynamic>{}, extra: _extra)
            .compose(_dio.options, '/users/{id}.json',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Response<User, FirebaseApiError>.fromJson(
      _result.data!,
      (json) => User.fromJson(json as Map<String, dynamic>),
      (json) => FirebaseApiError.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  RequestOptions newRequestOptions(Options? options) {
    if (options is RequestOptions) {
      return options as RequestOptions;
    }
    if (options == null) {
      return RequestOptions(path: '');
    }
    return RequestOptions(
      path: '',
      method: options.method,
      sendTimeout: options.sendTimeout,
      receiveTimeout: options.receiveTimeout,
      extra: options.extra,
      headers: options.headers,
      responseType: options.responseType,
      contentType: options.contentType.toString(),
      validateStatus: options.validateStatus,
      receiveDataWhenStatusError: options.receiveDataWhenStatusError,
      followRedirects: options.followRedirects,
      maxRedirects: options.maxRedirects,
      requestEncoder: options.requestEncoder,
      responseDecoder: options.responseDecoder,
    );
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
