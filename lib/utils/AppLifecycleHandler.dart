// lib/widgets/app_lifecycle_handler.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/login_controller.dart';

class AppLifecycleHandler extends StatefulWidget {
  final Widget child;

  const AppLifecycleHandler({
    super.key,
    required this.child,
  });

  @override
  State<AppLifecycleHandler> createState() => _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends State<AppLifecycleHandler> with WidgetsBindingObserver {
  final LoginController _loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // App came to foreground
      await _loginController.handleAutoLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}