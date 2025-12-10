import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/feature/routing/routing/bloc/routing_bloc.dart';
import 'package:vpn/feature/routing/routing/view/widget/routing_screen_view.dart';

class RoutingScreen extends StatefulWidget {
  const RoutingScreen({super.key});

  @override
  State<RoutingScreen> createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoutingBloc>().add(
      const RoutingEvent.fetch(),
    );
  }

  @override
  Widget build(BuildContext context) => const RoutingScreenView();
}
