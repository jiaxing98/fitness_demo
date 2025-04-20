import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_demo/core/extensions/build_context.dart';
import 'package:fitness_demo/domain/models/instructor_with_class.dart';
import 'package:flutter/material.dart';

class InstructorCard extends StatelessWidget {
  final InstructorWithClass info;

  const InstructorCard({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          CachedNetworkImage(
            imageUrl: "https://picsum.photos/id/${info.imageId}/120/120",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
          ),
          Column(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              Text(info.availableDateTime.toIso8601String().split('T').first),
              OutlinedButton(onPressed: () {}, child: Text('Book Now')),
            ],
          ),
        ],
      ),
    );
  }
}
