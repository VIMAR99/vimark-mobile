import 'package:flutter/material.dart';
import 'api_service.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    CoursesPage(),
    ProductsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
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
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIMARK'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur VIMARK',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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

  Future<void> editProfile() async {
    if (user == null) return;

    final nameController = TextEditingController(
      text: user!['name'] ?? '',
    );

    final emailController = TextEditingController(
      text: user!['email'] ?? '',
    );

    final phoneController = TextEditingController(
      text: user!['phone'] ?? '',
    );

    final result = await showDialog<bool>(
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
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 12),
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
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final updated =
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

                  setState(() {
                    user = updated;
                  });

                  Navigator.pop(context, true);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Profil mis à jour avec succès',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erreur : $e',
                      ),
                    ),
                  );
                }
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

    if (result == true) {
      await loadProfile();
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
                    child: const Text(
                      'Réessayer',
                    ),
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
                      _profileItem(
                        'Nom',
                        user!['name'] ?? 'Non renseigné',
                      ),
                      _profileItem(
                        'Email',
                        user!['email'] ?? 'Non renseigné',
                      ),
                      _profileItem(
                        'Téléphone',
                        user!['phone'] ?? 'Non renseigné',
                      ),
                      _profileItem(
                        'Rôle',
                        user!['role'] ?? 'student',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: editProfile,
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          'Modifier mon profil',
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _profileItem(
    String label,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
