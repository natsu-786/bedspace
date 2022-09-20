import 'package:flutter/foundation.dart';

class product with ChangeNotifier {
  final String? uid;
  final String? title;
  final String? description;
  final String? price;
  final String? location;
  bool isFavorite;
  product({
    @required this.uid,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.location,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
