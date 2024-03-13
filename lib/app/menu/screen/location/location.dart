import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationApp extends StatefulWidget {
  const GeolocationApp({super.key});

  @override
  State<GeolocationApp> createState() => _GeolocationAppState();
}

class _GeolocationAppState extends State<GeolocationApp> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAdress = "";
  @override
  Widget build(BuildContext context) {
    Future<Position> getCurrentLocation() async {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        const Text("Service location disable");
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return await Geolocator.getCurrentPosition();
    }

    getAdressFromCoordinates() async {
      try {
        List<Placemark> placemark = await placemarkFromCoordinates(
            _currentLocation!.latitude, _currentLocation!.longitude);

        Placemark place = placemark[0];

        setState(() {
          _currentAdress = "${place.locality}, ${place.country}";
        });
      } catch (e) {
        debugPrint("$e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Get User Location"),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Location Coordinates",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            // const Text(
            //     "Latitude = ${_currentLocation?.latitude} Longitud = ${_currentLocation?.longitude}"),
            const SizedBox(
              height: 6,
            ),
            const Text(
              "Location Adress",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(_currentAdress),
            const SizedBox(
              height: 6,
            ),
            ElevatedButton(
                onPressed: () async {
                  _currentLocation = await getCurrentLocation();
                  await getAdressFromCoordinates();

                  Text("$_currentLocation");
                  debugPrint("test here");
                },
                child: const Text("Get location"))
          ],
        ),
      ),
    );
  }
}
