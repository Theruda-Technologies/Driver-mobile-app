library;

import '../models/education_article_model.dart';

import 'dart:typed_data';

abstract class EducationRemoteDataSource {
  Future<List<EducationArticleModel>> listAll();
  Future<List<EducationArticleModel>> search(String query);
  Future<EducationArticleModel> getById(String id);
  Future<Uint8List?> fetchArticleImageBytes(String articleId);
}
