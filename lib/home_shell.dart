import 'package:flutter/material.dart';
import 'api_service.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const EducationPage(),
      const ShopPage(),
      const OrdersPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
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
            label: 'Éducation',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Boutique',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Commandes',
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

/* =========================================================
   ACCUEIL
========================================================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Bienvenue sur VIMARK',
      subtitle: 'Éducation, commerce et services réunis.',
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VIMARK',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Construisons votre réussite ensemble.',
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.rocket_launch),
                  label: const Text('Découvrir VIMARK'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle(title: 'Accès rapide'),
        ActionCard(
          icon: Icons.school,
          title: 'Éducation',
          text: 'Découvrez les cours disponibles.',
          onTap: () {},
        ),
        ActionCard(
          icon: Icons.storefront,
          title: 'Marketplace',
          text: 'Découvrez les produits disponibles.',
          onTap: () {},
        ),
        ActionCard(
          icon: Icons.star,
          title: 'VIMARK Premium',
          text: 'Découvrez les avantages Premium.',
          onTap: () {},
        ),
      ],
    );
  }
}

/* =========================================================
   EDUCATION
========================================================= */

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  bool loading = true;
  String? error;
  List<dynamic> courses = [];

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    setState(() {
      loading = true;
      error = null;
    });

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
        error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Éducation',
      subtitle: 'Apprenez à votre rythme.',
      children: [
        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          )
        else if (error != null)
          ErrorCard(
            message: error!,
            onRetry: loadCourses,
          )
        else if (courses.isEmpty)
          const ActionCard(
            icon: Icons.menu_book_outlined,
            title: 'Aucun cours disponible',
            text: 'Les nouveaux cours apparaîtront ici.',
          )
        else
          ...courses.map(
            (course) => CourseCard(course: course),
          ),
      ],
    );
  }
}

/* =========================================================
   BOUTIQUE
========================================================= */

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool loading = true;
  String? error;
  List<dynamic> products = [];

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final result = await ApiService.getProducts(
        search: searchController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        products = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Marketplace',
      subtitle: 'Trouvez ce dont vous avez besoin.',
      children: [
        TextField(
          controller: searchController,
          onSubmitted: (_) => loadProducts(),
          decoration: InputDecoration(
            labelText: 'Rechercher un produit',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: loadProducts,
              icon: const Icon(Icons.arrow_forward),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          )
        else if (error != null)
          ErrorCard(
            message: error!,
            onRetry: loadProducts,
          )
        else if (products.isEmpty)
          const ActionCard(
            icon: Icons.shopping_bag_outlined,
            title: 'Aucun produit',
            text: 'Les produits disponibles apparaîtront ici.',
          )
        else
          ...products.map(
            (product) => ProductCard(product: product),
          ),
      ],
    );
  }
}

/* =========================================================
   COMMANDES
========================================================= */

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(
      title: 'Mes commandes',
      subtitle: 'Suivez vos achats.',
      children: [
        ActionCard(
          icon: Icons.inventory_2_outlined,
          title: 'Aucune commande',
          text: 'Vos commandes apparaîtront ici.',
        ),
      ],
    );
  }
}

