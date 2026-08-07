import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:elmaleka_kitchen_project/Services/Storage/secure_storage_service.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:elmaleka_kitchen_project/core/errors/app_error.dart';
import 'package:elmaleka_kitchen_project/view_model/Auth/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'Storage/shared_preferences_service.dart';
import 'package:path_provider/path_provider.dart';

// Singletone ApiServices
//one Dio instance is used in app-wide

class ApiServices {
  final String baseUrl='https://api.queen.kitchen' ;
  ApiServices._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // Auth-dio for refresh calls (no interceptors)
    _authDio = Dio(BaseOptions(baseUrl: baseUrl));

    // Initialize CookieJar for persistent storage
    _setupCookies();

    // Request interceptor: attach token to every request (async)
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await SecureStorageService().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (_) {
          // ignore token read errors
        }
        return handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (DioError err, handler) async {
        // If it's 401, try refresh flow
        final resStatus = err.response?.statusCode;
        if (resStatus == 401) {
          try {
            final retryResp = await _handle401AndRefresh(err);
            // If refresh + retry succeeded, resolve with that response
            return handler.resolve(retryResp);
          } catch (e) {
            // refresh failed or something else - convert to AppError and reject
            final appErr = (e is AppError) ? e : ErrorHandler.handle(e);
            final dioErr = DioError(
              requestOptions: err.requestOptions,
              response: err.response,
              type: err.type,
              error: appErr,
            );
            return handler.reject(dioErr);
          }
        }

        // Non-401: convert to AppError (via ErrorHandler) and reject
        final appErr = ErrorHandler.handle(err);
        final dioErr = DioError(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: appErr,
        );
        return handler.reject(dioErr);
      },
    ));

    // Optional: logging interceptor (disable in production)
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: false));
  }

  static final ApiServices _instance = ApiServices._internal();
  factory ApiServices() => _instance;

  late final Dio _dio;
  late final Dio _authDio;

  Dio get dio => _dio;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;
//So the pattern avoids multiple simultaneous refresh attempts

  Future<void> _setupCookies() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage(appDocDir.path),
    );
    _dio.interceptors.add(CookieManager(cookieJar));
    _authDio.interceptors.add(CookieManager(cookieJar));
  }

  Future<Response> _handle401AndRefresh(DioError originalError) async {
    final reqOptions = originalError.requestOptions;

    if (_isRefreshing) {
      await _refreshCompleter?.future;
      final newToken = await SecureStorageService().getToken();
      if (newToken == null) {
        throw AppError(message: 'غير مصرح. الرجاء تسجيل الدخول مرة أخرى', statusCode: 401);
      }
      reqOptions.headers['Authorization'] = 'Bearer $newToken';
      return _dio.fetch(reqOptions);
    }

    _isRefreshing = true;
    _refreshCompleter = Completer();

    try {
      // The Dio instance with CookieManager will automatically handle the refresh token.
      // The refresh request itself doesn't need to contain email/password.
      final refreshRes = await _authDio.post(ApiEndpoints.authRefreshToken);

      final newToken = refreshRes.data['accessToken'] as String?;
      if (newToken == null || newToken.isEmpty) {
        throw AppError(message: 'فشل التحديث', statusCode: 401);
      }

      await SecureStorageService().saveToken(newToken);
      _dio.options.headers['Authorization'] = 'Bearer $newToken';

      _isRefreshing = false;
      _refreshCompleter?.complete();

      reqOptions.headers['Authorization'] = 'Bearer $newToken';
      final retryResponse = await _dio.fetch(reqOptions);
      return retryResponse;
    } catch (e) {
      // Refresh failed -> Clear token & complete completer with error
      final authCubit = GetIt.I<AuthCubit>();
      authCubit.logout(); // This is correct, it will clear tokens.
      _isRefreshing = false;
      _refreshCompleter?.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
      _isRefreshing = false;
    }
  }
}
