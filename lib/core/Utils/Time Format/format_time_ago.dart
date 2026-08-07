import 'package:intl/intl.dart';

String formatTimeAgo(DateTime postTime) {
  final now = DateTime.now();
  final difference = now.difference(postTime);

  if (difference.inSeconds < 60) {
    return "Just now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes}m ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  } else if (difference.inDays < 7) {
    return "${difference.inDays}d ago";
  } else {
    // For older dates, show "Month Day" (e.g., "Mar 15") or include year if different
    return DateFormat(now.year == postTime.year ? 'MMM d' : 'MMM d, yyyy').format(postTime);
  }
}