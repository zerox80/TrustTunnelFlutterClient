import 'package:flutter/material.dart';
import 'package:vpn/view/scaffold_wrapper.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Test widget'),
          ),
          body: const Center(
            child: Text('Get platform version'),
          ),
        ),
      );
}
