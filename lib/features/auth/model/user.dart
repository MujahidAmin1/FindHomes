enum UserRole {
  client,
  agent,
  admin,
}

enum OnboardingStatus {
  not_started,
  in_progress,
  completed,
}

class UserModel {
  final String id;
  final String email;
  final UserRole role;
  final bool isActive;
  final bool isVerified;
  final OnboardingStatus onboardingStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    required this.isVerified,
    required this.onboardingStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      role: UserRole.values.byName(json['role']),
      isActive: json['is_active'] as bool,
      isVerified: json['is_verified'] as bool,
      onboardingStatus: OnboardingStatus.values.byName(
        json['onboarding_status'],
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.name,
      'is_active': isActive,
      'is_verified': isVerified,
      'onboarding_status': onboardingStatus.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class UserResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final UserModel user;

  UserResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'user': user.toJson(),
    };
  }
}