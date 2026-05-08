import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecommerce_mart/core/theme/app_theme.dart';
import 'package:ecommerce_mart/features/transactions/data/transaction_repository.dart';
import 'package:ecommerce_mart/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:ecommerce_mart/features/auth/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize Repository
  final repository = TransactionRepository();
  await repository.init();
  
  runApp(
    ProviderScope(
      overrides: [
        transactionRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
