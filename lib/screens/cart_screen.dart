import 'package:flutter/material.dart';
import '../models/food.dart';

class CartScreen extends StatelessWidget {
  final List<Food> cart;
  final void Function(Food) onRemove;

  const CartScreen({super.key, required this.cart, required this.onRemove});

  double get total => cart.fold(0.0, (sum, f) => sum + (f.price ?? 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: cart.isEmpty
          ? const Center(child: Text('Giỏ hàng trống'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (ctx, i) {
                      final food = cart[i];
                      return ListTile(
                        leading: food.imageUrl != null
                            ? Image.network(
                                food.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.fastfood),
                        title: Text(food.name),
                        subtitle: Text(
                          food.price != null
                              ? '\$${food.price!.toStringAsFixed(2)}'
                              : '',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => onRemove(food),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