/* =========================================================
   PROFIL
========================================================= */

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = true;
  String? error;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      loading = true;
      error = null;
    });

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
        error = e.toString().replaceFirst('Exception: ', '');
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
      builder: (dialogContext) {
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
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  await ApiService.updateMe(
                    name: nameController.text.trim(),
                    email: emailController.text.trim().isEmpty
                        ? null
                        : emailController.text.trim(),
                    phone: phoneController.text.trim().isEmpty
                        ? null
                        : phoneController.text.trim(),
                  );

                  if (!dialogContext.mounted) return;

                  Navigator.pop(dialogContext, true);
                } catch (e) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst(
                              'Exception: ',
                              '',
                            ),
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

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis à jour avec succès 🎉'),
        ),
      );
    }
  }

  Future<void> openMerchantSpace() async {
    if (user == null) return;

    if (user!['role'] != 'merchant') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Votre compte doit avoir le rôle commerçant.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MerchantPage(),
      ),
    );
  }

  Future<void> openPremium() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PremiumPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return AppPage(
        title: 'Mon compte',
        subtitle: 'Gérez votre espace VIMARK.',
        children: [
          ErrorCard(
            message: error!,
            onRetry: loadProfile,
          ),
        ],
      );
    }

    final currentUser = user ?? {};

    return AppPage(
      title: 'Mon compte',
      subtitle: 'Gérez votre espace VIMARK.',
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Icons.person,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  currentUser['name'] ?? 'Utilisateur VIMARK',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ProfileInfo(
                  label: 'Nom',
                  value: currentUser['name'] ?? 'Non renseigné',
                ),
                ProfileInfo(
                  label: 'Email',
                  value: currentUser['email'] ?? 'Non renseigné',
                ),
                ProfileInfo(
                  label: 'Téléphone',
                  value: currentUser['phone'] ?? 'Non renseigné',
                ),
                ProfileInfo(
                  label: 'Rôle',
                  value: currentUser['role'] ?? 'student',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: editProfile,
                    icon: const Icon(Icons.edit),
                    label: const Text('Modifier mon profil'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ActionCard(
          icon: Icons.star_outline,
          title: 'VIMARK Premium',
          text: 'Gérez votre abonnement.',
          onTap: openPremium,
        ),
        ActionCard(
          icon: Icons.storefront,
          title: 'Espace commerçant',
          text: 'Gérez votre boutique et vos produits.',
          onTap: openMerchantSpace,
        ),
        ActionCard(
          icon: Icons.settings_outlined,
          title: 'Paramètres',
          text: 'Préférences du compte.',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Les paramètres seront disponibles prochainement.',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/* =========================================================
   ESPACE COMMERÇANT
========================================================= */

class MerchantPage extends StatefulWidget {
  const MerchantPage({super.key});

  @override
  State<MerchantPage> createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  bool loading = true;
  Map<String, dynamic>? business;
  List<dynamic> products = [];
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      Map<String, dynamic>? store;
      List<dynamic> myProducts = [];

      try {
        store = await ApiService.getMyBusiness();
      } catch (_) {
        store = null;
      }

      try {
        myProducts = await ApiService.getMyProducts();
      } catch (_) {
        myProducts = [];
      }

      if (!mounted) return;

      setState(() {
        business = store;
        products = myProducts;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> createBusiness() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Créer ma boutique'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la boutique',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Localisation',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  return;
                }

                try {
                  await ApiService.createBusiness(
                    name: nameController.text.trim(),
                    description:
                        descriptionController.text.trim(),
                    location:
                        locationController.text.trim(),
                  );

                  if (!dialogContext.mounted) return;

                  Navigator.pop(dialogContext, true);
                } catch (e) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst(
                              'Exception: ',
                              '',
                            ),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();

    if (result == true) {
      await loadData();
    }
  }

  Future<void> deleteProduct(int productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer le produit ?'),
          content: const Text(
            'Cette action est irréversible.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ApiService.deleteProduct(
        productId: productId,
      );

      await loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produit supprimé.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace commerçant'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (error != null)
                    ErrorCard(
                      message: error!,
                      onRetry: loadData,
                    )
                  else if (business == null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.storefront,
                              size: 70,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Votre boutique',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Créez votre boutique VIMARK pour commencer à vendre.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: createBusiness,
                              icon: const Icon(
                                Icons.add_business,
                              ),
                              label: const Text(
                                'Créer ma boutique',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.storefront,
                              size: 45,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              business!['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              business!['description'] ?? '',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              business!['location'] ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mes produits',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: addProduct,
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (products.isEmpty)
                      const ActionCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'Aucun produit',
                        text:
                            'Ajoutez votre premier produit.',
                      )
                    else
                      ...products.map(
                        (product) => MerchantProductCard(
                          product: product,
                          onDelete: () {
                            deleteProduct(product['id']);
                          },
                        ),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}

/* =========================================================
   PREMIUM
========================================================= */

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  bool loading = false;

  Future<void> subscribe() async {
    setState(() {
      loading = true;
    });

    try {
      final result = await ApiService.createSubscription();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('VIMARK Premium'),
            content: Text(
              result['message'] ??
                  'Abonnement activé avec succès.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIMARK Premium'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(
            Icons.star,
            size: 90,
          ),
          const SizedBox(height: 20),
          const Text(
            'VIMARK Premium',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Profitez des avantages Premium VIMARK.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Premium',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1 500 FCFA / mois',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: loading ? null : subscribe,
                      child: loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Activer Premium',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   WIDGETS
========================================================= */

class AppPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const AppPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback? onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(text),
        trailing: onTap != null
            ? const Icon(Icons.chevron_right)
            : null,
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final dynamic course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.school),
        ),
        title: Text(
          course['title'] ?? 'Cours',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${course['subject'] ?? ''} • ${course['level'] ?? ''}',
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(
          Icons.shopping_bag_outlined,
          size: 34,
        ),
        title: Text(
          product['name'] ?? 'Produit',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${product['price'] ?? 0} FCFA'
          ' • ${product['business_name'] ?? ''}',
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}

class MerchantProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onDelete;

  const MerchantProductCard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(
          Icons.inventory_2_outlined,
        ),
        title: Text(
          product['name'] ?? 'Produit',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${product['price'] ?? 0} FCFA'
          ' • Stock: ${product['stock'] ?? 0}',
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_outline,
          ),
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfo({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
