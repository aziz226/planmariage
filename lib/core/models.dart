import 'package:flutter/material.dart';

// ── UI-only models (utilisent IconData, non sérialisables) ──

class ServiceModel {
  final String title;
  final String description;
  final IconData icon;
  final int count;
  final String providerLabel;

  const ServiceModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.count,
    required this.providerLabel,
  });
}

// ── Catégorie (depuis la base de données) ──

class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final int providerCount;

  const CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.providerCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    icon: json['icon'] as String?,
    providerCount: json['provider_count'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon,
  };

  /// Mappe le nom d'icône stocké en base vers un IconData Flutter.
  IconData get iconData {
    switch (icon?.toLowerCase()) {
      case 'palette':
      case 'palette_outlined':
        return Icons.palette_outlined;
      case 'shirt':
      case 'shirt_outline':
        return Icons.checkroom;
      case 'car':
      case 'car_detailed':
        return Icons.directions_car;
      case 'building':
      case 'building_2_fill':
        return Icons.apartment;
      case 'music':
      case 'music_note':
      case 'music_note_2':
        return Icons.music_note;
      case 'camera':
        return Icons.camera_alt;
      case 'restaurant':
        return Icons.restaurant;
      case 'rose':
      case 'rose_outline':
      case 'flower':
        return Icons.local_florist;
      case 'cake':
        return Icons.cake;
      case 'ring':
        return Icons.diamond;
      case 'spa':
        return Icons.spa;
      case 'video':
        return Icons.videocam;
      default:
        return Icons.category;
    }
  }
}

class PackModel {
  final String? id;
  final String name;
  final String level; // ex: "Populaire", "Recommandé", "Luxe"
  final int price;
  final String? description;
  final List<String> services;
  final String? providerId;

  // Joined data
  final String? providerName;

  const PackModel({
    this.id,
    required this.name,
    required this.level,
    required this.price,
    this.description,
    required this.services,
    this.providerId,
    this.providerName,
  });

  factory PackModel.fromJson(Map<String, dynamic> json) {
    return PackModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      level: json['level'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      description: json['description'] as String?,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      providerId: json['provider_id'] as String?,
      providerName: json['providers'] != null
          ? (json['providers'] as Map<String, dynamic>)['name'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'level': level,
    'price': price,
    'description': description,
    'services': services,
    'provider_id': providerId,
  };

  /// Format price as "950 000 FCFA"
  String get formattedPrice {
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(str[i]);
    }
    return '$buffer FCFA';
  }
}

// ── Supabase models (sérialisables JSON) ──

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? phone;
  final String? photoUrl;
  final String? ville;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.phone,
    this.photoUrl,
    this.ville,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      phone: json['phone'] as String?,
      photoUrl: json['photo_url'] as String?,
      ville: json['ville'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'display_name': displayName,
    'phone': phone,
    'photo_url': photoUrl,
    'ville': ville,
  };
}

class ProviderModel {
  final String id;
  final String name;
  final String description;
  final String serviceCategory;
  final String ville;
  final String? address;
  final String? phone;
  final String? email;
  final int priceFrom;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final DateTime createdAt;

  const ProviderModel({
    required this.id,
    required this.name,
    required this.description,
    required this.serviceCategory,
    required this.ville,
    this.address,
    this.phone,
    this.email,
    required this.priceFrom,
    required this.imageUrls,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.createdAt,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      serviceCategory: json['service_category'] as String,
      ville: json['ville'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      priceFrom: json['price_from'] as int? ?? 0,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'service_category': serviceCategory,
    'ville': ville,
    'address': address,
    'phone': phone,
    'email': email,
    'price_from': priceFrom,
    'image_urls': imageUrls,
    'is_verified': isVerified,
  };
}

class BookingModel {
  final String id;
  final String userId;
  final String? providerId;
  final String? packTitle;
  final DateTime? eventDate;
  final String status;
  final int totalPrice;
  final String? paymentMethod;
  final String? notes;
  final DateTime createdAt;

  // Joined data
  final ProviderModel? provider;

  const BookingModel({
    required this.id,
    required this.userId,
    this.providerId,
    this.packTitle,
    this.eventDate,
    required this.status,
    required this.totalPrice,
    this.paymentMethod,
    this.notes,
    required this.createdAt,
    this.provider,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      providerId: json['provider_id'] as String?,
      packTitle: json['pack_title'] as String?,
      eventDate: json['event_date'] != null
          ? DateTime.parse(json['event_date'] as String)
          : null,
      status: json['status'] as String? ?? 'pending',
      totalPrice: json['total_price'] as int? ?? 0,
      paymentMethod: json['payment_method'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      provider: json['providers'] != null
          ? ProviderModel.fromJson(json['providers'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'user_id': userId,
      'status': status,
      'total_price': totalPrice,
    };
    if (providerId != null) map['provider_id'] = providerId;
    if (packTitle != null) map['pack_title'] = packTitle;
    if (eventDate != null) map['event_date'] = eventDate!.toIso8601String().split('T').first;
    if (paymentMethod != null) map['payment_method'] = paymentMethod;
    if (notes != null) map['notes'] = notes;
    return map;
  }
}

class ReviewModel {
  final String id;
  final String userId;
  final String providerId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  // Joined data
  final String? userName;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.userName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      providerId: json['provider_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userName: json['profiles'] != null
          ? (json['profiles'] as Map<String, dynamic>)['display_name'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'provider_id': providerId,
    'rating': rating,
    'comment': comment,
  };
}

class ContactMessage {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String message;
  final DateTime? createdAt;

  const ContactMessage({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.message,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'message': message,
  };
}

class SubscriptionModel {
  final String id;
  final String providerId;
  final String planType;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int price;
  final DateTime createdAt;

  // Joined data
  final ProviderModel? provider;

  const SubscriptionModel({
    required this.id,
    required this.providerId,
    required this.planType,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.price,
    required this.createdAt,
    this.provider,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      planType: json['plan_type'] as String? ?? 'basic',
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      status: json['status'] as String? ?? 'active',
      price: json['price'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      provider: json['providers'] != null
          ? ProviderModel.fromJson(json['providers'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isActive => status == 'active' && endDate.isAfter(DateTime.now());
}

class CartItem {
  final ProviderModel? provider;
  final PackModel? pack;
  final int price;

  const CartItem({
    this.provider,
    this.pack,
    required this.price,
  });

  String get title => provider?.name ?? pack?.name ?? '';
  String get subtitle => provider?.serviceCategory ?? pack?.level ?? '';
}
