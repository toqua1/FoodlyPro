import 'dart:developer';
import '../../core/Utils/parsing.dart';

class ReviewResponse {
  final int page;
  final int limit;
  final int total;
  final List<ReviewModel> items;

  ReviewResponse({
    required this.page,
    required this.limit,
    required this.total,
    required this.items,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    // final payload = (json.containsKey('data') && json['data'] is Map) ? json['data'] as Map<String, dynamic> : json;
final payload =json;
    // final itemsRaw = (payload['items'] is List) ? (payload['items'] as List) : <dynamic>[];

    final pageVal = payload['page'];
    final limitVal = payload['limit'];
    final totalVal = payload['total'];

    final items = payload['items'].map<ReviewModel>((e) {
      try {
        return ReviewModel.fromJson(e as Map<String, dynamic>);
      } catch (err) {
        log('Failed to parse review item: $err — raw: $e');
        return ReviewModel.empty(); // fallback instance (see below)
      }
    }).toList();

    final page = parseInt(pageVal, items.isNotEmpty ? 1 : 1);
    final limit = parseInt(limitVal, items.length > 0 ? items.length : 10);
    final total = parseInt(totalVal, items.length);

    return ReviewResponse(page: page, limit: limit, total: total, items: items);
  }
}

class ReviewModel {
  final int id;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReviewUser user;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: parseInt(json['id']),
      rating: parseInt(json['rating']),
      comment: json['comment']?.toString() ?? '',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      user: json['user'] is Map ? ReviewUser.fromJson(json['user'] as Map<String, dynamic>) : ReviewUser.empty(),
    );
  }

  // fallback empty instance
  factory ReviewModel.empty() => ReviewModel(
    id: 0,
    rating: 0,
    comment: '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    user: ReviewUser.empty(),
  );
}

class MeReviewModel {
  final int id;
  final int productId;
  final int userId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  MeReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MeReviewModel.fromJson(Map<String, dynamic> json) {

    return MeReviewModel(
      id: parseInt(json['id']),
      productId: parseInt(json['productId']),
      userId: parseInt(json['userId']),
      rating: parseInt(json['rating']),
      comment: json['comment']?.toString() ?? '',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }
}

class ReviewUser {
  final int id;
  final String email;
  final String name;

  ReviewUser({
    required this.id,
    required this.email,
    required this.name,
  });
  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: parseInt(json['id']),
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? 'مستخدم',
    );
  }
  factory ReviewUser.empty() => ReviewUser(id: 0, email: '', name: 'مستخدم');
}

class ReviewSummary {
  final double ratingAverage;
  final int id;
  final int ratingCount;

  ReviewSummary({
    required this.ratingAverage,
    required this.id,
    required this.ratingCount,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    dynamic avgRaw = json['ratingAverage'] ;

    final avg = parseDouble(avgRaw);
    final id = parseInt(json['id']);
    final ratingCount = parseInt(json['ratingCount']);
    return ReviewSummary(ratingAverage: avg, id: id, ratingCount: ratingCount);
  }
}

class ReviewView {
  final int id;
  final String authorName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isMine;

  ReviewView({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.isMine,
  });

  factory ReviewView.fromReviewModel(ReviewModel m) {
    return ReviewView(
      id: m.id,
      authorName: m.user.name,
      rating: m.rating,
      comment: m.comment,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      isMine: false,
    );
  }

  factory ReviewView.fromMeReview(MeReviewModel m, {String myName = 'أنت'}) {
    // backend MeReview doesn't carry user info — show "You" or fetch stored user name
    return ReviewView(
      id: m.id,
      authorName: myName,
      rating: m.rating,
      comment: m.comment,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      isMine: true,
    );
  }
}

// Models for API requests
class AddReviewBody {
  final int productId;
  final int rating;
  final String comment;

  AddReviewBody({required this.productId, required this.rating, required this.comment});

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'rating': rating,
      'comment': comment,
    };
  }
}

class UpdateReviewBody {
  final int rating;
  final String comment;

  UpdateReviewBody({required this.rating, required this.comment});

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
    };
  }
}
