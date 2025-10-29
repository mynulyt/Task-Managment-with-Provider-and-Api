import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/app_bar_provider.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({super.key, this.fromUpdateProfile});

  final bool? fromUpdateProfile;

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.purpleAccent,
      title: GestureDetector(
        onTap: () => context.read<AppBarProvider>().goToUpdateProfile(
          context,
          fromUpdateProfile: widget.fromUpdateProfile ?? false,
        ),
        child: Row(
          children: [
            Selector<AppBarProvider, Uint8List?>(
              selector: (_, p) => p.photoBytes,
              builder: (context, bytes, _) {
                if (bytes != null && bytes.isNotEmpty) {
                  return CircleAvatar(
                    radius: 18,
                    backgroundImage: MemoryImage(bytes),
                  );
                }
                return const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person),
                );
              },
            ),
            const SizedBox(width: 6),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Selector<AppBarProvider, String>(
                    selector: (_, p) => p.fullName,
                    builder: (context, name, _) => Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                  Selector<AppBarProvider, String>(
                    selector: (_, p) => p.email,
                    builder: (context, email, _) => Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.read<AppBarProvider>().signOut(context),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
