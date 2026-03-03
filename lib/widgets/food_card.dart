import 'package:flutter/material.dart';
import '../models/food.dart';
import 'food_image.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;

  const FoodCard({super.key, required this.food, this.onAddToCart, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: FoodImage(
                  imageUrl: food.imageUrl,
                  dishName: food.name,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (food.price != null) ...[
                const SizedBox(width: 8),
                Text('\$${food.price!.toStringAsFixed(2)}'),
              ],
              if (onAddToCart != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: onAddToCart,
                  tooltip: 'Thêm vào giỏ',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
