import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trio_farm_app/core/util/app_constant.dart';
import 'package:trio_farm_app/data/model/post_model.dart';
import 'package:trio_farm_app/data/repository/post_repository.dart';

import '../../mocks.dart';

void main() {
  late PostRepository postRepository;
  late MockApiClient mockApiClient;
  late MockResponse mockResponse;

  setUp(() {
    mockApiClient = MockApiClient();
    postRepository = PostRepository(mockApiClient);
    mockResponse = MockResponse();
  });

  void setupMockSuccess(String responseBody) {
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.body).thenReturn(responseBody);
  }

  group('PostRepository', () {
    group('getPosts', () {
      final postsListJson = jsonEncode([
        {'id': 1, 'userId': 1, 'title': 'Post 1', 'body': 'Body 1'},
        {'id': 2, 'userId': 1, 'title': 'Post 2', 'body': 'Body 2'},
      ]);

      test(
        'should return a List<Post> when the API call is successful',
        () async {
          setupMockSuccess(postsListJson);
          when(
            () => mockApiClient.get(AppConstant.postUrl),
          ).thenAnswer((_) async => mockResponse);

          final result = await postRepository.getPosts();

          expect(result, isA<List<Post>>());
          expect(result.length, 2);
          verify(() => mockApiClient.get(AppConstant.postUrl)).called(1);
        },
      );

      test('should throw an exception when the API call fails', () async {
        when(
          () => mockApiClient.get(any()),
        ).thenThrow(Exception('Network Failed'));

        final call = postRepository.getPosts;

        expect(() => call(), throwsA(isA<Exception>()));
      });
    });

    group('createPost', () {
      const title = 'New Post';
      const body = 'This is the body';
      final createdPostJson = jsonEncode({
        'id': 101,
        'userId': 1,
        'title': title,
        'body': body,
      });

      test(
        'should return the created Post when the API call is successful',
        () async {
          setupMockSuccess(createdPostJson);
          when(
            () => mockApiClient.post(
              AppConstant.postUrl,
              body: any(named: 'body'),
            ),
          ).thenAnswer((_) async => mockResponse);

          final result = await postRepository.createPost(title, body);

          expect(result.title, title);
          expect(result.id, 101);
          verify(
            () => mockApiClient.post(
              AppConstant.postUrl,
              body: {'title': title, 'body': body, 'userId': 1},
            ),
          ).called(1);
        },
      );
    });
  });
}
