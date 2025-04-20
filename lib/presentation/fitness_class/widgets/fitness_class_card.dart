import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_demo/core/extensions/build_context.dart';
import 'package:fitness_demo/domain/models/fitness_class.dart';
import 'package:fitness_demo/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FitnessClassCard extends StatelessWidget {
  final FitnessClass info;

  const FitnessClassCard({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.instructor, extra: info);
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(0, 4),
              blurRadius: 6,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          spacing: 16.0,
          children: [
            Hero(
              tag: info.classId,
              child: CachedNetworkImage(
                imageUrl: "https://picsum.photos/id/${info.imageId}/100/100",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),
            Column(
              spacing: 8.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.className,
                  maxLines: 2,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                Text(info.classType),
                ComplexityTag(
                  complexity: info.complexity,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ComplexityTag extends StatelessWidget {
  final String complexity;

  const ComplexityTag({
    super.key,
    required this.complexity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border.all(
          color: switch (complexity) {
            'beginner' => Colors.green,
            'moderate' => Colors.blue,
            'advanced' => Colors.red,
            _ => Colors.orange,
          },
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(complexity.toUpperCase()),
    );
  }
}
