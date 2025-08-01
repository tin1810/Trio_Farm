import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trio_farm/core/network/api_client.dart';
import 'package:trio_farm/core/util/app_constant.dart';
import 'package:trio_farm/data/model/post_model.dart';

class PostRepository {
  final ApiClient _apiClient;
  PostRepository(this._apiClient);

  Future<List<Post>> getPosts(BuildContext context) async {
    final response = await _apiClient.get(context, AppConstant.postUrl);
    final List<dynamic> data = jsonDecode(response?.body ?? "");
    return data.map((json) => Post.fromJson(json)).toList();
  }

  Future<Post> getPostDetails(BuildContext context, int id) async {
    final response = await _apiClient.get(
      context,
      '${AppConstant.postUrl}/$id',
    );
    return Post.fromJson(jsonDecode(response?.body ?? ""));
  }

  Future<Post> createPost(
    BuildContext context,
    String title,
    String body,
  ) async {
    final response = await _apiClient.post(
      context,
      AppConstant.postUrl,
      body: {'title': title, 'body': body, 'userId': 1},
    );
    return Post.fromJson(jsonDecode(response?.body ?? ""));
  }
}
