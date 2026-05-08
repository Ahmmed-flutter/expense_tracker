import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
enum TransactionType { 
  @HiveField(0)
  income, 
  @HiveField(1)
  expense 
}

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final TransactionType type;
  @HiveField(6)
  final String? note;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Transaction copyWith({
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    TransactionType? type,
    String? note,
  }) {
    return Transaction(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }
}
