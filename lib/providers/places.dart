import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/place.dart';
import '../helpers/location_helper.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  void addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    final address =
        await LocationHepler.getPlaceAddress(location.lat, location.long);
    final updatedLocation =
        PlaceLocation(lat: location.lat, long: location.long, address: address);
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: updatedLocation,
    );

    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.lat,
      'loc_long': newPlace.location.long,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              location: PlaceLocation(
                lat: item['loc_lat'],
                long: item['loc_long'],
                address: item['address'],
              ),
              image: File(item['image']),
            ))
        .toList();

    notifyListeners();
  }
}
