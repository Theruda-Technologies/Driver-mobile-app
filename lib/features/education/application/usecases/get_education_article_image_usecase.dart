library;

import 'dart:typed_data';

import '../../domain/repositories/education_repository.dart';

class GetEducationArticleImageUseCase {
  GetEducationArticleImageUseCase(this._repository);
  final EducationRepository _repository;

  Future<Uint8List?> call(String articleId) =>
      _repository.fetchArticleImage(articleId);
}
