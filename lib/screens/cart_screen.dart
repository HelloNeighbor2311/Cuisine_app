import 'package:flutter/material.dart';
import '../models/food.dart';

class CartScreen extends StatefulWidget {
  final List<Food> cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Food> _localCart;

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_localCart);
        return false;
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
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _localCart.length,
                      itemBuilder: (ctx, i) {
                        final food = _localCart[i];
                        return ListTile(
                          leading: food.imageUrl != null
                              ? Image.network(
                                  food.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported),
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
                            onPressed: () => _removeItem(food),
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
      ),
    );
  }
}
