import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../views/screens/kanban_board_screen.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  final AuthService _authService = AuthService();

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$')
        .hasMatch(email.trim());
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackbar('Please fill all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorSnackbar('Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    try {
      final credential = await _authService.login(email, password);
      final username = credential.user?.displayName ?? credential.user?.email ?? '';
      _showSuccessSnackbar('Welcome back', 'Logged in successfully');
      Get.offAll(() => KanbanBoardScreen(username: username));
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(_firebaseErrorMessage(e.code));
    } catch (e) {
      _showErrorSnackbar('An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorSnackbar('Please fill all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorSnackbar('Please enter a valid email address');
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackbar('Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.signUp(username, email, password);
      _showSuccessSnackbar(
        'Account Created',
        'Welcome, $username! Your account was created successfully.',
      );
      _clearRegisterFields();
      Get.offAll(() => KanbanBoardScreen(username: username));
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(_firebaseErrorMessage(e.code));
    } catch (e) {
      _showErrorSnackbar('An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  String _firebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication error: $code';
    }
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  void _clearRegisterFields() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    obscurePassword.value = true;
    obscureConfirmPassword.value = true;
  }
}
