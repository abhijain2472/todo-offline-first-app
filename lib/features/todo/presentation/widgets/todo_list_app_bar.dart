import 'package:flutter/material.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class TodoListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TodoListAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.translations.appTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }
}
