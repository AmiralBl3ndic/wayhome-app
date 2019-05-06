import 'dart:math';
import 'package:vector_math/vector_math.dart';

import 'package:geocoder/geocoder.dart';

import 'package:geolocator/geolocator.dart';


const double EARTH_RADIUS = 6371000;


/// Compute the distance between two points on the Earth's surface
/// `start` is a [Coordinate] with `latitude` and `longitude` properties
/// `end` is a [Coordinate] with `latitude` and `longitude` properties
Future<double> distanceBetweenCoordinates(Coordinates start, Coordinates end) async {
  return Geolocator().distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude);
}


/// Compute the distance between two points on the Earth's surface
/// 
/// This method is homemade and should hence not be used primarily
double distanceBetweenCoordinates_homemade(Coordinates start, Coordinates end) {
  double haversine = _computeHaversine(start, end);

  double c = atan2(sqrt(haversine), sqrt(1-haversine));

  return c * EARTH_RADIUS;
}


/// Compute the haversine function for the coordinates that are passed in
double _computeHaversine(Coordinates start, Coordinates end) {
  double latStart  = radians(start.latitude);
  double latEnd    = radians(end.latitude);

  double deltaLat  = radians(end.latitude - start.latitude);
  double deltaLong = radians(end.longitude - start.longitude);


  return sin(deltaLat/2) * sin(deltaLat/2) + cos(latStart) * cos(latEnd) * sin(deltaLong/2) * sin(deltaLong/2);
}
