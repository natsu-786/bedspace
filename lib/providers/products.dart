import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './product.dart';

class products with ChangeNotifier {
  List<product> _items = [
  ];
  // var _showFavoritesOnly = false;

  List<product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  product findById(String id) {
    return _items.firstWhere((prod) => prod.uid == id);
  }

  Future<void> addProduact(String uid, product product) async {
    FirebaseFirestore.instance.collection('Product').doc(uid).set( {
      "id": uid,
      "title": product.title,
      "description": product.description,
      "price": product.description,
      "location":product.location
    });
    // need to see this

  }

  void fetchandset() async {
    var data = await FirebaseFirestore
        .instance.collection('Product').get();
    final List<product> loadedProducts = [];
    for (var prodData in data.docs) {
      loadedProducts.add(product(
        uid: 'id',
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'], location: prodData['location'],
      ));
    }
    _items = loadedProducts;
    notifyListeners();
  }
    // var data2=data.then((value) => product(id: value['id'], title: value['title'], description: value['description'], price: value['price'], imageUrl:null));
    // return data2;

  }

  // Future<void> updateProduct(String id, Product newProduct) async {
  //   final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //   if (prodIndex >= 0) {
  //     final url = 'https://flutter-update.firebaseio.com/products/$id.json';
  //     await http.patch(Uri.parse(url),
  //         body: json.encode({
  //           'title': newProduct.title,
  //           'description': newProduct.description,
  //           'imageUrl': newProduct.imageUrl,
  //           'price': newProduct.price
  //         }));
  //     _items[prodIndex] = newProduct;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }
  //
  // Future<void> deleteProduct(String id) async {
  //   final url = 'https://flutter-update.firebaseio.com/products/$id.json';
  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //   var existingProduct = _items[existingProductIndex];
  //   _items.removeAt(existingProductIndex);
  //   notifyListeners();
  //   final response = await http.delete(Uri.parse(url));
  //   if (response.statusCode >= 400) {
  //     _items.insert(existingProductIndex, existingProduct);
  //     notifyListeners();
  //     throw HttpException('Could not delete product.');
  //   }
  //   existingProduct = null;
  // }

