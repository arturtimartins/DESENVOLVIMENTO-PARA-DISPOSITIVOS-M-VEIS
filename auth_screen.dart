import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final Function(String email, String password) onLogin;

  const AuthScreen({super.key, required this.onLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  bool _obscureLoginPassword = true;
  bool _obscureSignupPassword = true;
  bool _obscureSignupConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um email válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onLogin(email, password);
  }

  void _handleSignup() {
    final email = _signupEmailController.text.trim();
    final password = _signupPasswordController.text.trim();
    final confirmPassword = _signupConfirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um email válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 6 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onLogin(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF7C3AED),
              const Color(0xFF6D28D9),
              const Color(0xFF5B21B6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header com título
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.check_circle,
                          size: 80,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Task Manager',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Artur Martins Silva',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              // Tabs
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: const Color(0xFF7C3AED),
                        labelColor: const Color(0xFF7C3AED),
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(text: 'Entrar'),
                          Tab(text: 'Cadastrar'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Login Tab
                            _buildLoginTab(),
                            // Signup Tab
                            _buildSignupTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: _loginEmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'seu@email.com',
              prefixIcon: const Icon(Icons.email, color: Color(0xFF7C3AED)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF7C3AED),
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _loginPasswordController,
            obscureText: _obscureLoginPassword,
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF7C3AED)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureLoginPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: const Color(0xFF7C3AED),
                ),
                onPressed: () {
                  setState(() {
                    _obscureLoginPassword = !_obscureLoginPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF7C3AED),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Entrar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: _signupEmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'seu@email.com',
              prefixIcon: const Icon(Icons.email, color: Color(0xFF7C3AED)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF7C3AED),
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _signupPasswordController,
            obscureText: _obscureSignupPassword,
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF7C3AED)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureSignupPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: const Color(0xFF7C3AED),
                ),
                onPressed: () {
                  setState(() {
                    _obscureSignupPassword = !_obscureSignupPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF7C3AED),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _signupConfirmPasswordController,
            obscureText: _obscureSignupConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirmar Senha',
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF7C3AED)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureSignupConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: const Color(0xFF7C3AED),
                ),
                onPressed: () {
                  setState(() {
                    _obscureSignupConfirmPassword =
                        !_obscureSignupConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF7C3AED),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cadastrar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
