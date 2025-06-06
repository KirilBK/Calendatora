import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String? error;
  bool _obscurePassword = true;

  // Basic form submission handler
  Future<void> _handleRegister(AuthService auth) async {
    if (!_formKey.currentState!.validate()) return;

    final err = await auth.register(name, email, password);
    if (err != null && mounted) {
      setState(() => error = err);
    } else {
      Navigator.pop(context);
    }
  }

  // Simple input validation
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (error != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.shade100,
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person),
                ),
                onChanged: (value) => name = value.trim(),
                validator: (value) => _validateField(value, 'name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                onChanged: (value) => email = value.trim(),
                validator: (value) => _validateField(value, 'email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => setState(() =>
                        _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                onChanged: (value) => password = value,
                validator: (value) => _validateField(value, 'password'),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleRegister(auth),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: auth.isLoading ? null : () => _handleRegister(auth),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(auth.isLoading ? 'Creating Account...' : 'Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}