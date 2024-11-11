import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool showMenuButton;

  CustomAppBar({
    required this.title,
    this.actions = const [],
    this.showMenuButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showMenuButton
          ? IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Ouvre le Drawer
              },
            )
          : null,
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
