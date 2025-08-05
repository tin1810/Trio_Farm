import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trio_farm_app/core/network/api_client.dart';
import 'package:trio_farm_app/data/model/comment_model.dart';
import 'package:trio_farm_app/data/model/post_model.dart';
import 'package:trio_farm_app/data/repository/post_repository.dart';

class PostProviders {
  static final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

  static final postRepositoryProvider = Provider<PostRepository>((ref) {
    return PostRepository(ref.watch(apiClientProvider));
  });

  static final postsProvider = FutureProvider<List<Post>>((ref) {
    final repository = ref.watch(postRepositoryProvider);
    return repository.getPosts();
  });

  static final postDetailProvider = FutureProvider.family<Post, int>((
    ref,
    postId,
  ) {
    final repository = ref.watch(postRepositoryProvider);
    return repository.getPostDetails(postId);
  });
  static final commentsProvider = FutureProvider.family<List<Comment>, int>((
    ref,
    postId,
  ) {
    final repository = ref.watch(postRepositoryProvider);
    return repository.getComments(postId);
  });
}
