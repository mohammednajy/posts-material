import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  // Setup disposal logic
  ref.onDispose(() {
    // invalidate used reinitialize the provider without waiting for a new value.
    // Ensure the provider is invalidated to refresh its value when needed
    ref.invalidate(sharedPreferencesProvider);
  });

  // Await for all initialization code to be complete before returning
  await ref.watch(sharedPreferencesProvider.future);
});

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return await SharedPreferences.getInstance();
});

class AppStartUp extends ConsumerWidget {
  const AppStartUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupAsyncValue = ref.watch(appStartupProvider);

    return appStartupAsyncValue.when(
      data: (_) => const MainApp(),
      loading: () => const LoadingStartupWidget(),
      error: (err, stack) => ErrorStartupWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(appStartupProvider)),
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

class LoadingStartupWidget extends StatelessWidget {
  const LoadingStartupWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class ErrorStartupWidget extends StatelessWidget {
  const ErrorStartupWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $message'),
            ElevatedButton(
                onPressed: () {
                  onRetry();
                },
                child: const Text('retrty'))
          ],
        ),
      ),
    );
  }
}

void main() async {
  runApp(const ProviderScope(child: AppStartUp()));
}
