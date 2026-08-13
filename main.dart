import 'package:flutter/material.dart';

void main() => runApp(const VimarkApp());

class VimarkApp extends StatelessWidget {
  const VimarkApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'VIMARK',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087F5B))),
    home: const HomeShell(),
  );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int index=0;
  final pages=const [HomePage(), EducationPage(), ShopPage(), OrdersPage(), ProfilePage()];
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: pages[index]),
    bottomNavigationBar: NavigationBar(
      selectedIndex:index,
      onDestinationSelected:(v)=>setState(()=>index=v),
      destinations:const [
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Accueil'),
        NavigationDestination(icon:Icon(Icons.school_outlined),selectedIcon:Icon(Icons.school),label:'Éducation'),
        NavigationDestination(icon:Icon(Icons.storefront_outlined),selectedIcon:Icon(Icons.storefront),label:'Boutique'),
        NavigationDestination(icon:Icon(Icons.receipt_long_outlined),selectedIcon:Icon(Icons.receipt_long),label:'Commandes'),
        NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profil'),
      ],
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context)=>Page(title:'Bienvenue sur VIMARK',subtitle:'Éducation, commerce et services réunis.',children:[
    Card(child:Padding(padding:const EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('VIMARK',style:Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight:FontWeight.w800)),
      const SizedBox(height:8),const Text('Construisons votre réussite ensemble.')
    ]))),
    const SizedBox(height:18), const Text('Accès rapide',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    const ActionCard(icon:Icons.shopping_bag,title:'Marketplace',text:'Découvrez des produits et services.'),
    const ActionCard(icon:Icons.school,title:'Éducation',text:'Apprenez et développez vos compétences.'),
    const ActionCard(icon:Icons.star,title:'Premium',text:'Découvrez les avantages VIMARK Premium.'),
  ]);
}
class EducationPage extends StatelessWidget {
  const EducationPage({super.key});
  @override Widget build(BuildContext context)=>const Page(title:'Éducation',subtitle:'Apprenez à votre rythme.',children:[
    ActionCard(icon:Icons.play_circle_outline,title:'Cours disponibles',text:'Les cours VIMARK apparaîtront ici.'),
    ActionCard(icon:Icons.menu_book_outlined,title:'Mes apprentissages',text:'Suivez votre progression.'),
  ]);
}
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});
  @override Widget build(BuildContext context)=>const Page(title:'Marketplace',subtitle:'Trouvez ce dont vous avez besoin.',children:[
    ProductCard(name:'Produit exemple',price:'5 000 FCFA'),
    ProductCard(name:'Produit Premium',price:'10 000 FCFA'),
  ]);
}
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override Widget build(BuildContext context)=>const Page(title:'Mes commandes',subtitle:'Suivez vos achats.',children:[
    ActionCard(icon:Icons.inventory_2_outlined,title:'Aucune commande pour le moment',text:'Vos commandes apparaîtront ici.'),
  ]);
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext context)=>const Page(title:'Mon compte',subtitle:'Gérez votre espace VIMARK.',children:[
    ActionCard(icon:Icons.star_outline,title:'VIMARK Premium',text:'Gérer votre abonnement.'),
    ActionCard(icon:Icons.storefront,title:'Espace commerçant',text:'Gérer votre boutique et vos commandes.'),
    ActionCard(icon:Icons.settings_outlined,title:'Paramètres',text:'Préférences du compte.'),
  ]);
}

class Page extends StatelessWidget {
  final String title,subtitle; final List<Widget> children;
  const Page({super.key,required this.title,required this.subtitle,required this.children});
  @override Widget build(BuildContext context)=>SingleChildScrollView(
    padding:const EdgeInsets.all(20),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(title,style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
      const SizedBox(height:6),Text(subtitle,style:Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height:24),...children
    ]));
}
class ActionCard extends StatelessWidget {
  final IconData icon; final String title,text;
  const ActionCard({super.key,required this.icon,required this.title,required this.text});
  @override Widget build(BuildContext context)=>Card(margin:const EdgeInsets.only(bottom:12),child:ListTile(
    leading:CircleAvatar(child:Icon(icon)),title:Text(title,style:const TextStyle(fontWeight:FontWeight.bold)),
    subtitle:Text(text),trailing:const Icon(Icons.chevron_right)));
}
class ProductCard extends StatelessWidget {
  final String name,price;
  const ProductCard({super.key,required this.name,required this.price});
  @override Widget build(BuildContext context)=>Card(margin:const EdgeInsets.only(bottom:12),child:ListTile(
    leading:const Icon(Icons.shopping_bag_outlined,size:34),title:Text(name,style:const TextStyle(fontWeight:FontWeight.bold)),
    subtitle:Text(price),trailing:FilledButton(onPressed:(){},child:const Text('Voir'))));
}
