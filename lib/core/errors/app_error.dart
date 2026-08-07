class AppError {
  final String message;      // user-friendly translated message (Arabic)
  final String? details;     // optional raw message/details (for logging)
  final int? statusCode;     // optional HTTP status
  final Map<String, dynamic>? fieldErrors; // validation field errors if any

  const AppError({
    required this.message,
    this.details,
    this.statusCode,
    this.fieldErrors,
  });

  @override
  String toString() => 'AppError(status:$statusCode, message:$message, details:$details, fields:$fieldErrors)';
}
