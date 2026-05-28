library;

import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/constants/border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection/service_locator.dart';
import '../../application/usecases/get_education_article_image_usecase.dart';

/// Detail-only cover art from `GET /driver/education/:id/image` (binary bytea, not a URL).
class EducationArticleImage extends StatefulWidget {
  const EducationArticleImage({
    super.key,
    required this.articleId,
    required this.hasImage,
    this.height = 160,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String articleId;
  final bool hasImage;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  State<EducationArticleImage> createState() => _EducationArticleImageState();
}

class _EducationArticleImageState extends State<EducationArticleImage> {
  final _fetchImage = getIt<GetEducationArticleImageUseCase>();

  Uint8List? _bytes;
  bool _loading = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _loadIfNeeded();
  }

  @override
  void didUpdateWidget(covariant EducationArticleImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.articleId != widget.articleId ||
        oldWidget.hasImage != widget.hasImage) {
      _bytes = null;
      _failed = false;
      _loadIfNeeded();
    }
  }

  void _loadIfNeeded() {
    if (!widget.hasImage || widget.articleId.isEmpty) return;
    setState(() {
      _loading = true;
      _failed = false;
    });
    _fetchImage(widget.articleId).then((bytes) {
      if (!mounted) return;
      setState(() {
        _bytes = bytes;
        _loading = false;
        _failed = bytes == null || bytes.isEmpty;
      });
    }).catchError((_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasImage) {
      return _placeholder(context);
    }
    if (_loading) {
      return _placeholder(
        context,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (_failed || _bytes == null) {
      return _placeholder(context);
    }

    final radius = widget.borderRadius ?? BorderRadius.circular(BorderRadiusValues.lg);
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: widget.height,
        width: widget.width ?? double.infinity,
        child: Image.memory(
          _bytes!,
          fit: widget.fit,
          errorBuilder: (_, __, ___) => _placeholder(context),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context, {Widget? child}) {
    final radius = widget.borderRadius ?? BorderRadius.circular(BorderRadiusValues.lg);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        height: widget.height,
        width: widget.width ?? double.infinity,
        color: AppColors.surfaceMuted,
        alignment: Alignment.center,
        child: child ??
            Icon(
              Icons.image_outlined,
              size: (widget.height ?? 48) * 0.35,
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}
