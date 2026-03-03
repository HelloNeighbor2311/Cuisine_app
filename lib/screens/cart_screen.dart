import 'package:flutter/material.dart';
import '../models/food.dart';
import '../widgets/food_image.dart';

class CartScreen extends StatefulWidget {
  final List<Food> cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Food> _localCart;

  Map<String, _CartLine> get _groupedLines {
    final lines = <String, _CartLine>{};
    for (final food in _localCart) {
      final key = food.id;
      final existing = lines[key];
      if (existing == null) {
        lines[key] = _CartLine(food: food, quantity: 1);
      } else {
        lines[key] = _CartLine(
          food: existing.food,
          quantity: existing.quantity + 1,
        );
      }
    }
    return lines;
  }

  @override
  void initState() {
    super.initState();
    _localCart = List.from(widget.cart);
  }

  double get total => _localCart.fold(0.0, (sum, f) => sum + (f.price ?? 0));

  void _removeItem(Food food) {
    setState(() {
      _localCart.remove(food);
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedLines = _groupedLines.values.toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(_localCart);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Giỏ hàng'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_localCart);
            },
          ),
        ),
        body: _localCart.isEmpty
            ? const Center(child: Text('Giỏ hàng trống'))
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: groupedLines.length,
                itemBuilder: (ctx, i) {
                  final line = groupedLines[i];
                  final food = line.food;
                  final lineTotal = (food.price ?? 0) * line.quantity;
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: FoodImage(
                        imageUrl: food.imageUrl,
                        dishName: food.name,
                        fit: BoxFit.cover,
                        iconSize: 24,
                      ),
                    ),
                    title: Text(food.name),
                    subtitle: Text(
                      food.price != null
                          ? 'SL: ${line.quantity} • Đơn giá: \$${food.price!.toStringAsFixed(2)}'
                          : 'SL: ${line.quantity}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('\$${lineTotal.toStringAsFixed(2)}'),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeItem(food),
                        ),
                      ],
                    ),
                  );
                },
              ),
        bottomNavigationBar: _localCart.isEmpty
            ? null
            : SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng thanh toán',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_localCart.length} sản phẩm trong giỏ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _CartLine {
  final Food food;
  final int quantity;

  _CartLine({required this.food, required this.quantity});
}
