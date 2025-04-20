import 'package:fitness_demo/core/extensions/build_context.dart';
import 'package:flutter/material.dart';

class FitnessClassTag extends StatefulWidget {
  final String fitnessClass;
  final void Function(bool)? onTap;

  const FitnessClassTag({
    super.key,
    required this.fitnessClass,
    this.onTap,
  });

  @override
  State<FitnessClassTag> createState() => _FitnessClassTagState();
}

class _FitnessClassTagState extends State<FitnessClassTag> with AutomaticKeepAliveClientMixin {
  bool isSelected = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onTap?.call(isSelected);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? context.colorScheme.primary : Colors.transparent,
          border: Border.all(width: 2.0, color: context.colorScheme.primary),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Text(
              widget.fitnessClass.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4.0),
              const Icon(
                Icons.close,
                size: 20.0,
                color: Colors.white,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
