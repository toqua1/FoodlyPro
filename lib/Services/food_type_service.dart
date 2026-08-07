enum FoodType {
  GRILLED,
  DESSERTS,
  JUICES,
  PASTA,
  SEAFOOD,
  OTHERS,
}

extension FoodTypeExt on FoodType {
  String get apiValue {
    switch (this) {
      case FoodType.GRILLED: return 'GRILLED';
      case FoodType.DESSERTS: return 'DESSERTS';
      case FoodType.JUICES: return 'JUICES';
      case FoodType.PASTA: return 'PASTA';
      case FoodType.SEAFOOD: return 'SEAFOOD';
      case FoodType.OTHERS: return 'OTHERS';
    }
  }
}

String? foodTypeFromArabic(String title) {
  switch (title.trim()) {
    case 'مشويات': return FoodType.GRILLED.apiValue;
    case 'حلويات': return FoodType.DESSERTS.apiValue;
    case 'عصائر': return FoodType.JUICES.apiValue;
    case 'مكرونة': return FoodType.PASTA.apiValue;
    case 'مأكولات بحرية': return FoodType.SEAFOOD.apiValue;
    case 'أخرى': return FoodType.OTHERS.apiValue;
    default: return null; // no foodType filter
  }
}
