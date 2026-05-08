import 'dart:async';

/// A base service to simulate API calls.
/// This is "backend on dart" logic that could be moved to a server.
class ApiService {
  Future<T> get<T>(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('Real API not connected');
  }

  Future<T> post<T>(String endpoint, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate successful response
    return data as T;
  }
}
