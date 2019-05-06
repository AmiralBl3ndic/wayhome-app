import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';


/// Convert an address to a list of addresses
Future<Coordinates> convertAddressToCoordinates(String address) async {
  try {
    List<Address> addresses = await Geocoder.local.findAddressesFromQuery(address);
    return addresses.first.coordinates;
  } on PlatformException {
    throw("Unable to locate this address");
  }
}


