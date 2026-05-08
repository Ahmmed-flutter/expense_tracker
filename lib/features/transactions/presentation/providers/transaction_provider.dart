import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_mart/features/transactions/domain/models/transaction.dart';
import 'package:ecommerce_mart/features/transactions/data/transaction_repository.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final TransactionRepository _repository;

  TransactionNotifier(this._repository) : super([]) {
    _loadTransactions();
  }

  void _loadTransactions() {
    state = _repository.getAllTransactions();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.addTransaction(transaction);
    state = _repository.getAllTransactions();
  }

  Future<void> removeTransaction(String id) async {
    await _repository.deleteTransaction(id);
    state = _repository.getAllTransactions();
  }

  double get totalBalance => totalIncome - totalExpenses;

  double get totalIncome => state
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => state
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);
}

final transactionRepositoryProvider = Provider((ref) => TransactionRepository());

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository);
});
