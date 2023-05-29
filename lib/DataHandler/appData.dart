import 'package:flutter/material.dart';
import 'package:users_app/models/address.dart';

class AppData extends ChangeNotifier {
  Address? pickUpLocation;
  Address? dropOffLocation;
  void updatePickUpLocationAddress(Address pickupAddress) {
    pickUpLocation = pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
