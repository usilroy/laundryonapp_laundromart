class AuthResponse {
  final int customerId;
  final String accessToken;
  final String tokenType;

  AuthResponse(
      {required this.customerId,
      required this.accessToken,
      required this.tokenType});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      customerId: json['customer_id'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}
