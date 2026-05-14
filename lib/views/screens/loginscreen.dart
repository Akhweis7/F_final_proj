import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'register.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff154c79),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/canvanLogo.png',
                    height: 230,
                    width: 180,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Email',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                Obx(() => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                        hintText: 'Enter your password',
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.black.withOpacity(0.5),
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black.withOpacity(0.5),
                            size: 20,
                          ),
                          onPressed: () => controller.obscurePassword.value =
                              !controller.obscurePassword.value,
                        ),
                      ),
                    )),
                const SizedBox(height: 40),
                Obx(() => Center(
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : GestureDetector(
                              onTap: controller.login,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                height: 45,
                                width: 90,
                                child: const Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff154c79),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    InkWell(
                      onTap: () => Get.to(() => const RegisterScreen()),
                      child: const Text(
                        ' Register',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
