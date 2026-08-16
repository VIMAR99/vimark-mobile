import 'package:flutter/material.dart';
import 'api_service.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final pages = const [
    HomePage(),
    EducationPage(),
    ShopPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: pages[index]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (v) => setState(() => index = v),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Page(
        title: 'Bienvenue sur VIMARK',
        subtitle: 'Éducation, commerce et services réunis.',
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIMARK',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text('Construisons votre réussite ensemble.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Accès rapide',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const ActionCard(
            icon: Icons.shopping_bag,
            title: 'Marketplace',
            text: 'Découvrez des produits et services.',
          ),
          const ActionCard(
            icon: Icons.school,
            title: 'Éducation',
            text: 'Apprenez et développez vos compétences.',
          ),
          const ActionCard(
            icon: Icons.star,
            title: 'Premium',
            text: 'Découvrez les avantages VIMARK Premium.',
          ),
        ],
      );
}

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) => const Page(
        title: 'Éducation',
        subtitle: 'Apprenez à votre rythme.',
        children: [
          ActionCard(
            icon: Icons.play_circle_outline,
            title: 'Cours disponibles',
            text: 'Les cours VIMARK apparaîtront ici.',
          ),
          ActionCard(
            icon: Icons.menu_book_outlined,
            title: 'Mes apprentissages',
            text: 'Suivez votre progression.',
          ),
        ],
      );
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) => const Page(
        title: 'Marketplace',
        subtitle: 'Trouvez ce dont vous avez besoin.',
        children: [
          ProductCard(
            name: 'Produit exemple',
            price: '5 000 FCFA',
          ),
          ProductCard(
            name: 'Produit Premium',
            price: '10 000 FCFA',
          ),
        ],
      );
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) => const Page(
        title: 'Mes commandes',
        subtitle: 'Suivez vos achats.',
        children: [
          ActionCard(
            icon: Icons.inventory_2_outlined,
            title: 'Aucune commande pour le moment',
            text: 'Vos commandes apparaîtront ici.',
          ),
        ],
      );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Page(
        title: 'Mon compte',
        subtitle: 'Gérez votre espace VIMARK.',
        children: [
          ActionCard(
            icon: Icons.person_outline,
            title: 'Mon compte',
            text: 'Consultez vos informations personnelles.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AccountPage(),
                ),
              );
            },
          ),
          const ActionCard(
            icon: Icons.star_outline,
            title: 'VIMARK Premium',
            text: 'Gérer votre abonnement.',
          ),
          const ActionCard(
            icon: Icons.storefront,
            title: 'Espace commerçant',
            text: 'Gérer votre boutique et vos commandes.',
          ),
          const ActionCard(
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            text: 'Préférences du compte.',
          ),
        ],
      );
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool loading = true;
  bool saving = false;
  String? error;
  Map<String, dynamic>? user;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await ApiService.getMe();

      if (!mounted) return;

      setState(() {
        user = data;

        nameController.text = data['name']?.toString() ?? '';
        emailController.text = data['email']?.toString() ?? '';
        phoneController.text = data['phone']?.toString() ?? '';

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        loading = false;
      });
    }
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      showMessage('Le nom est requis.');
      return;
    }

    setState(() => saving = true);

    try {
      final data = await ApiService.updateMe(
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
        user = data;
        saving = false;
      });

      showMessage('Profil mis à jour avec succès 🎉');
    } catch (e) {
      if (!mounted) return;

      setState(() => saving = false);

      showMessage(
        e.toString().replaceFirst('Exception: ', ''),
      );
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
        title: const Text('Mon compte'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: loadProfile,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      const CircleAvatar(
                        radius: 45,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      ProfileInfoCard(
                        icon: Icons.badge_outlined,
                        title: 'Rôle',
                        value: user?['role']?.toString() ??
                            'Non renseigné',
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: saving ? null : saveProfile,
                          icon: saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(
                            saving
                                ? 'Enregistrement...'
                                : 'Enregistrer les modifications',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(icon),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(value),
        ),
      );
}

class Page extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const Page({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
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
  Widget build(BuildContext context) => Card(
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
          trailing: const Icon(Icons.chevron_right),
        ),
      );
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: const Icon(
            Icons.shopping_bag_outlined,
            size: 34,
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(price),
          trailing: FilledButton(
            onPressed: () {},
            child: const Text('Voir'),
          ),
        ),
      );
}
