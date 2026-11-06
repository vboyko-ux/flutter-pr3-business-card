import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../widgets/contact_card.dart';

/// Екран візитівки: аватар, ім'я, спеціальність і список контактів.
class CardScreen extends StatelessWidget {
  const CardScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  static const List<Contact> _contacts = [
    Contact(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'v.boyko@istu.edu.ua',
    ),
    Contact(icon: Icons.code, label: 'GitHub', value: 'github.com/vboyko-ux'),
    Contact(icon: Icons.school_outlined, label: 'Група', value: 'АЛК-43'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        title: const Text('Візитівка розробника'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  child: Text(
                    'ВБ',
                    style: theme.textTheme.headlineLarge
                        ?.copyWith(color: colors.onPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Вадим Бойко',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                'Інженерія програмного забезпечення',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: colors.secondary),
              ),
              const SizedBox(height: 24),
              for (final contact in _contacts) ContactCard(contact: contact),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onToggleTheme,
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                label: const Text('Змінити тему'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
