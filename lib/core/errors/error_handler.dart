import 'dart:io';
import 'package:dio/dio.dart';
import 'app_error.dart';

class ErrorHandler {
  static AppError handle(dynamic error) {
    if (error is AppError) return error;
    if (error is DioError) return _fromDioError(error);
    if (error is SocketException) {
      return AppError(message: _translate('no_internet'), details: error.toString());
    }
    return AppError(message: _translate('unexpected'), details: error?.toString());
  }

  static AppError _fromDioError(DioError err) {
    final type = err.type;

    if (type == DioErrorType.connectionTimeout ||
        type == DioErrorType.sendTimeout ||
        type == DioErrorType.receiveTimeout) {
      return AppError(message: _translate('timeout'), details: err.message);
    }

    if (type == DioErrorType.cancel) {
      return AppError(message: _translate('request_cancelled'), details: err.message);
    }

    if (err.response != null) {
      final r = err.response!;
      final int? status = r.statusCode;
      final dynamic data = r.data;

      // If data is HTML (server returned error page), do not show raw HTML to user.
      if (data is String && _looksLikeHtml(data)) {
        // try extracting <title> if present (might contain a helpful message)
        final title = _extractHtmlTitle(data);
        final serverMsg = (title != null && title.trim().isNotEmpty) ? title : null;
        final message = serverMsg != null ? _translateServerMessage(serverMsg) : _translate('server_error');
        return AppError(message: message, details: 'HTML error page (status: $status)', statusCode: status);
      }

      // validation-like responses (422/400)
      if (status == 422 || status == 400) {
        try {
          Map<String, dynamic> fieldErrors = {};
          String? serverMessage;
          if (data is Map<String, dynamic>) {
            if (data.containsKey('errors')) {
              final dynamic errors = data['errors'];
              if (errors is Map<String, dynamic>) {
                errors.forEach((k, v) => fieldErrors[k] = v);
              }
            }
            if (data.containsKey('message')) serverMessage = data['message']?.toString();
            if (serverMessage == null && data.containsKey('error')) serverMessage = data['error']?.toString();
          }
          final msg = serverMessage ?? _translate('validation_error');
          return AppError(
            message: _translateServerMessage(msg),
            details: serverMessage,
            statusCode: status,
            fieldErrors: fieldErrors,
          );
        } catch (_) {
          return AppError(message: _translate('validation_error'), details: err.message, statusCode: status);
        }
      }

      // Non-validation JSON: try extract message keys
      String? serverMsg;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) {
          serverMsg = data['message']?.toString();
        } else if (data.containsKey('error')) {serverMsg = data['error']?.toString();
        }
        else if (data.containsKey('data') && data['data'] is Map && data['data'].containsKey('message')) {
          serverMsg = data['data']['message']?.toString();
        }
      } else if (data is String) {
        serverMsg = data;
      }

      if (serverMsg != null && serverMsg.trim().isNotEmpty) {
        return AppError(message: _translateServerMessage(serverMsg), details: serverMsg, statusCode: status);
      }

      // fallback: map by status code
      switch (status) {
        case 401:
          return AppError(message: _translate('unauthorized'), details: err.message, statusCode: status);
        case 403:
          return AppError(message: _translate('forbidden'), details: err.message, statusCode: status);
        case 404:
          return AppError(message: _translate('not_found'), details: err.message, statusCode: status);
        case 500:
          return AppError(message: _translate('server_error'), details: err.message, statusCode: status);
        default:
          return AppError(message: _translate('unexpected'), details: err.message, statusCode: status);
      }
    }

    // network-level errors
    if (err.error is SocketException) {
      return AppError(message: _translate('no_internet'), details: err.message);
    }

    return AppError(message: _translate('unexpected'), details: err.message);
  }

  // Heuristics to detect HTML content
  static bool _looksLikeHtml(String s) {
    final lower = s.toLowerCase();
    return lower.contains('<!doctype') || lower.contains('<html') || lower.contains('<head') || lower.contains('<body');
  }

  // try to extract <title> ... </title>
  static String? _extractHtmlTitle(String html) {
    try {
      final reg = RegExp(r'<title[^>]*>([\s\S]*?)<\/title>', caseSensitive: false);
      final m = reg.firstMatch(html);
      if (m != null && m.groupCount >= 1) return m.group(1)?.trim();
    } catch (_) {}
    return null;
  }

  static String _translateServerMessage(String serverMessage) {
    final lower = serverMessage.toLowerCase();
    if (lower.contains('invalid token') || lower.contains('token')) return _translate('invalid_token');
    if (lower.contains('user not found') || lower.contains('not found')) return _translate('not_found');
    if ((lower.contains('password') && lower.contains('incorrect') ) ||( lower
        .contains('invalid') && lower.contains('credentials'))) {
      return _translate('Invalid_credentials');
    }
    if (_looksArabic(serverMessage)) return serverMessage;
    return serverMessage;
  }

  static bool _looksArabic(String s) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(s);
  }

  static String _translate(String key) {
    const map = {
      'no_internet': 'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك.',
      'timeout': 'انتهت مهلة الاتصال بالخادم. حاول مرة أخرى.',
      'request_cancelled': 'تم إلغاء الطلب.',
      'validation_error': 'توجد أخطاء في البيانات المُدخلة. يرجى التحقق.',
      'unauthorized': 'غير مصرح. الرجاء تسجيل الدخول مرة أخرى.',
      'forbidden': 'ليس لديك صلاحية للوصول إلى هذا المورد.',
      'not_found': 'المورد غير موجود.',
      'server_error': 'خطأ في خادمنا. سنعمل على إصلاحه قريباً.',
      'unexpected': 'حدث خطأ غير متوقع. حاول مرة أخرى لاحقاً.',
      'invalid_token': 'رمز المصادقة غير صالح. الرجاء تسجيل الدخول.',
      'Invalid_credentials': 'بيانات التسجيل غير صحيحة.',
    };
    return map[key] ?? 'حدث خطأ. حاول مرة أخرى.';
  }
}
