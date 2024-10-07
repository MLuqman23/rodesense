import 'package:flutter/material.dart';
import 'package:ridesense/screen/location_screen.dart';

import '../services/location_service.dart';
// import 'map_screen.dart';

class LocationInputScreen extends StatefulWidget {
  const LocationInputScreen({Key? key}) : super(key: key);

  @override
  _LocationInputScreenState createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  final TextEditingController _locationController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _searchResults = [];
  final LocationService _locationService = LocationService();

  void _searchLocation(String query) async {
    if (query.isNotEmpty) {
      var results = await _locationService.searchPlaces(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _locationController.addListener(() {
      _searchLocation(_locationController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
            child: const Text(
          'Enter Location',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              top: 0,
              child: Image.asset('assets/images/location-tracking-gps.jpg')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText:
                          'Enter a location (city, address, or coordinates)',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: _isSearching
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _locationController.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _searchResults.isNotEmpty
                      ? ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final place = _searchResults[index];
                            return ListTile(
                              title: Text(place['display_name']),
                              onTap: () {
                                final lat = double.parse(place['lat']);
                                final lon = double.parse(place['lon']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      lat: lat,
                                      lon: lon,
                                      placeName: place['display_name'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Center(child: Text('Search for a location')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
