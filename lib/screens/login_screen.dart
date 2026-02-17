import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isLogin;
  
  const LoginScreen({super.key, this.isLogin = true});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late bool _isLogin;
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isDarkMode = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
    _animationController.reset();
    _animationController.forward();
  }

  // ฟังก์ชันสำหรับ Login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ฟังก์ชันสำหรับ Register
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signUpWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ฟังก์ชันสำหรับรีเซ็ตรหัสผ่าน
  Future<void> _handleForgotPassword() async {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF16213e) : Colors.white,
        title: Text(
          'รีเซ็ตรหัสผ่าน',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'กรอกอีเมลของคุณ',
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white38 : Colors.grey[400],
            ),
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF0f3460) : const Color(0xFFF0F4FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.trim().isEmpty) {
                _showErrorDialog('กรุณากรอกอีเมล');
                return;
              }

              try {
                await _authService.resetPassword(
                  email: emailController.text.trim(),
                );
                
                if (mounted) {
                  Navigator.pop(context);
                  _showSuccessDialog('ส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลของคุณแล้ว');
                }
              } catch (e) {
                _showErrorDialog(e.toString());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
            ),
            child: const Text('ส่ง'),
          ),
        ],
      ),
    );
  }

  // แสดง Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF16213e) : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            Text(
              'เกิดข้อผิดพลาด',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตลกลง'),
          ),
        ],
      ),
    );
  }

  // แสดง Success Dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF16213e) : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 10),
            Text(
              'สำเร็จ',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1a1a2e) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF16213e) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Toggle Buttons
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF0f3460) : const Color(0xFFF0F4FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildToggleButton('Login', _isLogin),
                            ),
                            Expanded(
                              child: _buildToggleButton('Register', !_isLogin),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Title
                      Text(
                        _isLogin ? 'Welcome Back!' : 'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF4A90E2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isLogin 
                            ? "Login to continue shopping" 
                            : "Sign up to start shopping",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 30),

                      if (!_isLogin) ...[
                        _buildTextField(
                          controller: _usernameController,
                          hint: 'Username',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggleObscure: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      // Confirm Password (only for Register)
                      if (!_isLogin) ...[
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscureText: _obscureConfirmPassword,
                          onToggleObscure: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],

                      // Forgot Password (only for Login)
                      if (_isLogin) ...[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _handleForgotPassword,
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : (_isLogin ? _handleLogin : _handleRegister),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isLogin ? 'Login' : 'Sign Up',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Social Login
                      Text(
                        'Or continue with',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : const Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(Icons.g_mobiledata),
                          const SizedBox(width: 15),
                          _buildSocialButton(Icons.facebook),
                          const SizedBox(width: 15),
                          _buildSocialButton(Icons.apple),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: isActive ? null : _toggleMode,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive 
              ? (isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isActive 
                ? Colors.white 
                : (isDarkMode ? Colors.white60 : const Color(0xFF666666)),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        fontSize: 16,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white38 : Colors.grey[400],
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF0f3460) : const Color(0xFFF0F4FF),
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
                ),
                onPressed: onToggleObscure,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF0f3460) : const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? const Color(0xFF4A90E2).withOpacity(0.3) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 32,
          color: isDarkMode ? Colors.white70 : const Color(0xFF4A90E2),
        ),
      ),
    );
  }
}