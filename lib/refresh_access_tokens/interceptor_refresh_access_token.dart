import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // add access token to the header before sending each request
    String accessToken = 'current_access_token';
    options.headers["Authorization"] = "Bearer $accessToken";
    return handler.next(options);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // if the response error is 401 (no authorized)
    if (err.response?.statusCode == 401) {
      // using refresh token ask for new access token
      try {
        String refreshToken = 'current_refresh_token';
        Response refreshResponse =
            await dio.post('https://api.example.com/refresh', data: {
          'refresh_token': refreshToken,
        });

        if (refreshResponse.statusCode == 200) {
          // getting new access token
          String newAccessToken = refreshResponse.data['access_token'];

          // update access token from the header for all coming requests
          dio.options.headers["Authorization"] = "Bearer $newAccessToken";

          // resend the failed request due to the token expiration
          final retryOptions = err.requestOptions;
          retryOptions.headers["Authorization"] = "Bearer $newAccessToken";
          final retryResponse = await dio.request(
            retryOptions.path,
            options: Options(
              method: retryOptions.method,
              headers: retryOptions.headers,
            ),
          );
          // return the new response
          return handler.resolve(retryResponse);
        } else {
          return handler.reject(DioException(
              requestOptions: err.requestOptions,
              error: 'Failed to refresh token'));
        }
      } catch (e) {
        return handler.reject(DioException(
            requestOptions: err.requestOptions,
            error: 'Failed to refresh token'));
      }
    }
    //  Complete error handling if you do not have a 401
    return handler.next(err);
  }
}

void main() {
  Dio dio = Dio();
  // add Interceptor to the dio
  dio.interceptors.add(TokenInterceptor(dio));
}
