import 'package:geolocator/geolocator.dart';

/// Auto formats a Placemark to a readable address with the street number, the street name, the postal code and the locality
String formatAddress(Placemark pm) {
  return "${pm.name} ${pm.thoroughfare}, ${pm.postalCode} ${pm.locality}";
}
