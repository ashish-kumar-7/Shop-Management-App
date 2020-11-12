import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Black Tea',
      description: 'Boost Heart Health',
      price: 30.00,
      imageUrl:
          'https://images.pexels.com/photos/131893/pexels-photo-131893.jpeg?cs=srgb&dl=pexels-brigitte-tohm-131893.jpg&fm=jpg',
    ),
    Product(
      id: 'p2',
      title: 'Coffee',
      description: 'Awakes you up.',
      price: 50.00,
      imageUrl:
          'https://images.pexels.com/photos/2396220/pexels-photo-2396220.jpeg?cs=srgb&dl=pexels-tyler-nix-2396220.jpg&fm=jpg',
    ),
    Product(
      id: 'p3',
      title: 'Green Tea',
      description: 'Refreshing',
      price: 25.00,
      imageUrl:
          'https://images.pexels.com/photos/1417945/pexels-photo-1417945.jpeg?cs=srgb&dl=pexels-mareefe-1417945.jpg&fm=jpg',
    ),
    Product(
      id: 'p4',
      title: 'Juice',
      description: 'Healthy.',
      price: 40.00,
      imageUrl:
          'https://images.all-free-download.com/images/graphiclarge/orange_juice_juice_vitamins_214310.jpg',
    ),
    Product(
      id: 'p7',
      title: 'Milk Shake',
      description: 'Refreshing',
      price: 50.00,
      imageUrl:
          'https://images.pexels.com/photos/2424832/pexels-photo-2424832.jpeg?cs=srgb&dl=pexels-genaro-serv%C3%ADn-2424832.jpg&fm=jpg',
    ),
    Product(
      id: 'p8',
      title: 'Pizza',
      description: 'Cheesy',
      price: 50.00,
      imageUrl:
          'https://images.pexels.com/photos/708587/pexels-photo-708587.jpeg?cs=srgb&dl=pexels-sydney-troxell-708587.jpg&fm=jpg',
    ),
    Product(
      id: 'p5',
      title: 'Cookies',
      description: 'Tasty and Yummy Snack',
      price: 25.00,
      imageUrl:
          'https://images.pexels.com/photos/890577/pexels-photo-890577.jpeg?cs=srgb&dl=pexels-oleg-magni-890577.jpg&fm=jpg',
    ),
    Product(
      id: 'p6',
      title: 'Cake',
      description: 'Everyone love/s to eat this ',
      price: 29.99,
      imageUrl:
          'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg?cs=srgb&dl=pexels-daria-shevtsova-1070850.jpg&fm=jpg',
    ),
  ];
  //var _showFavoritesOnly = false;

  List<Product> get items {
    //if (_showFavoritesOnly) {
    //  return _items.where((prodItem) => prodItem.isFavorite).toList();
    //}
    return [..._items];
  }

  List<Product> get favoriteItems{
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

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(), 
       );
    _items.add(newProduct);
    //_items.insert(0, newProduct);
    notifyListeners();
  }

  void updateProduct(String  id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
    notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}