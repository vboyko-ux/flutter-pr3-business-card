import 'package:flutter/material.dart';

import '../models/contact.dart';

/// Картка одного контакту. Усі кольори беруться з Theme.of(context).
class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      color: colors.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.primaryContainer,
          foregroundColor: colors.onPrimaryContainer,
          child: Icon(contact.icon),
        ),
        title: Text(
          contact.label,
          style: theme.textTheme.labelLarge?.copyWith(color: colors.primary),
        ),
        subtitle: Text(
          contact.value,
          style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),
        ),
      ),
    );
  }
}
