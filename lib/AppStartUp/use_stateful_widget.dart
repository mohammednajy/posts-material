import 'package:flutter/material.dart';

// Define these classes for different app states
abstract class AppStartupState {}

class AppStartupInit extends AppStartupState {}

class AppStartupLoading extends AppStartupState {}

class AppStartupSuccess extends AppStartupState {}

class AppStartupError extends AppStartupState {
  final String errorMessage;
  final VoidCallback onRetry;

  AppStartupError(this.errorMessage, this.onRetry);
}



class AppStartWidget extends StatefulWidget {
  const AppStartWidget({super.key});

  @override
  State<AppStartWidget> createState() => _AppStartupWidgetState();
}

class _AppStartupWidgetState extends State<AppStartWidget> {
  // Initial state is loading
  AppStartupState _state = AppStartupInit();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() {
      _state = AppStartupLoading();
    });
    try {
      // Simulate async initialization, like API calls or DB setup
      await Future.delayed(const Duration(seconds: 2));
      // On success, update the state
      setState(() {
        _state = AppStartupSuccess();
      });
    } catch (e) {
      // On error, update the state to show the error message and retry button
      setState(() {
        _state = AppStartupError(
          'Failed to initialize the app: ${e.toString()}',
          _initializeApp, // Retry function on error
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Map the current state to the corresponding UI
    return switch (_state) {
      AppStartupLoading() => const AppStartupLoadingWidget(),
      AppStartupSuccess() => const MainApp(),
      AppStartupError(errorMessage: var message, onRetry: var retry) =>
        AppStartupErrorWidget(message, retry),
      _ => const SizedBox.shrink(),
    };
  }
}

// Dummy widgets for illustration
class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Main App')),
        body: const Center(child: Text('App Loaded Successfully!')),
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const AppStartupErrorWidget(this.errorMessage, this.onRetry, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const AppStartWidget());
}
