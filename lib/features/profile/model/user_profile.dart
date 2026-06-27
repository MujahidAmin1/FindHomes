class UserProfile {
  final String id;
  final String userId;
  final String? fullName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? bio;
  final String? location;

  UserProfile({
    required this.id,
    required this.userId,
    this.fullName,
    this.phoneNumber,
    this.profileImageUrl,
    this.bio,
    this.location,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'location': location,
    };
  }
}