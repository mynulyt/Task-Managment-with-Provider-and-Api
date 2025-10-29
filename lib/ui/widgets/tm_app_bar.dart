import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_mngwithprovider/ui/provider_controller/app_bar_provider.dart';
import 'package:task_mngwithprovider/ui/screens/login_screen.dart';
import 'package:task_mngwithprovider/ui/screens/update_profile_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({super.key, this.fromUpdateProfile});

  final bool? fromUpdateProfile;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppBarProvider>();

    return AppBar(
      backgroundColor: Colors.purpleAccent,
      title: GestureDetector(
        onTap: () {
          if (fromUpdateProfile ?? false) return;
          Navigator.pushNamed(context, UpdateProfileScreen.name);
        },
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(
              child: p.photoBytes != null
                  ? Image.memory(p.photoBytes!)
                  : const Icon(Icons.person),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.fullName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                Text(
                  p.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await context.read<AppBarProvider>().signOut();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.name,
                (predicate) => false,
              );
            }
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
