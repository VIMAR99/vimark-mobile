import 'package:flutter/material.dart';
import 'api_service.dart';
import 'auth_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
  HomePage(
    onNavigate: (index) {
      setState(() {
        currentIndex = index;
      });
    },
  ),
  const CoursesPage(),
  const ProductsPage(),
  const ProfilePage(),
];
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Boutique',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(int) onNavigate;

  const HomePage({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIMARK'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue sur VIMARK 👋',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Découvrez nos services et profitez de votre espace VIMARK.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 28),

            Card(
  child: ListTile(
    onTap: () => onNavigate(2),
    leading: const CircleAvatar(
      child: Icon(Icons.storefront),
    ),
    title: const Text(
      'Marketplace',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: const Text(
      'Découvrez les produits disponibles.',
    ),
    trailing: const Icon(Icons.chevron_right),
  ),
),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
              onTap: () => onNavigate(1), 
                leading: const CircleAvatar(
                  child: Icon(Icons.school),
                ),
                title: const Text(
                  'Éducation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Accédez aux cours disponibles.',
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
  child: ListTile(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PremiumPage(),
        ),
      );
    },
    leading: const CircleAvatar(
      child: Icon(Icons.star),
    ),
    title: const Text(
      'VIMARK Premium',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: const Text(
      'Découvrez les avantages Premium.',
    ),
    trailing: const Icon(Icons.chevron_right),
  ),
),
          ],
        ),
      ),
    );
  }
}
  class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool loading = true;
  List<dynamic> courses = [];

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    try {
      final result = await ApiService.getCourses();

      if (!mounted) return;

      setState(() {
        courses = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cours'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : courses.isEmpty
              ? const Center(
                  child: Text('Aucun cours disponible'),
                )
              : RefreshIndicator(
                  onRefresh: loadCourses,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.school),
                          ),
                          title: Text(
                            course['title'] ?? 'Cours',
                          ),
                          subtitle: Text(
                            '${course['subject'] ?? ''} • ${course['level'] ?? ''}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool loading = true;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final result = await ApiService.getProducts();

      if (!mounted) return;

      setState(() {
        products = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique VIMARK'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : products.isEmpty
              ? const Center(
                  child: Text('Aucun produit disponible'),
                )
              : RefreshIndicator(
                  onRefresh: loadProducts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.shopping_bag,
                            ),
                          ),
                          title: Text(
                            product['name'] ?? 'Produit',
                          ),
                          subtitle: Text(
                            product['description'] ?? '',
                          ),
                          trailing: Text(
                            '${product['price'] ?? 0} FCFA',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  bool loading = true;
  Map<String, dynamic>? user;
  Future<void> editProfile() async {
    final nameController = TextEditingController(
      text: user?['name'] ?? '',
    );

    final emailController = TextEditingController(
      text: user?['email'] ?? '',
    );

    final phoneController = TextEditingController(
      text: user?['phone'] ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier mon profil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ApiService.updateMe(
                  name: nameController.text.trim(),
                  email: emailController.text.trim().isEmpty
                      ? null
                      : emailController.text.trim(),
                  phone: phoneController.text.trim().isEmpty
                      ? null
                      : phoneController.text.trim(),
                );

                if (!mounted) return;

                Navigator.pop(context);
                await loadProfile();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final result = await ApiService.getMe();

      if (!mounted) return;

      setState(() {
        user = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : user == null
              ? Center(
                  child: ElevatedButton(
                    onPressed: loadProfile,
                    child: const Text('Réessayer'),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadProfile,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: ListTile(
                          title: const Text('Nom'),
                          subtitle: Text(
                            user!['name'] ?? 'Non renseigné',
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Email'),
                          subtitle: Text(
                            user!['email'] ?? 'Non renseigné',
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Téléphone'),
                          subtitle: Text(
                            user!['phone'] ?? 'Non renseigné',
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Rôle'),
                          subtitle: Text(
                            user!['role'] ?? 'student',
                          ),
                        ),
                      ),
                          const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: editProfile,
                        icon: const Icon(Icons.edit),
                        label: const Text('Modifier mon profil'),
                      ),
                      const SizedBox(height: 12),

OutlinedButton.icon(
  onPressed: () async {
    await ApiService.clearToken();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => AuthPage(),
      ),
      (route) => false,
    );
  },
  icon: const Icon(Icons.logout),
  label: const Text('Déconnexion'),
),
                    ],
                  ),
                ),
    );
  }
}
class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIMARK Premium'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.star,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'VIMARK Premium ⭐',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Profitez de tous les avantages VIMARK Premium.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Accès aux contenus Premium'),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Expérience sans publicité'),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Avantages exclusifs'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              '1 500 FCFA / mois',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () async {
      try {
class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIMARK Premium'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.star,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'VIMARK Premium ⭐',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Profitez de tous les avantages VIMARK Premium.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Accès aux contenus Premium'),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Expérience sans publicité'),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Avantages exclusifs'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              '1 500 FCFA / mois',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await ApiService.createSubscription();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Félicitations ! Votre abonnement Premium est activé.',
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur : $e'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.star),
                label: const Text('Devenir Premium'),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () async {
                try {
                  final result =
                      await ApiService.createFedaPayPayment();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Transaction FedaPay créée avec succès 🟢',
                      ),
                    ),
                  );

                  debugPrint('FEDAPAY RESULT: $result');
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur FedaPay : $e'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.payment),
              label: const Text('Tester FedaPay'),
            ),
          ],
        ),
      ),
    );
  }
}
