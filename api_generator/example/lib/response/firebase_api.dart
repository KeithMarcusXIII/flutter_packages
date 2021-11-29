import 'package:api_annotations/api_annotations.dart';
import 'package:api_generator_example/response/firebase_api_error.dart';
import 'package:api_generator_example/response/response.dart';
import 'package:api_generator_example/response/user.dart';
import 'package:dio/dio.dart' hide Response;

part 'firebase_api.g.dart';

@RestApi(baseUrl: 'https://test-b9ce2.firebaseio.com')
abstract class FirebaseApi {
  @PUT('/users/{id}.json')
  Future<Response<dynamic, FirebaseApiError>> createUser(
    @Field('id') String id, {
    @Field('email') required String email,
    @Field('phone_no') String? phoneNo,
    @Field('full_name') String? fullName,
  });

  @GET('/users/{id}.json')
  Future<Response<User, FirebaseApiError>> getUser(@Field('id') String id);

  @PATCH('/users/{id}.json')
  Future<Response<User, FirebaseApiError>> updateUser(
    @Field('id') String id, {
    @Field('phone_np') String? phoneNo,
    @Field('full_name') String? fullName,
  });
}
