import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trio_farm_app/data/model/post_model.dart';
import 'package:trio_farm_app/features/posts/provider/post_provider.dart';
import 'package:trio_farm_app/features/posts/screens/create_post_screen.dart';

import '../../../mocks.dart';

void main() {
  late MockPostRepository mockPostRepository;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockPostRepository = MockPostRepository();
    mockNavigatorObserver = MockNavigatorObserver();
    registerFallbackValue(FakeRoute());
  });

  Future<void> pumpCreateScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          PostProviders.postRepositoryProvider.overrideWithValue(
            mockPostRepository,
          ),
        ],
        child: MaterialApp(
          home: const CreatePostScreen(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  group('CreatePostScreen', () {
    testWidgets('Post button is disabled when text fields are empty', (
      tester,
    ) async {
      await pumpCreateScreen(tester);

      final postButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Post'),
      );

      expect(postButton.onPressed, isNull);
    });

    testWidgets('Post button is enabled when both text fields are filled', (
      tester,
    ) async {
      await pumpCreateScreen(tester);

      await tester.enterText(find.byType(TextFormField).first, 'Test Title');
      await tester.enterText(find.byType(TextFormField).last, 'Test Body');
      await tester.pump();

      final postButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Post'),
      );
      expect(postButton.onPressed, isNotNull);
    });

    testWidgets('calls createPost, shows snackbar, and then pops screen', (
      tester,
    ) async {
      // ARRANGE
      const title = 'My New Post';
      const body = 'Awesome content here.';
      final completer = Completer<Post>();

      when(
        () => mockPostRepository.createPost(title, body),
      ).thenAnswer((_) => completer.future);

      await pumpCreateScreen(tester);

      await tester.enterText(find.byType(TextFormField).first, title);
      await tester.enterText(find.byType(TextFormField).last, body);
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Post'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(createDummyPost(title: title, body: body));

      await tester.pumpAndSettle();

      expect(find.text('Post created successfully!'), findsNothing);

      verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
    });
  });
}
