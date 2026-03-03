import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const List<String> _legacyTop20DishNames = [
    'Phở Bò',
    'Cơm Tấm',
    'Bánh Mì',
    'Hủ Tiếu',
    'Bún Chả',
    'Gỏi Cuốn',
    'Bánh Xèo',
    'Cao Lầu',
    'Mì Quảng',
    'Bún Bò Huế',
    'Chả Giò',
    'Cháo Lòng',
    'Bánh Cuốn',
    'Bánh Bột Lọc',
    'Xôi Gà',
    'Bánh Căn',
    'Bún Riêu',
    'Nem Nướng',
    'Cơm Gà',
    'Bánh Bèo',
  ];

  static const List<Map<String, dynamic>> _top20Products = [
    {
      'name': 'Margherita Pizza',
      'description':
          'Classic Neapolitan-style pizza with San Marzano tomato sauce, fresh mozzarella, basil leaves, a touch of olive oil, and a thin crust baked at high heat for a smoky finish.',
      'price': 3.5,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Gluten_lactose_free_margherita_pizza_by_sch%C3%A4r_brand.jpg/960px-Gluten_lactose_free_margherita_pizza_by_sch%C3%A4r_brand.jpg',
    },
    {
      'name': 'Sushi Platter',
      'description':
          'Assorted Japanese sushi set including salmon nigiri, tuna nigiri, shrimp nigiri, cucumber rolls, and pickled ginger, served with soy sauce and wasabi.',
      'price': 2.8,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Sushi_platter.jpg/960px-Sushi_platter.jpg',
    },
    {
      'name': 'Beef Burger',
      'description':
          'Flame-grilled beef patty layered with cheddar cheese, lettuce, tomato, caramelized onion, pickles, and house burger sauce in a toasted brioche bun.',
      'price': 1.5,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/NCI_Visuals_Food_Hamburger.jpg/960px-NCI_Visuals_Food_Hamburger.jpg',
    },
    {
      'name': 'Spaghetti Carbonara',
      'description':
          'Italian spaghetti tossed with crispy pancetta, egg yolk, pecorino romano, parmesan, and black pepper, creating a rich and silky no-cream sauce.',
      'price': 3.0,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Espaguetis_carbonara.jpg/960px-Espaguetis_carbonara.jpg',
    },
    {
      'name': 'Chicken Tacos',
      'description':
          'Soft corn tortillas filled with grilled marinated chicken, pico de gallo, lettuce, avocado slices, and lime crema with a mild smoky chili note.',
      'price': 2.5,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/001_Tacos_de_carnitas%2C_carne_asada_y_al_pastor.jpg/960px-001_Tacos_de_carnitas%2C_carne_asada_y_al_pastor.jpg',
    },
    {
      'name': 'Tonkotsu Ramen',
      'description':
          'Rich Japanese ramen featuring slow-simmered pork bone broth, springy noodles, chashu pork slices, ajitama egg, scallions, and wood ear mushrooms.',
      'price': 2.0,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Tonkotsu_ramen_in_Tokyo.jpg/960px-Tonkotsu_ramen_in_Tokyo.jpg',
    },
    {
      'name': 'Pad Thai',
      'description':
          'Thai stir-fried rice noodles with shrimp, tofu, bean sprouts, chives, tamarind sauce, crushed peanuts, and fresh lime for balanced sweet-sour flavor.',
      'price': 2.2,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Phat_Thai_kung_Chang_Khien_street_stall.jpg/960px-Phat_Thai_kung_Chang_Khien_street_stall.jpg',
    },
    {
      'name': 'Bibimbap',
      'description':
          'Korean rice bowl topped with seasoned beef, sautéed vegetables, fried egg, kimchi, and gochujang sauce, mixed before eating for bold umami flavor.',
      'price': 3.2,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Bibimbap_7.jpg/960px-Bibimbap_7.jpg',
    },
    {
      'name': 'Seafood Paella',
      'description':
          'Traditional Spanish paella with saffron rice, mussels, shrimp, squid, peas, bell peppers, and a light seafood stock infused with paprika.',
      'price': 2.9,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Seafood_paella_red.jpg/960px-Seafood_paella_red.jpg',
    },
    {
      'name': 'Chicken Biryani',
      'description':
          'Fragrant Indian basmati rice layered with spiced chicken, caramelized onions, mint, and saffron, slow-cooked in dum style for deep aroma.',
      'price': 3.3,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/A_home_made_plate_of_mutton_biryani_served_with_chicken_kassa_cooked_in_the_bengali_style.jpg/960px-A_home_made_plate_of_mutton_biryani_served_with_chicken_kassa_cooked_in_the_bengali_style.jpg',
    },
    {
      'name': 'Greek Salad',
      'description':
          'Mediterranean salad of cucumber, tomato, red onion, olives, feta cheese, oregano, and extra virgin olive oil, served fresh and chilled.',
      'price': 2.4,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Greek-Salad_%26_Wine.jpg/960px-Greek-Salad_%26_Wine.jpg',
    },
    {
      'name': 'Caesar Salad',
      'description':
          'Crisp romaine lettuce tossed in creamy Caesar dressing with parmesan shavings, garlic croutons, and optional grilled chicken topping.',
      'price': 2.1,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Caesar_salad_with_chicken%2C_homemade_-_Massachusetts.jpg/960px-Caesar_salad_with_chicken%2C_homemade_-_Massachusetts.jpg',
    },
    {
      'name': 'Fish and Chips',
      'description':
          'British-style battered white fish fried until crisp, served with thick-cut fries, tartar sauce, lemon wedge, and a hint of malt vinegar.',
      'price': 2.0,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Fish_and_chips_plate_with_peas.jpg/960px-Fish_and_chips_plate_with_peas.jpg',
    },
    {
      'name': 'Steak Frites',
      'description':
          'French bistro classic with grilled steak cooked to preference, golden fries, herb butter, and a light peppercorn jus on the side.',
      'price': 1.8,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Reel_and_Brand_-_September_2021_-_Sarah_Stierch_05.jpg/960px-Reel_and_Brand_-_September_2021_-_Sarah_Stierch_05.jpg',
    },
    {
      'name': 'Butter Chicken',
      'description':
          'North Indian curry of tandoori-style chicken simmered in creamy tomato-butter gravy with garam masala, kasuri methi, and fresh cream.',
      'price': 2.3,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Chicken_makhani.jpg/960px-Chicken_makhani.jpg',
    },
    {
      'name': 'Falafel Wrap',
      'description':
          'Middle Eastern pita wrap filled with crispy falafel, hummus, tahini, pickled vegetables, lettuce, and tomatoes for a savory herbal bite.',
      'price': 1.9,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Falafel_Melt_Wrap_-_We_Love_Falafel_2023-09-27.jpg/960px-Falafel_Melt_Wrap_-_We_Love_Falafel_2023-09-27.jpg',
    },
    {
      'name': 'Burrito Bowl',
      'description':
          'Mexican-style bowl with cilantro rice, black beans, grilled chicken, corn salsa, pico de gallo, guacamole, and chipotle dressing.',
      'price': 2.7,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Steak_burrito_bowl_at_La_Casa_Restaurant_in_Sonoma%2C_California_-_Sarah_Stierch_03.jpg/960px-Steak_burrito_bowl_at_La_Casa_Restaurant_in_Sonoma%2C_California_-_Sarah_Stierch_03.jpg',
    },
    {
      'name': 'Dim Sum Basket',
      'description':
          'Steamed dim sum assortment featuring har gow, siu mai, pork dumplings, and dipping sauce, served in a traditional bamboo basket.',
      'price': 2.6,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Three_dim_sum_in_steamer_basket.jpg/960px-Three_dim_sum_in_steamer_basket.jpg',
    },
    {
      'name': 'Butter Croissant',
      'description':
          'Classic French croissant baked with laminated dough, featuring a crisp golden exterior and soft buttery honeycomb layers inside.',
      'price': 3.0,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Croissant_with_jam_and_butter_-_Little_Miss_Piggies.jpg/960px-Croissant_with_jam_and_butter_-_Little_Miss_Piggies.jpg',
    },
    {
      'name': 'Tiramisu',
      'description':
          'Italian layered dessert made with espresso-soaked ladyfingers, mascarpone cream, cocoa powder, and a delicate hint of vanilla.',
      'price': 1.7,
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Dolce_Tiramis%C3%B9_monoporzione.jpg/960px-Dolce_Tiramis%C3%B9_monoporzione.jpg',
    },
  ];

  String _stripVietnameseAccents(String value) {
    final lower = value.toLowerCase();
    const accentMap = {
      'à': 'a',
      'á': 'a',
      'ạ': 'a',
      'ả': 'a',
      'ã': 'a',
      'â': 'a',
      'ầ': 'a',
      'ấ': 'a',
      'ậ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ă': 'a',
      'ằ': 'a',
      'ắ': 'a',
      'ặ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'è': 'e',
      'é': 'e',
      'ẹ': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ê': 'e',
      'ề': 'e',
      'ế': 'e',
      'ệ': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ì': 'i',
      'í': 'i',
      'ị': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ò': 'o',
      'ó': 'o',
      'ọ': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ô': 'o',
      'ồ': 'o',
      'ố': 'o',
      'ộ': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ơ': 'o',
      'ờ': 'o',
      'ớ': 'o',
      'ợ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ù': 'u',
      'ú': 'u',
      'ụ': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ư': 'u',
      'ừ': 'u',
      'ứ': 'u',
      'ự': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ỳ': 'y',
      'ý': 'y',
      'ỵ': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'đ': 'd',
    };

    final buffer = StringBuffer();
    for (final char in lower.split('')) {
      buffer.write(accentMap[char] ?? char);
    }
    return buffer.toString();
  }

  String _normalizeDishName(String dishName) {
    return _stripVietnameseAccents(dishName.trim())
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _buildAttractiveImageUrl(String dishName) {
    final normalized = _normalizeDishName(dishName);
    final seed = Uri.encodeComponent(
      normalized.isEmpty ? 'food-dish' : 'food-$normalized',
    );
    return 'https://picsum.photos/seed/$seed/600/400';
  }

  bool _isInvalidOrLegacyUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return true;
    }

    final uri = Uri.tryParse(imageUrl);
    final host = uri?.host.toLowerCase() ?? '';
    if (host.isEmpty) {
      return true;
    }

    return host.contains('source.unsplash.com') ||
        host.contains('loremflickr.com') ||
        host.contains('dummyimage.com');
  }

  String _normalizeImageUrl(String? imageUrl, String fallbackSeed) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return _buildAttractiveImageUrl(fallbackSeed);
    }

    if (_isInvalidOrLegacyUrl(imageUrl)) {
      return _buildAttractiveImageUrl(fallbackSeed);
    }

    return imageUrl;
  }

  /// Fetch list of foods from 'foods' collection.
  /// Pass [simulateError]=true to force a simulated network error.
  Future<List<Food>> fetchFoods({bool simulateError = false}) async {
    try {
      if (simulateError) {
        throw Exception('Simulated network error');
      }

      final snapshot = await _db.collection('foods').get();
      final foods = snapshot.docs.map((d) => Food.fromMap(d.data(), d.id));

      return foods
          .map(
            (food) => Food(
              id: food.id,
              name: food.name,
              description: food.description,
              price: food.price,
              imageUrl: _normalizeImageUrl(food.imageUrl, food.name),
            ),
          )
          .toList();
    } catch (e) {
      // Re-throw so callers can handle and show Retry UI
      throw Exception('Failed to load foods: $e');
    }
  }

  /// Add sample food data to Firestore for testing.
  Future<void> addSampleFoods() async {
    try {
      for (final food in _top20Products) {
        final normalizedFood = {
          ...food,
          'imageUrl': _normalizeImageUrl(
            food['imageUrl'] as String?,
            food['name'] as String? ?? 'food',
          ),
        };
        await _db.collection('foods').add(normalizedFood);
      }
    } catch (e) {
      throw Exception('Failed to add sample foods: $e');
    }
  }

  /// Keep only the top 20 default dishes in Firestore and remove duplicates.
  /// It also renames legacy dishes to the new international dataset.
  /// Returns number of changed documents (updated + deleted + inserted).
  Future<int> enforceTop20Products() async {
    try {
      final curatedByName = <String, Map<String, dynamic>>{};
      for (final product in _top20Products) {
        final name = product['name'] as String? ?? '';
        curatedByName[_normalizeDishName(name)] = product;
      }

      final legacyToCuratedKey = <String, String>{};
      for (var index = 0; index < _legacyTop20DishNames.length; index++) {
        final legacyName = _legacyTop20DishNames[index];
        final curatedName = _top20Products[index]['name'] as String? ?? '';
        legacyToCuratedKey[_normalizeDishName(legacyName)] = _normalizeDishName(
          curatedName,
        );
      }

      final snapshot = await _db.collection('foods').get();
      final batch = _db.batch();
      final keptCuratedKeys = <String>{};
      var changedCount = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final name = (data['name'] as String?)?.trim() ?? '';
        final normalizedName = _normalizeDishName(name);
        final curatedKey =
            legacyToCuratedKey[normalizedName] ??
            (curatedByName.containsKey(normalizedName) ? normalizedName : null);

        if (curatedKey == null) {
          batch.delete(doc.reference);
          changedCount++;
          continue;
        }

        if (keptCuratedKeys.contains(curatedKey)) {
          batch.delete(doc.reference);
          changedCount++;
          continue;
        }

        keptCuratedKeys.add(curatedKey);

        final curatedProduct = curatedByName[curatedKey]!;
        final targetName = curatedProduct['name'] as String? ?? name;
        final targetDescription =
            curatedProduct['description'] as String? ??
            (data['description'] as String? ?? '');
        final targetPrice = (curatedProduct['price'] as num?)?.toDouble();
        final targetImageUrl = _normalizeImageUrl(
          curatedProduct['imageUrl'] as String?,
          targetName,
        );

        final currentDescription = data['description'] as String? ?? '';
        final currentPrice = (data['price'] as num?)?.toDouble();
        final currentImageUrl = data['imageUrl'] as String?;

        final updates = <String, dynamic>{};
        if (name != targetName) {
          updates['name'] = targetName;
        }
        if (currentDescription != targetDescription) {
          updates['description'] = targetDescription;
        }
        if (currentPrice != targetPrice) {
          updates['price'] = targetPrice;
        }
        if (currentImageUrl != targetImageUrl) {
          updates['imageUrl'] = targetImageUrl;
        }

        if (updates.isNotEmpty) {
          batch.update(doc.reference, updates);
          changedCount++;
        }
      }

      for (final product in _top20Products) {
        final productName = product['name'] as String? ?? '';
        final productKey = _normalizeDishName(productName);
        if (!keptCuratedKeys.contains(productKey)) {
          batch.set(_db.collection('foods').doc(), {
            ...product,
            'imageUrl': _normalizeImageUrl(
              product['imageUrl'] as String?,
              productName,
            ),
          });
          changedCount++;
        }
      }

      if (changedCount > 0) {
        await batch.commit();
      }

      return changedCount;
    } catch (e) {
      throw Exception('Failed to enforce top 20 products: $e');
    }
  }

  /// Update existing food documents so image URLs are permanently normalized.
  /// Returns the number of updated documents.
  Future<int> migrateImageUrls() async {
    try {
      final snapshot = await _db.collection('foods').get();
      var updatedCount = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final name = (data['name'] as String?)?.trim() ?? 'food';
        final currentImageUrl = data['imageUrl'] as String?;
        final normalizedUrl = _normalizeImageUrl(currentImageUrl, name);

        if (currentImageUrl != normalizedUrl) {
          await doc.reference.update({'imageUrl': normalizedUrl});
          updatedCount++;
        }
      }

      return updatedCount;
    } catch (e) {
      throw Exception('Failed to migrate image URLs: $e');
    }
  }
}
