class AuthData {
  final int laundromartId;
  final String token;
  final String tokenType;

  AuthData({
    required this.laundromartId,
    required this.token,
    required this.tokenType,
  });

  AuthData.fromJson(Map<String, dynamic> json)
      : laundromartId = json['laundromart_id'],
        token = json['access_token'],
        tokenType = json['token_type'];
}
