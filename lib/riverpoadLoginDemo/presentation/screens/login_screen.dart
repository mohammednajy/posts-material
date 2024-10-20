import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkedin_post_material/riverpoadLoginDemo/domain/providers/auth_provider.dart';
import 'package:linkedin_post_material/riverpoadLoginDemo/presentation/widgets/loading.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (prev, next) {
      next.when(data: (data) {
        // first close the loading
        Navigator.pop(context);
        // navigate to the next page
        print(data.toString());
      }, error: (error, _) {
        //first close the loading
        Navigator.pop(context);
        // show the loading in toast or snackbar popup
        print(error.toString());
      }, loading: () {
        // show loading popup
        loadingWithText(context);
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('login screen demo'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: email,
            decoration: const InputDecoration(label: Text('email')),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: password,
            decoration: const InputDecoration(label: Text('password')),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                // add validation before call the login function
                ref
                    .read(loginProvider.notifier)
                    .login(email: email.text, password: password.text);
              },
              child: const Text('login'))
        ],
      ),
    );
  }
}
