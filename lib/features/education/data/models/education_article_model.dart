library;

import '../../domain/entities/education_article.dart';
import '../../../../core/constants/api_endpoints.dart';

class EducationArticleModel {
  const EducationArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.hasImage = false,
    this.manualUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final EducationCategory category;
  final bool hasImage;
  final String? manualUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory EducationArticleModel.fromJson(Map<String, dynamic> json) {
    return EducationArticleModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: _parseCategory(json['category']?.toString()),
      hasImage: _parseHasImage(json),
      manualUrl: _extractManualUrl(json),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: _parseDate(json['updatedAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  static bool _parseHasImage(Map<String, dynamic> json) {
    final direct = json['hasImage'] ?? json['has_image'];
    if (direct is bool) return direct;
    if (direct is num) return direct != 0;
    if (direct is String) {
      final s = direct.toLowerCase().trim();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    final image = json['image'] ?? json['imageUrl'] ?? json['image_url'];
    return image != null && image.toString().trim().isNotEmpty;
  }

  static String? _extractManualUrl(Map<String, dynamic> json) {
    final candidates = [
      json['pdf'],
      json['manualUrl'],
      json['manual_url'],
      json['pdfUrl'],
      json['pdf_url'],
      json['fileUrl'],
      json['file_url'],
      json['attachmentUrl'],
      json['attachment_url'],
      json['documentUrl'],
      json['document_url'],
    ];
    for (final raw in candidates) {
      final value = raw?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return _normalizeUrl(value, kind: _UrlKind.pdf);
      }
    }
    return null;
  }

  static String? _normalizeUrl(String? raw, {_UrlKind kind = _UrlKind.image}) {
    final value = raw?.trim().replaceAll('\\', '/');
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      // Backend can return localhost URLs, which break on Android emulator/device.
      final host = uri.host.toLowerCase();
      if (host == 'localhost' || host == '127.0.0.1') {
        final base = Uri.parse(ApiEndpoints.baseUrl);
        return uri.replace(
          scheme: base.scheme,
          host: base.host,
          port: base.hasPort ? base.port : uri.port,
        ).toString();
      }
      return value;
    }
    final base = ApiEndpoints.baseUrl.replaceAll(RegExp(r'/$'), '');
    if (value.startsWith('/uploads/')) return '$base$value';
    if (value.startsWith('uploads/')) return '$base/$value';

    final looksLikeBareFilename = !value.contains('/');
    if (looksLikeBareFilename) {
      if (value.toLowerCase().endsWith('.pdf') || kind == _UrlKind.pdf) {
        return '$base/uploads/education-manuals/$value';
      }
      return '$base/uploads/education-images/$value';
    }

    if (value.startsWith('/')) return '$base$value';
    return '$base/$value';
  }

  static EducationCategory _parseCategory(String? raw) {
    switch ((raw ?? '').toUpperCase()) {
      case 'SAFETY':
        return EducationCategory.safety;
      case 'MAINTENANCE':
        return EducationCategory.maintenance;
      case 'REPAIRS':
        return EducationCategory.repairs;
      case 'TIPS':
        return EducationCategory.tips;
      case 'MANUALS':
        return EducationCategory.manuals;
      default:
        return EducationCategory.all;
    }
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  EducationArticle toEntity() => EducationArticle(
        id: id,
        title: title,
        description: description,
        category: category,
        hasImage: hasImage,
        manualUrl: manualUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

enum _UrlKind { image, pdf }
