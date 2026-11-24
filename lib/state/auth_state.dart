import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState({required this.apiClient, String? initialToken})
    : _token = initialToken;

  final ApiClient apiClient;

  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _token = await apiClient.login(username: username, password: password);
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final String? currentToken = _token;
    clearSession();
    if (currentToken == null) {
      return;
    }

    try {
      await apiClient.logout(currentToken);
    } on ApiException catch (error) {
      _errorMessage = error.message;
      notifyListeners();
    }
  }

  void clearSession() {
    _token = null;
    _errorMessage = null;
    notifyListeners();
  }
}
