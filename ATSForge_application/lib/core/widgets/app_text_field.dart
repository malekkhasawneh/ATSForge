import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    super.key,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
  });
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) => TextFormField(
        key: ValueKey(label),
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: label, hintText: hint, alignLabelWithHint: maxLines > 1),
      );
}
