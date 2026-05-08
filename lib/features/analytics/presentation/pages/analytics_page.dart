import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_mart/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:ecommerce_mart/features/transactions/domain/models/transaction.dart';
import 'package:ecommerce_mart/core/theme/app_colors.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final expenseTransactions = transactions.where((t) => t.type == TransactionType.expense).toList();
    
    // Group by category for pie chart
    final Map<String, double> categoryData = {};
    for (var t in expenseTransactions) {
      categoryData[t.category] = (categoryData[t.category] ?? 0) + t.amount;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Expense Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 60,
                  sections: _buildPieSections(categoryData),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildCategoryList(categoryData),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(Map<String, double> data) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    
    int index = 0;
    return data.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${(entry.value / data.values.fold(0, (a, b) => a + b) * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildCategoryList(Map<String, double> data) {
    return Column(
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blue, // Simplified color logic
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(entry.key),
              const Spacer(),
              Text(
                '\$${entry.value.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
