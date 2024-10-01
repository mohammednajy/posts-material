import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // إضافة الـ Access Token  الهيدر قبل إرسال كل طلب
    String accessToken = 'current_access_token';
    options.headers["Authorization"] = "Bearer $accessToken";
    return handler.next(options); // استكمال الطلب
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // إذا كانت الاستجابة خطأ 401 (غير مصرح)
    if (err.response?.statusCode == 401) {
      // Access Token طلب تجديد الـ  Refresh Token باستخدام الـ 
      try {
        String refreshToken = 'current_refresh_token';
        Response refreshResponse =
            await dio.post('https://api.example.com/refresh', data: {
          'refresh_token': refreshToken,
        });

        if (refreshResponse.statusCode == 200) {
          //الجديد Access Token  الحصول على الـ
          String newAccessToken = refreshResponse.data['access_token'];

          // تحديث التوكن في الهيدر لكل الطلبات المستقبلية
          dio.options.headers["Authorization"] = "Bearer $newAccessToken";

          // إعادة إرسال الطلب الذي فشل بسبب انتهاء صلاحية التوكن
          final retryOptions = err.requestOptions;
          retryOptions.headers["Authorization"] = "Bearer $newAccessToken";
          final retryResponse = await dio.request(
            retryOptions.path,
            options: Options(
              method: retryOptions.method,
              headers: retryOptions.headers,
            ),
          );

          return handler.resolve(retryResponse); // إرجاع الاستجابة الجديدة
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

    return handler.next(err); // استكمال التعامل مع الخطأ إذا لم يكن 401
  }
}

void main() {
  Dio dio = Dio();
  // إضافة الـ Interceptor إلى Dio
  dio.interceptors.add(TokenInterceptor(dio));
}


