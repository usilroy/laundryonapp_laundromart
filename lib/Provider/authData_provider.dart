import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryonapp_laundromat/Models/authData.dart';

class AuthDataNotifier extends StateNotifier<AuthData> {
  AuthDataNotifier()
      : super(
          AuthData(
            laundromartId: 0,
            token: '',
            tokenType: '',
          ),
        );

  void setAuthData(AuthData authData) {
    state = authData;
  }
}

final authDataProvider =
    StateNotifierProvider<AuthDataNotifier, AuthData>((ref) {
  return AuthDataNotifier();
});
