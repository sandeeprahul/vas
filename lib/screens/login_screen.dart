import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);

  // const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final LoginController controller = Get.put(LoginController());

  // const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B3486), // Dark blue background
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height / 2.3,
              width: double.infinity,
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    tileMode: TileMode.repeated,
                    colors: [Colors.blue, Colors.cyan]),
              ),
              child: const Center(
                child: Text(
                  textAlign: TextAlign.center,
                  '',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 75,
                  child: Text('VAS',style: TextStyle(fontSize: 40),),
                ),
                const SizedBox(height: 30,),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    // Allows overflow outside the Stack
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: 320,
                        // height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white, // Light blue card
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              // blurRadius: 10,
                              spreadRadius: 0.8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "SIGN IN",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 18),
                            _buildTextField(controller.usernameController,
                                "Username", Icons.person),
                            const SizedBox(height: 12),
                            _buildTextField(controller.passwordController,
                                "Password", Icons.lock,
                                isPassword: true),
                            const SizedBox(
                              height: 30,
                            ),


                            Center(
                              child: Obx(() => controller.isLoading.value
                                  ? Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Colors.blue, Colors.cyan],
                                          // Change colors as needed
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: const CircularProgressIndicator(),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Colors.blue, Colors.cyan],
                                          // Change colors as needed
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: controller.loginUser,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          // Important for gradient effect
                                          shadowColor: Colors.transparent,
                                          // Removes default button shadow
                                          // Yellow button
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          // padding: const EdgeInsets.symmetric(
                                          //     horizontal: 80, vertical: 14),
                                          elevation: 5,
                                        ),
                                        child:  const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                "SIGN IN",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            TextButton(
                               onPressed: () {  }, child: Text('Forgot password?',style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade200,
                            ),),
                            ),
                            const SizedBox(
                              height: 16,
                            ),

                          ],
                        ),
                      ),

                      // Sign In Button Positioned Outside the Card
                      /*  Positioned(
                        bottom: 25, // Move button outside the card
                        left: 0,
                        right: 0,
                        child:
                      ),*/

                    ],
                  ),
                ),
                const SizedBox(height: 12,),
                const Text(
                  textAlign: TextAlign.center,
                  "Version: 1.0.0",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        // Background color
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
          size: 20,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
      ),
    );
  }
}
/*
class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Colors.blue.shade800,Colors.green.shade50,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text("Login", style: TextStyle(fontSize: 18)),
                  )),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/
