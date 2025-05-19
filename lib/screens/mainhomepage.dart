import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import fav bloc
import 'package:nextecommerceapp/screens/authentication/authentication.dart';
import 'package:nextecommerceapp/screens/homepage/favourite_screen.dart';
import 'package:nextecommerceapp/screens/homepage/homepage.dart';
import 'package:nextecommerceapp/screens/onboardingscreens/onboarding_screen.dart';
import 'homepage/search_screen.dart';

class MainHomePage extends StatefulWidget {
  final User? user;

  const MainHomePage({super.key, this.user});

  @override
  State<MainHomePage> createState() => _MainHomepageState();
}

class _MainHomepageState extends State<MainHomePage> {
  int _currentIndex = 0;

  Future<void> _signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb && await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(content: 'Signed out successfully.'),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error signing out. Try again.',
          ),
        );
      }
    }
  }

  void _showSignOutBottomSheet(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align content to the start
              children: [
                if (user?.photoURL != null)
                  Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL!),
                      radius: 30,
                    ),
                  )
                else
                  const Center(
                    child: CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person_rounded),
                    ),
                  ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    user?.displayName ?? "Guest User",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (user?.email != null)
                  Center(
                    child: Text(
                      user!.email!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _signOut(context);
                  },
                ),
                const Divider(thickness: 1),
                ListTile(
                  leading: const Icon(Icons.cancel_rounded, color: Colors.grey),
                  title: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      MyHomePage(user: widget.user),
      SearchFilterPage(onThemeToggle: (_) {}), // Use SearchFilterPage
      const FavoritesScreen(),
      const Center(
        child: Text(
          "Cart",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
    ];

    final List<String> _pageTitles = ["Home", "Search", "Favorites", "Cart"];
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, size: 26.0),
          onPressed: () => Scaffold.of(context).openDrawer(),
          color: theme.iconTheme.color, // Use theme's icon color
        ),
        title: Text(
          _pageTitles[_currentIndex],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ), // Use theme's text style
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            theme.appBarTheme.backgroundColor, // Use theme's background color
        foregroundColor:
            theme.textTheme.bodyLarge?.color, // Use theme's foreground color
        actions: [
          if (widget.user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () => _showSignOutBottomSheet(context),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      widget.user?.photoURL != null
                          ? NetworkImage(widget.user!.photoURL!)
                          : null,
                  child:
                      widget.user?.photoURL == null
                          ? const Icon(Icons.person_rounded)
                          : null,
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: theme.primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (widget.user?.photoURL != null)
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.user!.photoURL!),
                      onBackgroundImageError:
                          (exception, stackTrace) => const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person_rounded),
                          ),
                    )
                  else
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person_rounded),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    widget.user?.displayName ?? "Guest",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.user?.email ?? "example@email.com",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_rounded),
              title: const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to about screen
              },
            ),
            if (widget.user != null)
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSignOutBottomSheet(context);
                },
              ),
            // Add more drawer items
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 250,
        ), // Slightly faster animation
        child: _pages[_currentIndex],
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          ); // Add a subtle fade transition
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          // Use Material for inkwell effect and background
          elevation: 4.0,
          borderRadius: BorderRadius.circular(24.0),
          color:
              theme
                  .bottomNavigationBarTheme
                  .backgroundColor, // Use theme's color
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                theme.colorScheme.secondary, // Use secondary color for emphasis
            unselectedItemColor: theme.textTheme.bodyMedium?.color?.withOpacity(
              0.6,
            ),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded),
                label: "Favorites",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_rounded),
                label: "Cart",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
