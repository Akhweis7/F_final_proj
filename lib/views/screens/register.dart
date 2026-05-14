import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff154c79),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: const Text(
                    'Register New User',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.usernameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
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
                Obx(() => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
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
                const SizedBox(height: 20),
                Obx(() => TextField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.obscureConfirmPassword.value,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.black.withOpacity(0.5),
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureConfirmPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black.withOpacity(0.5),
                            size: 20,
                          ),
                          onPressed: () =>
                              controller.obscureConfirmPassword.value =
                                  !controller.obscureConfirmPassword.value,
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : InkWell(
                        onTap: controller.signUp,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: const Text(
                            ' Register ',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
