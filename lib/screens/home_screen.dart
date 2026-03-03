import 'package:flutter/material.dart';
import '../models/food.dart';
import '../services/firestore_service.dart';
import '../widgets/food_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _service = FirestoreService();
  List<Food> _foods = [];
  bool _loading = true;
  String? _error;
  bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _service.fetchFoods(simulateError: _simulateError);
      setState(() {
        _foods = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Món Ăn'),
        actions: [
          IconButton(
            tooltip: 'Simulate error',
            icon: Icon(_simulateError ? Icons.wifi_off : Icons.wifi),
            onPressed: () {
              setState(() => _simulateError = !_simulateError);
            },
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _loadFoods,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 56,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Đã xảy ra lỗi khi tải dữ liệu',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_error ?? '', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadFoods,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _foods.length,
            itemBuilder: (context, index) {
              return FoodCard(food: _foods[index]);
            },
          );
        },
      ),
    );
  }
}
