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
  Widget build(BuildContext context) {
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

/* =========================
   ACCUEIL
========================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Page(
      title: 'Bienvenue sur VIMARK',
      subtitle: 'Éducation, commerce et services réunis.',
      children: [
        ActionCard(
          icon: Icons.shopping_bag,
          title: 'Marketplace',
          text: 'Découvrez des produits et services.',
        ),
        ActionCard(
          icon: Icons.school,
          title: 'Éducation',
          text: 'Apprenez et développez vos compétences.',
        ),
        ActionCard(
          icon: Icons.star,
          title: 'Premium',
          text: 'Découvrez les avantages VIMARK Premium.',
        ),
      ],
    );
  }
}

/* =========================
   EDUCATION
========================= */

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() =>
      _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  bool loading = true;
  List<dynamic> courses = [];
  String? error;

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
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Page(
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
          ActionCard(
            icon: Icons.error_outline,
            title: 'Erreur',
            text: error!,
          )
        else if (courses.isEmpty)
          const ActionCard(
            icon: Icons.menu_book_outlined,
            title: 'Aucun cours disponible',
            text: 'Les nouveaux cours apparaîtront ici.',
          )
        else
          ...courses.map(
            (course) => CourseCard(
              course: course,
            ),
          ),
      ],
    );
  }
}

/* =========================
   BOUTIQUE
========================= */

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool loading = true;
  List<dynamic> products = [];
  String? error;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final result =
          await ApiService.getProducts();

      if (!mounted) return;

      setState(() {
        products = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      title: 'Marketplace',
      subtitle: 'Trouvez ce dont vous avez besoin.',
      children: [
        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          )
        else if (error != null)
          ActionCard(
            icon: Icons.error_outline,
            title: 'Erreur',
            text: error!,
          )
        else if (products.isEmpty)
          const ActionCard(
            icon: Icons.shopping_bag_outlined,
            title: 'Aucun produit',
            text:
                'Les produits des commerçants apparaîtront ici.',
          )
        else
          ...products.map(
            (product) => MarketplaceProductCard(
              product: product,
            ),
          ),
      ],
    );
  }
}

/* =========================
   COMMANDES
========================= */

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Page(
      title: 'Mes commandes',
      subtitle: 'Suivez vos achats.',
      children: [
        ActionCard(
          icon: Icons.inventory_2_outlined,
          title: 'Aucune commande pour le moment',
          text:
              'Vos commandes apparaîtront ici.',
        ),
      ],
    );
  }
}

/* =========================
   PROFIL
========================= */

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = true;

  String name = 'Utilisateur VIMARK';
  String email = 'Votre adresse email';
  String phone = 'Non renseigné';
  String role = 'student';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final user =
          await ApiService.getMe();

      if (!mounted) return;

      setState(() {
        name = user['name'] ?? name;
        email = user['email'] ?? email;
        phone = user['phone'] ?? phone;
        role = user['role'] ?? role;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Page(
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

                if (loading)
                  const CircularProgressIndicator()
                else ...[
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(email),
                  const SizedBox(height: 4),
                  Text(phone),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        ActionCard(
          icon: Icons.edit_outlined,
          title: 'Modifier mon profil',
          text:
              'Modifiez votre nom, email ou téléphone.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    EditProfilePage(
                  name: name,
                  email: email,
                  phone: phone,
                ),
              ),
            ).then((_) {
              loadProfile();
            });
          },
        ),

        ActionCard(
          icon: Icons.badge_outlined,
          title: 'Rôle',
          text: role,
        ),

        ActionCard(
          icon: Icons.star_outline,
          title: 'VIMARK Premium',
          text: 'Gérez votre abonnement.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    const PremiumPage(),
              ),
            );
          },
        ),

        ActionCard(
          icon: Icons.storefront,
          title: 'Espace commerçant',
          text:
              'Gérez votre boutique et vos produits.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    const MerchantPage(),
              ),
            );
          },
        ),

        const ActionCard(
          icon: Icons.settings_outlined,
          title: 'Paramètres',
          text: 'Préférences du compte.',
        ),
      ],
    );
  }
}

