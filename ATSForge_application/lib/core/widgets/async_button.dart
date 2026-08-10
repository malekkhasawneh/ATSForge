import 'package:flutter/material.dart';

class AsyncButton extends StatelessWidget {
  const AsyncButton(
      {required this.label,
      required this.onPressed,
      super.key,
      this.loading = false,
      this.icon});
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox.square(
                dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(icon ?? Icons.arrow_forward_rounded),
        label: Text(loading ? 'Please wait…' : label),
      );
}
