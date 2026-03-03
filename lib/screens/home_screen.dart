import 'package:flutter/material.dart';
import '../models/food.dart';
import '../services/firestore_service.dart';
import '../widgets/food_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _service = FirestoreService();
  List<Food> _foods = [];
  List<Food> _cart = [];
  String _searchQuery = '';
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
      debugPrint('[HomeScreen] Fetching foods...');
      final list = await _service.fetchFoods(simulateError: _simulateError);
      debugPrint('[HomeScreen] Fetched ${list.length} foods');
      setState(() {
        _foods = list;
        _loading = false;
      });
    } catch (e) {
      debugPrint('[HomeScreen] Error loading foods: $e');
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _searchQuery.isEmpty
        ? _foods
        : _foods
              .where(
                (f) =>
                    f.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Món Ăn'),
        actions: [
          IconButton(
            tooltip: 'Giỏ hàng',
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${_cart.length}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () async {
              final updatedCart = await Navigator.of(context).push<List<Food>>(
                MaterialPageRoute(builder: (_) => CartScreen(cart: _cart)),
              );
              if (updatedCart != null && mounted) {
                setState(() {
                  _cart = updatedCart;
                });
              }
            },
          ),
          IconButton(
            tooltip: 'Add sample data',
            icon: const Icon(Icons.add_circle),
            onPressed: () async {
              try {
                await _service.addSampleFoods();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sample foods added!')),
                  );
                }
                await Future.delayed(const Duration(milliseconds: 500));
                _loadFoods();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
          ),
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Tìm kiếm...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    setState(() => _searchQuery = v);
                  },
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('Không có kết quả'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final food = filtered[index];
                          return FoodCard(
                            food: food,
                            onAddToCart: () {
                              setState(() {
                                _cart.add(food);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${food.name} đã được thêm vào giỏ',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
