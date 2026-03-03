import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch list of foods from 'foods' collection.
  /// Pass [simulateError]=true to force a simulated network error.
  Future<List<Food>> fetchFoods({bool simulateError = false}) async {
    try {
      if (simulateError) {
        throw Exception('Simulated network error');
      }

      final snapshot = await _db.collection('foods').get();
      return snapshot.docs.map((d) => Food.fromMap(d.data(), d.id)).toList();
    } catch (e) {
      // Re-throw so callers can handle and show Retry UI
      throw Exception('Failed to load foods: $e');
    }
  }

  /// Add sample food data to Firestore for testing.
  Future<void> addSampleFoods() async {
    try {
      final List<Map<String, dynamic>> sampleFoods = [
        {
          'name': 'Phở Bò',
          'description': 'Phở bò tái, nước dùng đậm đà, bánh phở mềm',
          'price': 3.5,
        },
        {
          'name': 'Cơm Tấm',
          'description': 'Tấm sườn nạc chiên, trứng, rau sống',
          'price': 2.8,
        },
        {
          'name': 'Bánh Mì',
          'description': 'Bánh mì thập cẩm với pâté, chả, rau cà chua',
          'price': 1.5,
        },
        {
          'name': 'Hủ Tiếu',
          'description': 'Hủ tiếu sứa, cua, tôm, giá sống',
          'price': 3.0,
        },
        {
          'name': 'Bún Chả',
          'description': 'Bún tươi, thịt nạc chiên, nước mắm, dưa leo',
          'price': 2.5,
        },
      ];

      for (var food in sampleFoods) {
        // if no image URL provided, generate a random picsum photo
        food['imageUrl'] =
            'https://picsum.photos/seed/${Uri.encodeComponent(food['name'])}-${DateTime.now().millisecondsSinceEpoch}/200/200';
        await _db.collection('foods').add(food);
      }
    } catch (e) {
      throw Exception('Failed to add sample foods: $e');
    }
  }
}
