
// Helper method to create dummy product models for the skeleton
import 'package:elmaleka_kitchen_project/data/models/category_model.dart';

import '../../data/models/product_model.dart';

List<ProductModel> getDummyProducts(int count) {
  return List.generate(count, (index) =>
      ProductModel(
        id: index,
        name: 'Dummy Product Name',
        description: 'Dummy description for the product placeholder.',
        price: 100.0,
        isAvailable: true,
        categoryId: 1,
        foodType: 'Famous',
        createdAt: DateTime.now(),
        ratingAverage: 0,
        ratingCount: 0,
        imageUrl: 'lib/assets/images/cart-removebg-preview.png', category:
      CategoryModel(id: 0, name: 'xx', imageUrl: '', createdAt:DateTime.now()),
      ));
}