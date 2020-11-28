import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    //Product(
    // id: 'p1',
    //title: 'Black Tea',
    //  description: 'Boost Heart Health',
    //  price: 30.00,
    // imageUrl:
    //       'https://images.pexels.com/photos/131893/pexels-photo-131893.jpeg?cs=srgb&dl=pexels-brigitte-tohm-131893.jpg&fm=jpg',
    //   ),
    //Product(
    //    id: 'p2',
    // title: 'Coffee',
    //   description: 'Awakes you up.',
    //price: 50.00,
    //  imageUrl:
    //        'https://images.pexels.com/photos/2396220/pexels-photo-2396220.jpeg?cs=srgb&dl=pexels-tyler-nix-2396220.jpg&fm=jpg',
//    ),
    //Product(
    //   id: 'p3',
    //  title: 'Green Tea',
    //description: 'Refreshing',
    //  price: 25.00,
    //    imageUrl:
//          'https://images.pexels.com/photos/1417945/pexels-photo-1417945.jpeg?cs=srgb&dl=pexels-mareefe-1417945.jpg&fm=jpg',
    // ),
    //   Product(
    //id: 'p4',
    //  title: 'Juice',
    //    description: 'Healthy.',
//      price: 40.00,
    //imageUrl:
    //      'https://images.all-free-download.com/images/graphiclarge/orange_juice_juice_vitamins_214310.jpg',
    //  ),
//    Product(
    //id: 'p7',
    //  title: 'Milk Shake',
    //    description: 'Refreshing',
//      price: 50.00,
    // imageUrl:
    //       'https://images.pexels.com/photos/2424832/pexels-photo-2424832.jpeg?cs=srgb&dl=pexels-genaro-serv%C3%ADn-2424832.jpg&fm=jpg',
    //),
    //  Product(
    //id: 'p8',
    //title: 'Pizza',
    //  description: 'Cheesy',
    //    price: 50.00,
//      imageUrl:
    //    'https://images.pexels.com/photos/708587/pexels-photo-708587.jpeg?cs=srgb&dl=pexels-sydney-troxell-708587.jpg&fm=jpg',
    //),
    //Product(
    //id: 'p5',
    //title: 'Cookies',
    //description: 'Tasty and Yummy Snack',
    // price: 25.00,
    //  imageUrl:
    //      'https://images.pexels.com/photos/890577/pexels-photo-890577.jpeg?cs=srgb&dl=pexels-oleg-magni-890577.jpg&fm=jpg',
    //),
    //Product(
    //id: 'p6',
    //  title: 'Cake',
    // description: 'Everyone love/s to eat this ',
    //  price: 29.99,
    //  imageUrl:
    //    'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg?cs=srgb&dl=pexels-daria-shevtsova-1070850.jpg&fm=jpg',
    //),
  ];
  //var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    //if (_showFavoritesOnly) {
    //  return _items.where((prodItem) => prodItem.isFavorite).toList();
    //}
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //void showFavoritesOnly() {
  //  _showFavoritesOnly = true;
  //  notifyListeners();
  //}

  //void showAll() {
  //  _showFavoritesOnly = false;
  //  notifyListeners();
  //}

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-update-72.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extracteddata = json.decode(response.body) as Map<String, dynamic>;
      if (extracteddata == null) {
        return;
      }
      url =
          'https://flutter-update-72.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extracteddata.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-update-72.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorID': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-update-72.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update-72.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product');
    }
    existingProduct = null;
  }
}
