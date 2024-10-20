class AuthDataSource {
  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    try {
      // assume this is a api call 
      // DataSource layer just return the row data "without any serialization"
      return await RemoteCall.loginWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }
}

// assume this is api OR firebase call
// its just for demonstration
class RemoteCall {
  static Future<Map<String, dynamic>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == "example@gmail.com" && password == "1234") {
      return {"name": "mohammed naji", "email": email, "gender": "male"};
    } else {
      throw "wrong email or password";
    }
  }
}
