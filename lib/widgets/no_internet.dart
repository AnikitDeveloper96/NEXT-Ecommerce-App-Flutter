import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nextecommerceapp/screens/onboardingscreens/onboarding_screen.dart';

// Separate No Internet Screen Widget
class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isLoading = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        // Internet is back, show snackbar and navigate to OnboardingScreen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Internet Connection is Back',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _retryConnection() async {
    setState(() {
      _isLoading = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    setState(() {
      _isLoading = false;
    });

    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Offline', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
    // No navigation here, just checking and displaying snackbar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/no_internet.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Internet is missing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: _retryConnection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Retry now'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Internet Check Function
Future<bool> checkInternetAndNavigate(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoInternetScreen()),
    );
    return false;
  }
  return true;
}
