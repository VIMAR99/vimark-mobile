import 'package:flutter/material.dart';
import 'api_service.dart';
import 'home_shell.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool loading = false;
  
  @override
void initState() {
  super.initState();
  checkSession();
}

Future<void> checkSession() async {
  final token = await ApiService.getToken();

  if (!mounted) return;

  if (token != null && token.isNotEmpty) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomeShell(),
      ),
    );
  }
}

  final nameController = TextEditingController();
  final identifierController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    identifierController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (identifierController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      showMessage('Veuillez remplir les champs requis.');
      return;
    }

    if (!isLogin && nameController.text.trim().isEmpty) {
      showMessage('Veuillez entrer votre nom.');
      return;
    }

    setState(() => loading = true);

    try {
      Map<String, dynamic> result;

      if (isLogin) {
        result = await ApiService.login(
          identifier: identifierController.text.trim(),
          password: passwordController.text,
        );
      } else {
        result = await ApiService.register(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          email: identifierController.text.trim(),
          password: passwordController.text,
        );
      }

      if (!mounted) return;

      showMessage(
        isLogin
            ? 'Connexion réussie 🎉'
            : 'Compte créé avec succès 🎉',
      );

      Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (_) => const HomeShell(),
  ),
);
    } catch (e) {
      if (!mounted) return;

      showMessage(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIMARK'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),

              const Icon(
                Icons.rocket_launch,
                size: 70,
              ),

              const SizedBox(height: 20),

              Text(
                isLogin ? 'Bienvenue sur VIMARK' : 'Créer un compte',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                isLogin
                    ? 'Connectez-vous à votre espace VIMARK.'
                    : 'Rejoignez l’écosystème VIMARK.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              if (!isLogin)
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),

              if (!isLogin) const SizedBox(height: 16),

              TextField(
                controller: identifierController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              
              TextField(
                  controller: phoneController,
                    keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Téléphone',
                              prefixIcon: Icon(Icons.phone_outlined),
                                ),
                                ),
              )

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              FilledButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isLogin ? 'Se connecter' : 'Créer mon compte',
                      ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: loading
                    ? null
                    : () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                child: Text(
                  isLogin
                      ? 'Je n’ai pas encore de compte'
                      : 'J’ai déjà un compte',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
