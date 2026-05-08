import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_mart/features/auth/data/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

class AuthState {
  final bool isLoggedIn;
  final String? email;
  final String? name;
  final String? imagePath;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isLoggedIn = false, 
    this.email, 
    this.name, 
    this.imagePath, 
    this.isLoading = true,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn, 
    String? email, 
    String? name, 
    String? imagePath, 
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Note: error is usually reset to null unless provided
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _repository.isLoggedIn();
    final email = await _repository.getUserEmail();
    final name = await _repository.getUserName();
    final imagePath = await _repository.getUserImage();
    state = AuthState(
      isLoggedIn: isLoggedIn, 
      email: email, 
      name: name, 
      imagePath: imagePath,
      isLoading: false,
    );
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    
    final user = await _repository.verifyUser(email, password);
    if (user != null) {
      await _repository.login(email, user['name']);
      state = AuthState(
        isLoggedIn: true, 
        email: email, 
        name: user['name'], 
        isLoading: false
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false, 
        error: 'Invalid email or password'
      );
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _repository.registerUser(name, email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(isLoggedIn: false, isLoading: false);
  }

  Future<void> updateProfile(String name, String email, [String? imagePath]) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    await _repository.updateProfile(name, email, imagePath);
    state = state.copyWith(name: name, email: email, imagePath: imagePath, isLoading: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
