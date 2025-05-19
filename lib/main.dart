import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextecommerceapp/screens/authentication/authentication.dart';
import 'package:nextecommerceapp/screens/onboardingscreens/onboarding_screen.dart';
import 'package:nextecommerceapp/widgets/no_internet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'blocs/bloc_event/product_homepage.dart';
import 'blocs/blocs/bloc_homepage.dart';
import 'blocs/blocs/cart_bloc.dart';
import 'blocs/blocs/fav_bloc.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult); // No cast needed

    Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result); // No cast needed
    });
  }

  void _updateConnectionStatus(dynamic result) {
    if (result is ConnectivityResult) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    } else if (result is List<ConnectivityResult>) {
      // If you ever get a list, check if any is connected
      bool anyConnected = result.any((r) => r != ConnectivityResult.none);
      setState(() {
        _isConnected = anyConnected;
      });
    } else {
      // Unexpected type, just log it (optional)
      print('Unexpected type passed to _updateConnectionStatus: ${result.runtimeType}');
      setState(() {
        _isConnected = false; // or default to offline
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) {
            final productBloc = ProductBloc();
            productBloc.add(FetchProducts());
            return productBloc;
          },
        ),
        BlocProvider<FavoriteProductBloc>(
          create: (_) => FavoriteProductBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: NextEcommerceAppRoutes.onboarding,
        routes: NextEcommerceAppRoutes.routes,
        home: Builder(
          builder: (context) {
            User? user = FirebaseAuth.instance.currentUser;
            return _isConnected ? OnboardingScreen() : const NoInternetScreen();
          },
        ),
      ),
    );
  }
}
