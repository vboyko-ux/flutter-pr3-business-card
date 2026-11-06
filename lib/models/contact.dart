import 'package:flutter/widgets.dart';

/// Незмінна модель одного контакту.
@immutable
class Contact {
  const Contact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;
}
