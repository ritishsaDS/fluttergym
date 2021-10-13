import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../shared/common.dart';

class GymMap extends StatefulWidget {
  const GymMap({
    this.address,
    this.olc,
    Key? key,
  }) : super(key: key);

  final String? address;
  final String? olc;

  @override
  State<GymMap> createState() => _GymMapState();
}

class _GymMapState extends State<GymMap> {
  LatLng? position;
  static const _centralStation = LatLng(23.18, 82.5);

  @override
  void initState() {
    super.initState();
    if (widget.olc != null && isValid(widget.olc!)) {
      position = decode(widget.olc!).center;
    }
    if (position == null && widget.address != null) {
      locationFromAddress(widget.address!).then((list) {
        if (list.isNotEmpty) {
          var first = list.first;
          position = LatLng(first.latitude, first.longitude);
        }
      });
    }
    position ??= _centralStation;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: {
        Marker(markerId: const MarkerId('default'), position: position!)
      },
      initialCameraPosition: CameraPosition(
        target: position!,
        zoom: 11,
      ),
    );
  }
}
