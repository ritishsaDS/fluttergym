import 'package:flutter/material.dart';

import '../common.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    required this.onChanged,
    this.onFilterPressed,
    Key? key,
  }) : super(key: key);

  final ValueChanged<String> onChanged;

  final VoidCallback? onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).verticalBlockSize * 8,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: TextField(
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          focusColor: kPrimaryAppColor,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          filled: true,
          prefixIcon: onFilterPressed != null
              ? GestureDetector(
                  onTap: onFilterPressed,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 15),
                    child: Image.asset(
                      Assets.filterEggIcon,
                      height: 20,
                      width: 40,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          suffixIcon: const Icon(Icons.search_rounded),
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: 'Search',
          fillColor: Colors.white10,
        ),
      ),
    );
  }
}
