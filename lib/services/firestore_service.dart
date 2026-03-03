import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _buildFallbackImageUrl(String seed) {
    final safeSeed = seed.trim().isEmpty ? 'food' : seed.trim();
    return 'https://picsum.photos/seed/${Uri.encodeComponent(safeSeed)}/600/400';
  }

  String _normalizeImageUrl(String? imageUrl, String fallbackSeed) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return _buildFallbackImageUrl(fallbackSeed);
    }

    final uri = Uri.tryParse(imageUrl);
    final host = uri?.host.toLowerCase() ?? '';
    if (host.contains('wikimedia.org') || host.contains('wikipedia.org')) {
      return _buildFallbackImageUrl(fallbackSeed);
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
      final List<Map<String, dynamic>> sampleFoods = [
        {
          'name': 'Phở Bò',
          'description': 'Phở bò tái, nước dùng đậm đà, bánh phở mềm',
          'price': 3.5,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Pho-Beef-Noodles.jpg/1280px-Pho-Beef-Noodles.jpg',
        },
        {
          'name': 'Cơm Tấm',
          'description': 'Tấm sườn nạc chiên, trứng, rau sống',
          'price': 2.8,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Com_tam_bi_sao_%28Vietnamese_broken_rice%29.JPG/1280px-Com_tam_bi_sao_%28Vietnamese_broken_rice%29.JPG',
        },
        {
          'name': 'Bánh Mì',
          'description': 'Bánh mì thập cẩm với pâté, chả, rau cà chua',
          'price': 1.5,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/BanhMi.jpg/1280px-BanhMi.jpg',
        },
        {
          'name': 'Hủ Tiếu',
          'description': 'Hủ tiếu sứa, cua, tôm, giá sống',
          'price': 3.0,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Hu_tieu_Nam_Vang.jpg/1280px-Hu_tieu_Nam_Vang.jpg',
        },
        {
          'name': 'Bún Chả',
          'description': 'Bún tươi, thịt nạc chiên, nước mắm, dưa leo',
          'price': 2.5,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Bun_cha_Ha_Noi-XE.jpg/1280px-Bun_cha_Ha_Noi-XE.jpg',
        },
        {
          'name': 'Gỏi Cuốn',
          'description': 'Gỏi cuốn tôm thịt, rau thơm, bún tươi',
          'price': 2.0,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Goi_cuon.jpg/1280px-Goi_cuon.jpg',
        },
        {
          'name': 'Bánh Xèo',
          'description': 'Bánh xèo tôm thịt, giá, rau sống',
          'price': 2.2,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Banh_xeo.jpg/1280px-Banh_xeo.jpg',
        },
        {
          'name': 'Cao Lầu',
          'description': 'Cao lầu Hội An, mì đặc biệt, thịt xá xíu',
          'price': 3.2,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Cao_lau.jpg/1280px-Cao_lau.jpg',
        },
        {
          'name': 'Mì Quảng',
          'description': 'Mì Quảng tôm thịt, trứng cút, bánh tráng',
          'price': 2.9,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Mi_quang.jpg/1280px-Mi_quang.jpg',
        },
        {
          'name': 'Bún Bò Huế',
          'description': 'Bún bò giò heo, nước dùng cay nồng',
          'price': 3.3,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Bun-Bo-Hue-from-Huong-Giang-2011.jpg/1280px-Bun-Bo-Hue-from-Huong-Giang-2011.jpg',
        },
        {
          'name': 'Chả Giò',
          'description': 'Chả giò tôm thịt chiên giòn',
          'price': 2.4,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Cha_gio_1.jpg/1280px-Cha_gio_1.jpg',
        },
        {
          'name': 'Cháo Lòng',
          'description': 'Cháo lòng heo, tiết, giò',
          'price': 2.1,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Chao_long.jpg/1280px-Chao_long.jpg',
        },
        {
          'name': 'Bánh Cuốn',
          'description': 'Bánh cuốn thịt, nấm, chả lụa',
          'price': 2.0,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Banh_Cuon.jpg/1280px-Banh_Cuon.jpg',
        },
        {
          'name': 'Bánh Bột Lọc',
          'description': 'Bánh bột lọc tôm, thịt, bọc lá chuối',
          'price': 1.8,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Banh_bot_loc_tran.jpg/1280px-Banh_bot_loc_tran.jpg',
        },
        {
          'name': 'Xôi Gà',
          'description': 'Xôi nếp gà xé, hành phi, nước tương',
          'price': 2.3,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Sticky_rice_-_Vietnam.jpg/1280px-Sticky_rice_-_Vietnam.jpg',
        },
        {
          'name': 'Bánh Căn',
          'description': 'Bánh căn Nha Trang, trứng cút, tôm khô',
          'price': 1.9,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Banh_can.jpg/1280px-Banh_can.jpg',
        },
        {
          'name': 'Bún Riêu',
          'description': 'Bún riêu cua, cà chua, đậu hũ',
          'price': 2.7,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Bun_rieu.jpg/1280px-Bun_rieu.jpg',
        },
        {
          'name': 'Nem Nướng',
          'description': 'Nem nướng Nha Trang, bánh tráng, rau xanh',
          'price': 2.6,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Nem_nuong.jpg/1280px-Nem_nuong.jpg',
        },
        {
          'name': 'Cơm Gà',
          'description': 'Cơm gà xối mỡ, hành lá, nước tương',
          'price': 3.0,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Com_ga_Hoi_An.jpg/1280px-Com_ga_Hoi_An.jpg',
        },
        {
          'name': 'Bánh Bèo',
          'description': 'Bánh bèo Huế, tôm khô, mỡ hành',
          'price': 1.7,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Banh_beo.jpg/1280px-Banh_beo.jpg',
        },
        {
          'name': 'Bún Thịt Nướng',
          'description': 'Bún thịt nướng, chả giò, rau sống',
          'price': 2.8,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Bun_thit_nuong.jpg/1280px-Bun_thit_nuong.jpg',
        },
        {
          'name': 'Lẩu Thái',
          'description': 'Lẩu Thái tôm, mực, nấm, rau',
          'price': 5.5,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Tom_yum_kung_maenam.jpg/1280px-Tom_yum_kung_maenam.jpg',
        },
        {
          'name': 'Bánh Tráng Trộn',
          'description': 'Bánh tráng trộn trứng cút, bò khô',
          'price': 1.5,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Banh_trang_tron.jpg/1280px-Banh_trang_tron.jpg',
        },
        {
          'name': 'Bánh Đúc',
          'description': 'Bánh đúc tôm thịt, nước mắm ngọt',
          'price': 1.6,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Banh_duc.jpg/1280px-Banh_duc.jpg',
        },
        {
          'name': 'Cà Phê Sữa Đá',
          'description': 'Cà phê phin truyền thống, sữa đặc',
          'price': 1.2,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Ca_phe_sua_da.jpg/1280px-Ca_phe_sua_da.jpg',
        },
        {
          'name': 'Chè Ba Màu',
          'description': 'Chè đậu xanh, đậu đỏ, thạch, nước cốt dừa',
          'price': 1.4,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Che_ba_mau.jpg/1280px-Che_ba_mau.jpg',
        },
        {
          'name': 'Bánh Flan',
          'description': 'Bánh flan caramen truyền thống',
          'price': 1.3,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Flan_de_huevo.jpg/1280px-Flan_de_huevo.jpg',
        },
        {
          'name': 'Bánh Chưng',
          'description': 'Bánh chưng gạo nếp, đậu xanh, thịt heo',
          'price': 2.5,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Banh_chung_2.jpg/1280px-Banh_chung_2.jpg',
        },
        {
          'name': 'Nem Chua',
          'description': 'Nem chua Thanh Hóa, thịt lợn ủ chua',
          'price': 1.8,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Nem_chua.jpg/1280px-Nem_chua.jpg',
        },
        {
          'name': 'Bò Kho',
          'description': 'Bò kho bánh mì, nước sốt đậm đà',
          'price': 3.2,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Bo_kho.jpg/1280px-Bo_kho.jpg',
        },
        {
          'name': 'Mực Xào Sa Tế',
          'description': 'Mực tươi xào sa tế cay nồng',
          'price': 4.5,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Squid_with_satay_sauce.jpg/1280px-Squid_with_satay_sauce.jpg',
        },
        {
          'name': 'Tôm Rim',
          'description': 'Tôm rim nước dừa thơm ngon',
          'price': 4.2,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Tom_rim.jpg/1280px-Tom_rim.jpg',
        },
        {
          'name': 'Ốc Hương',
          'description': 'Ốc hương hấp xả, gừng tươi',
          'price': 3.8,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Oc_huong.jpg/1280px-Oc_huong.jpg',
        },
        {
          'name': 'Bún Đậu Mắm Tôm',
          'description': 'Bún đậu, chả cốm, mắm tôm đặc',
          'price': 2.9,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/Bun_dau_mam_tom.jpg/1280px-Bun_dau_mam_tom.jpg',
        },
        {
          'name': 'Sườn Nướng',
          'description': 'Sườn nướng mật ong, cơm trắng',
          'price': 3.7,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Grilled_pork_ribs.jpg/1280px-Grilled_pork_ribs.jpg',
        },
        {
          'name': 'Gà Nướng Mắm Nêm',
          'description': 'Gà nướng mắm nêm, rau xanh',
          'price': 4.0,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Grilled_chicken.jpg/1280px-Grilled_chicken.jpg',
        },
        {
          'name': 'Thịt Kho Tàu',
          'description': 'Thịt kho trứng, nước dừa thơm',
          'price': 2.8,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Thit_kho.jpg/1280px-Thit_kho.jpg',
        },
        {
          'name': 'Canh Chua Cá',
          'description': 'Canh chua cá lóc, cà chua, thơm',
          'price': 3.1,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Canh_chua_ca.jpg/1280px-Canh_chua_ca.jpg',
        },
        {
          'name': 'Rau Muống Xào',
          'description': 'Rau muống xào tỏi giòn ngon',
          'price': 1.5,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Water_spinach.jpg/1280px-Water_spinach.jpg',
        },
        {
          'name': 'Cá Kho Tộ',
          'description': 'Cá kho tộ nước dừa, ớt',
          'price': 3.4,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Ca_kho_to.jpg/1280px-Ca_kho_to.jpg',
        },
        {
          'name': 'Bánh Bao',
          'description': 'Bánh bao nhân thịt, trứng muối',
          'price': 1.6,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Banh_bao.jpg/1280px-Banh_bao.jpg',
        },
        {
          'name': 'Bánh Pía',
          'description': 'Bánh pía đậu xanh Sóc Trăng',
          'price': 1.4,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Banh_pia.jpg/1280px-Banh_pia.jpg',
        },
        {
          'name': 'Bánh Tét',
          'description': 'Bánh tét miền Tây, nhân đậu xanh',
          'price': 2.3,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Banh_tet.jpg/1280px-Banh_tet.jpg',
        },
        {
          'name': 'Bún Mọc',
          'description': 'Bún mọc nấm hương, thịt viên',
          'price': 2.6,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Bun_moc.jpg/1280px-Bun_moc.jpg',
        },
        {
          'name': 'Bánh Khọt',
          'description': 'Bánh khọt Vũng Tàu, tôm tươi',
          'price': 2.1,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Banh_khot.jpg/1280px-Banh_khot.jpg',
        },
        {
          'name': 'Bò Bía',
          'description': 'Bò bía Sài Gòn, rau sống cuốn',
          'price': 1.9,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Bo_bia.jpg/1280px-Bo_bia.jpg',
        },
        {
          'name': 'Bánh Canh Cua',
          'description': 'Bánh canh cua đồng, nước trong',
          'price': 3.0,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Banh_canh_cua.jpg/1280px-Banh_canh_cua.jpg',
        },
        {
          'name': 'Bánh Ít Trần',
          'description': 'Bánh ít trần nhân dừa ngọt',
          'price': 1.7,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Banh_it_tran.jpg/1280px-Banh_it_tran.jpg',
        },
        {
          'name': 'Hủ Tiếu Nam Vang',
          'description': 'Hủ tiếu Nam Vang tôm thịt đặc biệt',
          'price': 3.3,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Hu_tieu_Nam_Vang.jpg/1280px-Hu_tieu_Nam_Vang.jpg',
        },
        {
          'name': 'Chè Bưởi',
          'description': 'Chè bưởi trân châu, nước cốt dừa',
          'price': 1.6,
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Che_buoi.jpg/1280px-Che_buoi.jpg',
        },
      ];

      for (final food in sampleFoods) {
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
}
