import 'package:hive/hive.dart';
import 'package:ecommerce_mart/features/transactions/domain/models/transaction.dart';

class TransactionRepository {
  static const String _boxName = 'transactions';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionAdapter());
    }
    await Hive.openBox<Transaction>(_boxName);
  }

  Box<Transaction> get _box => Hive.box<Transaction>(_boxName);

  List<Transaction> getAllTransactions() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }
}
