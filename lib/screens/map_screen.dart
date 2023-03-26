import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initLocation;
  final bool isSelected;
  MapScreen(
      {this.initLocation = const PlaceLocation(lat: 37.422, long: -122.084),
      this.isSelected = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          if (widget.isSelected)
            IconButton(
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedLocation);
                      },
                icon: const Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initLocation.lat,
            widget.initLocation.long,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelected ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelected)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ?? LatLng( widget.initLocation.lat,  widget.initLocation.long),
                ),
              },
      ),
    );
  }
}
