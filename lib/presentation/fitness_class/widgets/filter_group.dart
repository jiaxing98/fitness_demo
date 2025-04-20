import 'package:fitness_demo/core/extensions/build_context.dart';
import 'package:fitness_demo/presentation/fitness_class/blocs/fitness_class_bloc.dart';
import 'package:fitness_demo/presentation/fitness_class/widgets/fitness_class_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterGroup extends SliverPersistentHeaderDelegate {
  final List<String> availableClasses;
  final double height;
  final void Function(List<String>)? onTap;

  const FilterGroup({
    required this.availableClasses,
    required this.height,
    required this.onTap,
  });

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      width: double.infinity,
      color: context.colorScheme.onPrimary,
      child: Column(
        children: [
          SearchBar(),
          StatefulFilterGroup(availableClasses: availableClasses, onTap: onTap),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant FilterGroup oldDelegate) {
    return oldDelegate.availableClasses != availableClasses;
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: isTyping ? context.colorScheme.primary : Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Search ... ",
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: (value) {
                context.read<FitnessClassBloc>().add(FitnessClassFilterByQuery(query: value));
              },
            ),
          ],
        ),
      ),
    );
  }

  void onFocusChange(bool focusChanged) {
    setState(() {
      isTyping = focusChanged;
    });
  }
}

class StatefulFilterGroup extends StatefulWidget {
  final List<String> availableClasses;
  final void Function(List<String>)? onTap;

  const StatefulFilterGroup({
    super.key,
    required this.availableClasses,
    required this.onTap,
  });

  @override
  State<StatefulFilterGroup> createState() => _StatefulFilterGroupState();
}

class _StatefulFilterGroupState extends State<StatefulFilterGroup> {
  final List<String> filters = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: double.infinity,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          ...widget.availableClasses.map((e) {
            return FitnessClassTag(
              fitnessClass: e,
              onTap: (isSelected) {
                isSelected ? filters.add(e) : filters.remove(e);
                widget.onTap?.call(filters);
              },
            );
          })
        ],
      ),
    );
  }
}
