import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkedin_post_material/riverpoadLoginDemo/data/dataSource/auth_data_source.dart';
import 'package:linkedin_post_material/riverpoadLoginDemo/data/models/user_model.dart';
import 'package:linkedin_post_material/riverpoadLoginDemo/domain/repositories/auth_repository.dart';
// here we put all the provider
// its like a link point between all the layer

// auth data source provider
final authDataSourceProvider =
    Provider<AuthDataSource>((ref) => AuthDataSource());

// auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.read(authDataSourceProvider);
  return AuthRepository(authDataSource: authDataSource);
});

// login provider

class LoginProvider extends AutoDisposeAsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() => null;

  void login({required String email, required String password}) async {
    // handling the loading state
    state = const AsyncLoading();
    // access the auth repository
    final authRepository = ref.read(authRepositoryProvider);
    // the guard function alternative to try/catch Statement
    // if login function return valid value ==> state = AsyncData(validValue)
    // else login function throw exception ==> state = AsyncError(errorMessage,stackStrace)
    state = await AsyncValue.guard(() async {
      return await authRepository.login(email: email, password: password);
    });
  }
}

// instantiate the login provider
final loginProvider =
    AsyncNotifierProvider.autoDispose<LoginProvider, UserModel?>(
        () => LoginProvider());