/* =========================
   EDIT PROFILE
========================= */

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(
      text: widget.name,
    );

    emailController =
        TextEditingController(
      text: widget.email ==
              'Votre adresse email'
          ? ''
          : widget.email,
    );

    phoneController =
        TextEditingController(
      text: widget.phone ==
              'Non renseigné'
          ? ''
          : widget.phone,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty) {
      showMessage('Le nom est requis.');
      return;
    }

    setState(() {
      saving = true;
    });

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

      if (!mounted) return;

      showMessage(
        'Profil mis à jour avec succès',
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      showMessage(
        e.toString()
            .replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modifier mon profil',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nom',
              border: OutlineInputBorder(),
              prefixIcon:
                  Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: emailController,
            keyboardType:
                TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon:
                  Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            keyboardType:
                TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Téléphone',
              border: OutlineInputBorder(),
              prefixIcon:
                  Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: saving ? null : save,
            child: saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Enregistrer',
                  ),
          ),
        ],
      ),
    );
  }
}

/* =========================
   MERCHANT PAGE
========================= */

class MerchantPage extends StatefulWidget {
  const MerchantPage({super.key});

  @override
  State<MerchantPage> createState() =>
      _MerchantPageState();
}

class _MerchantPageState
    extends State<MerchantPage> {
  bool loading = true;
  bool creating = false;

  Map<String, dynamic>? business;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    loadMerchantData();
  }

  Future<void> loadMerchantData() async {
    try {
      final result =
          await ApiService.getMyBusiness();

      final productResult =
          await ApiService.getMyProducts();

      if (!mounted) return;

      setState(() {
        business = result;
        products = productResult;
        loading = false;
      });
    } catch (e) {
      try {
        final productResult =
            await ApiService.getMyProducts();

        if (!mounted) return;

        setState(() {
          products = productResult;
          loading = false;
        });
      } catch (_) {
        if (!mounted) return;

        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> createBusiness() async {
    final nameController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

    final locationController =
        TextEditingController();

    final result =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Créer ma boutique',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Nom de la boutique',
                  ),
                ),
                TextField(
                  controller:
                      descriptionController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Description',
                  ),
                ),
                TextField(
                  controller:
                      locationController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Localisation',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),
              child:
                  const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController
                    .text
                    .trim()
                    .isEmpty) {
                  return;
                }

                setState(() {
                  creating = true;
                });

                try {
                  await ApiService
                      .createBusiness(
                    name:
                        nameController.text
                            .trim(),
                    description:
                        descriptionController
                            .text
                            .trim(),
                    location:
                        locationController
                            .text
                            .trim(),
                  );

                  if (!mounted) return;

                  Navigator.pop(
                    context,
                    true,
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString()
                            .replaceFirst(
                          'Exception: ',
                          '',
                        ),
                      ),
                    ),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      creating = false;
                    });
                  }
                }
              },
              child: creating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Créer',
                    ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      loadMerchantData();
    }

    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
  }

  Future<void> addProduct() async {
    if (business == null) {
      return;
    }

    final nameController =
        TextEditingController();

    final priceController =
        TextEditingController();

    final stockController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

        final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Ajouter un produit',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du produit',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Prix en FCFA',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
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
            FilledButton(
              onPressed: () async {
                final price = int.tryParse(
                  priceController.text.trim(),
                );

                final stock = int.tryParse(
                      stockController.text.trim(),
                    ) ??
                    0;

                if (nameController.text.trim().isEmpty ||
                    price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Nom et prix sont requis.',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await ApiService.createProduct(
                    businessId: business!['id'],
                    name: nameController.text.trim(),
                    description:
                        descriptionController.text.trim(),
                    price: price,
                    stock: stock,
                  );

                  if (!mounted) return;

                  Navigator.pop(context, true);
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
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await loadMerchantData();
    }

    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
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
              onRefresh: loadMerchantData,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (business == null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.storefront,
                              size: 60,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Vous n’avez pas encore de boutique.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
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
/* =========================
   PREMIUM
========================= */

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  Future<void> subscribe(BuildContext context) async {
    try {
      final result = await ApiService.createSubscription();

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('VIMARK Premium'),
          content: Text(
            result['message'] ??
                'Abonnement activé.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

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
        title: const Text('VIMARK Premium'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.star,
            size: 80,
          ),
          const SizedBox(height: 20),
          const Text(
            'VIMARK Premium',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Profitez des avantages Premium VIMARK.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          FilledButton(
            onPressed: () {
              subscribe(context);
            },
            child: const Text(
              'Activer Premium — 1 500 FCFA',
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================
   CARDS
========================= */

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

class MarketplaceProductCard extends StatelessWidget {
  final dynamic product;

  const MarketplaceProductCard({
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
          '${product['price'] ?? 0} FCFA',
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
          '${product['price'] ?? 0} FCFA • Stock: ${product['stock'] ?? 0}',
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
          ),
          onPressed: onDelete,
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
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
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
         
