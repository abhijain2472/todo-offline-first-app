import 'package:flutter/material.dart';

class LoadingTodoView extends StatelessWidget {
  const LoadingTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
