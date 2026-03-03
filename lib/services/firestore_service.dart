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
}
