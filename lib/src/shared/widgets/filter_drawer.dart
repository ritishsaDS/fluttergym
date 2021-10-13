import 'package:flutter/material.dart';

import '../common.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({
    this.items = const {},
    this.selectedKeys = const {},
    Key? key,
  }) : super(key: key);

  final Map<String, ValueChanged<bool?>> items;
  final Set<String> selectedKeys;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kPrimaryAppColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var item in items.entries)
                GymDrawerListTile(
                  label: item.key,
                  selected: selectedKeys.contains(item.key),
                  onChanged: item.value,
                )
            ],
          ),
        ),
      ),
    );
  }
}

class GymDrawerListTile extends StatelessWidget {
  const GymDrawerListTile({
    required this.label,
    this.onChanged,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  final String label;

  final bool selected;

  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Checkbox(
        value: selected,
        onChanged: onChanged,
        fillColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}

class FilterChipList extends StatelessWidget {
  const FilterChipList({
    this.items = const {},
    this.selectedKeys = const {},
    Key? key,
  }) : super(key: key);

  final Map<String, ValueChanged<bool?>> items;

  final Set<String> selectedKeys;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: [
        for (var item in items.entries)
          FilterChip(
            selected: selectedKeys.contains(item.key),
            label: Text(
              item.key,
              style: Theme.of(context).textTheme.caption,
            ),
            onSelected: (value) {
              item.value(value);
            },
          )
      ],
    );
  }
}
