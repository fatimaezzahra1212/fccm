import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fccm/clients/client.dart';

class mapsi extends StatefulWidget {
  @override
  _mapsiState createState() => _mapsiState();
}

class _mapsiState extends State<mapsi> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text('Maps Sample App'),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10.0,
              ),
              mapType: _currentMapType,
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: _onMapTypeButtonPressed,
              label: Text('Map Type'),
              icon: Icon(Icons.map),
              backgroundColor: secondaryColor,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                Position position = await _determinePosition();

                (await _controller.future).animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 14)));

                setState(() {
                  _addMarker(position.latitude, position.longitude);
                });
              },
              label: const Text("Current Location"),
              icon: const Icon(Icons.location_history),
              backgroundColor: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  void _addMarker(double lat, double lng) {
    setState(() {
      Marker marker = Marker(
          markerId: MarkerId('currentLocation'), position: LatLng(lat, lng));
      markers.clear();
      markers.add(marker);
    });
  }

  Set<Marker> markers = {};
}
