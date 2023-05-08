import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:twitter_clone/theme/theme.dart";

class SideDrawer extends ConsumerWidget {
  const SideDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("My Profile"),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
