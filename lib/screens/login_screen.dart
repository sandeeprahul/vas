import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/login_controller.dart';
import 'package:vas/widgets/animal_bg_widget.dart';


import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final AuthController authController = Get.put(AuthController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginController loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
                gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppThemes.light.primaryColor,
              AppThemes.light.primaryColor.withOpacity(0.55),
              AppThemes.light.primaryColor.withOpacity(0.6),
              Colors.white,
              /*   AppThemes.light.primaryColor,
                  Colors.white54,
                  Colors.white,*/
            ],
          ),
        ),
        child: Stack(

          children: [
            const AnimalBgWidget(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                        // Logo and App Name
                          Container(
                          padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(36),

                              child: Image.asset('assets/logo_vas.jpeg',scale: 7,))
                        ),
                        // const SizedBox(height: 24),
                        const Text(
                          '1962 - MVU APP',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Veterinary Assistant System',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 38),

                        // Login Form Card
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                // Username Field
                                TextFormField(
                                  controller: loginController.usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: const Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppThemes.light.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your username';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Password Field
                                TextFormField(
                                  controller: loginController.passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppThemes.light.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Login Button
                                Obx(() => SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                          child: ElevatedButton(
                                    onPressed: loginController.isLoading.value
                                        ? null
                                        : () {
                                            if (_formKey.currentState!.validate()) {
                                              loginController  . loginUser(
                                              );
                                            }
                                          },
                                            style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: loginController.isLoading.value
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'LOGIN',
                                                    style: TextStyle(
                                              fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                            ),
                                            ),
                                          ),
                                        )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                      textAlign: TextAlign.center,
                          'Powered by\nBHSPL',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                    const SizedBox(height: 8),

                    const Text(
                      'Version:1.0',
                      style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                        // Error Message
                 /*       Obx(() {
                          if (loginController.errorMessage.value.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                authController.errorMessage.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                  ),
                );
              }
                          return const SizedBox.shrink();
                        }),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
