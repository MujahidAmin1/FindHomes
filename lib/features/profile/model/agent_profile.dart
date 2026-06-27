class AgentProfile {
  final String id;
  final String userId;
  final String? agencyName;
  final int? experienceYears;
  final bool isVerified;

  AgentProfile({
    required this.id,
    required this.userId,
    this.agencyName,
    this.experienceYears,
    required this.isVerified,
  });

  factory AgentProfile.fromJson(Map<String, dynamic> json) {
    return AgentProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      agencyName: json['agency_name'] as String?,
      experienceYears: json['experience_years'] as int?,
      isVerified: json['is_verified'] as bool,
    );
  }
}