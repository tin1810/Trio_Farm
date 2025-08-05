import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:trio_farm_app/core/network/api_client.dart';
import 'package:trio_farm_app/data/model/post_model.dart';
import 'package:trio_farm_app/data/repository/post_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockResponse extends Mock implements http.Response {}

class MockPostRepository extends Mock implements PostRepository {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

Post createDummyPost({
  int id = 1,
  String title = 'Test Title',
  String body = 'Test Body',
}) {
  return Post(id: id, userId: 1, title: title, body: body);
}
