import "package:flutter/material.dart";

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const DeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.cancel_outlined,
        color: Colors.red,
        size: 20,
      ),
    );
  }
}
