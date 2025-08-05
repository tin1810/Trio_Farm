import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trio_farm_app/features/posts/provider/post_provider.dart';
import 'package:trio_farm_app/features/posts/screens/post_list_screen.dart';

import '../../../mocks.dart';

void main() {
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
  });

  Widget buildTestableWidget(Widget child) {
    return ProviderScope(
      overrides: [
        PostProviders.postRepositoryProvider.overrideWithValue(
          mockPostRepository,
        ),
      ],
      child: MaterialApp(home: child),
    );
  }

  group('PostListScreen', () {
    testWidgets('displays posts and scrolls to find off-screen posts', (
      tester,
    ) async {
      final mockPosts = [
        createDummyPost(id: 1, title: 'First Post Title'),
        createDummyPost(id: 2, title: 'Second Post Title'),
      ];
      when(
        () => mockPostRepository.getPosts(),
      ).thenAnswer((_) async => mockPosts);

      await tester.pumpWidget(buildTestableWidget(const PostListScreen()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('post_card_1')), findsOneWidget);

      final scrollableFinder = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      );

      expect(scrollableFinder, findsOneWidget);

      await tester.scrollUntilVisible(
        find.byKey(const Key('post_card_2')),
        200.0,
        scrollable: scrollableFinder,
      );

      expect(find.byKey(const Key('post_card_2')), findsOneWidget);
    });

    testWidgets('displays error message and retry button on failure', (
      tester,
    ) async {
      final error = Exception('Failed to load posts');
      when(() => mockPostRepository.getPosts()).thenThrow(error);

      await tester.pumpWidget(buildTestableWidget(const PostListScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('An error occurred: $error'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
    });
  });
}
