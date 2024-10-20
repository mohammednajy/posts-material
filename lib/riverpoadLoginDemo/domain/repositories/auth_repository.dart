// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:linkedin_post_material/riverpoadLoginDemo/data/dataSource/auth_data_source.dart';
import 'package:linkedin_post_material/riverpoadLoginDemo/data/models/user_model.dart';

// this layer responsible for Business logic

class AuthRepository {
  AuthDataSource authDataSource;
  AuthRepository({
    required this.authDataSource,
  });

  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final value =
          await authDataSource.login(email: email, password: password);
      // if you need to store the user locale , here you should put the code
      return UserModel.fromMap(value);
    } catch (e) {
      // here you can throw the message as its
      //OR
      //you can change it to anther one "to be more readable to the user"
      rethrow;
    }
  }
}
