import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nextecommerceapp/screens/db_firestore/ecommerce_db_firestore.dart';
import 'package:nextecommerceapp/widgets/firestore_widget.dart';
import '../../routes.dart';
import '../authentication/authentication.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isSigningIn = false;

  Future<void> _signInWithGoogleAndCheckInternet(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) { // Check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offline', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return; // Stop if there's no internet
    }

    if (mounted) { // Check if the widget is still mounted
      setState(() {
        _isSigningIn = true;
      });
    }

    try {
      User? user = await Authentication.signInWithGoogle(context: context);

      if (mounted) { // Check if the widget is still mounted
        setState(() {
          _isSigningIn = false;
        });
      }

      if (user != null) {
        await NextEcommerceDatabase().createUserCollection(user);
        if (mounted) { // Check if the widget is still mounted
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Successfully signed in with Google!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.black,
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            NextEcommerceAppRoutes.mainhomepage,
                (route) => false,
            arguments: user, // Passing the user
          );
        }
      }
    } catch (e) {
      if (mounted) { // Check if the widget is still mounted
        setState(() {
          _isSigningIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing in: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/onboardingscreen');
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1591085686350-798c0f9faa7f?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 150.0, left: 50),
                  child: Text(
                    'Your \n NEXT \n ecommerce \n app ',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _signInWithGoogleAndCheckInternet(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Sign in with    ',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/google_logo.png',
                                  height: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isSigningIn)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';
  bool _obscureText = true;
  bool _isSigningUp = false;

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        _isSigningUp = true;
      });
    }

    try {
      await Authentication.signUpWithEmail(
        email: _email,
        password: _password,
        context: context,
      );
      // The Authentication.signUpWithEmail method likely handles navigation,
      // but if you have any setState calls after it, wrap them in `if (mounted)`.
    } catch (e) {
      if (mounted) { // Check if the widget is still mounted
        setState(() {
          _isSigningUp = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(content: 'Sign up failed: $e'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Create your new account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _fullName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 20),
              _isSigningUp
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _signUpWithEmail,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}