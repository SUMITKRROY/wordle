import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onPause,
    this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        if (onPause != null)
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: onPause,
            tooltip: 'Pause Game',
          ),
        if (onResume != null)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: onResume,
            tooltip: 'Resume Game',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 