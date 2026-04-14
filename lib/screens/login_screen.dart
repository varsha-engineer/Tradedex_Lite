import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'market_watch_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _loading = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _showMessage(
    String message, {
    Color background = Colors.indigo,
  }) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _attemptLogin(AuthProvider auth) async {
    setState(() {
      _loading = true;
    });

    final success = await auth.login(emailController.text, passController.text);

    setState(() {
      _loading = false;
    });

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MarketWatchScreen()),
      );
    } else {
      _showMessage(
        'Enter a valid email and password with at least 4 characters.',
        background: Colors.redAccent,
      );
    }
  }

  Future<void> _attemptBiometric(AuthProvider auth) async {
    setState(() {
      _loading = true;
    });

    final success = await auth.biometricLogin();

    setState(() {
      _loading = false;
    });

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MarketWatchScreen()),
      );
    } else {
      _showMessage(
        'Biometric authentication failed or is not available.',
        background: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
                : const [Color(0xFF0C2F71), Color(0xFF1E7FE6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color.fromRGBO(30, 41, 59, 0.96)
                      : const Color.fromRGBO(255, 255, 255, 0.96),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, isDarkMode ? 0.4 : 0.18),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'TradeX Lite',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF172B4D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Secure access to your market watch list with password or biometrics.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : const Color(0xFF5A6A82),
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        prefixIcon: const Icon(Icons.alternate_email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: passController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _loading ? null : () => _attemptLogin(auth),
                      child: _loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(height: 14),
                    if (auth.biometricAvailable)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: isDarkMode
                              ? Colors.blue.shade400
                              : const Color(0xFF0D47A1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.fingerprint, size: 22),
                        label: const Text(
                          'Login with biometrics',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onPressed: _loading
                            ? null
                            : () => _attemptBiometric(auth),
                      ),
                    if (!auth.biometricAvailable)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Biometric login is not available on this device.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey.shade500
                                : const Color(0xFF8C96A8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
