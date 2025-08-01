// lib/app_route.dart
import 'package:go_router/go_router.dart';
import 'package:trio_farm/features/posts/screens/post_detail_screen.dart';
import 'package:trio_farm/features/posts/screens/post_list_screen.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const PostListScreen()),
      GoRoute(
        path: '/post/:id',
        builder: (context, state) {
          final postId = int.parse(state.pathParameters['id']!);
          return PostDetailScreen(postId: postId);
        },
      ),
    ],
  );
}
