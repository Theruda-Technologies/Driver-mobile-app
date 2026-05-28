library;

import 'dart:typed_data';

import '../entities/education_article.dart';

abstract class EducationRepository {
  Future<List<EducationArticle>> listAll();
  Future<List<EducationArticle>> search(String query);
  Future<EducationArticle> getById(String id);
  Future<Uint8List?> fetchArticleImage(String articleId);
}
