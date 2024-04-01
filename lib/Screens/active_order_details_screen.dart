import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:action_slider/action_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:geolocator/geolocator.dart';
import '/Screens/dashboard_screen.dart';

import '/Provider/orderprovider.dart';
import '../Models/order_2.dart';
import '/Widgets/datapoint.dart';
import '/Widgets/quantity_input.dart';

class ActiveOrderDetailsScreen extends ConsumerStatefulWidget {
  final int index;
  const ActiveOrderDetailsScreen({Key? key, required this.index})
      : super(key: key);

  @override
  ConsumerState<ActiveOrderDetailsScreen> createState() =>
      _ActiveOrderDetailsScreenState();
}

dynamic weightOfLoad = 10;
double? finalWeightOfLoad;
double? myCurrentLatitude;
double? myCurrentLongitude;

class _ActiveOrderDetailsScreenState
    extends ConsumerState<ActiveOrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  File? _selectedImage;

  void _changeOngoingnewOrderstatus(String orderId, bool newStatus) {
    ref
        .read(orderListProvider.notifier)
        .updateOngoingStatus(orderId, newStatus);
  }

  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    bool isPermissionGranted = await _checkPermission();

    if (isPermissionGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        myCurrentLatitude = position.latitude;
        myCurrentLongitude = position.longitude;
      } catch (e) {
        print(e);
      }
    } else {
      print('Location permission not granted');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  void _changeOngoingnewOrderphase(String orderId, Phase newPhase) {
    ref
        .read(orderListProvider.notifier)
        .updateOngoingPhaseStatus(orderId, newPhase);
  }

  Future<void> _takePicture(VoidCallback onImageSelected) async {
    try {
      final imagePicker = ImagePicker();
      final pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 600);
      if (pickedImage == null) {
        return;
      }
      setState(() {
        _selectedImage = File(pickedImage.path);
        onImageSelected();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _dialogBuilder(
      BuildContext context, String orderId, Phase newPhase, num initialweight) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            Widget cameraContent = Image.asset(
              'assets/camera_icon.jpg',
              height: 32,
              width: 32,
            );

            if (_selectedImage != null) {
              cameraContent = Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            }

            return SizedBox(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    height: newPhase != Phase.dropoff ? 413 : 344,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF723CE8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            newPhase == Phase.pickup
                                ? 'Confirm Pickup'
                                : 'Confirm Dropoff',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (newPhase != Phase.dropoff)
                                    Text(
                                      'Weight of the load',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(),
                                    ),
                                  if (newPhase != Phase.dropoff)
                                    Material(
                                      child: QunatityInput(
                                        initialvalue: initialweight,
                                        minvalue: 10,
                                        quantityChanged: onQuantityChanged,
                                      ),
                                    )
                                ],
                              ),
                              if (newPhase != Phase.dropoff) const Gap(20),
                              if (newPhase != Phase.dropoff)
                                const Divider(
                                  height: 1,
                                  color: Color(0xFF9B9B9B),
                                ),
                              if (newPhase != Phase.dropoff) const Gap(20),
                              Text(
                                'Upload image',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(),
                              ),
                              const Gap(20),
                              GestureDetector(
                                onTap: () async {
                                  _takePicture(() {
                                    setState(() {});
                                  });
                                  setState(() {
                                    cameraContent = _selectedImage != null
                                        ? Image.file(
                                            _selectedImage!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 155,
                                          )
                                        : Image.asset(
                                            'assets/camera_icon.jpg',
                                            height: 32,
                                            width: 32,
                                          );
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 155,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFB5B5B5),
                                        width: 1),
                                  ),
                                  child: cameraContent,
                                ),
                              ),
                              const Gap(20),
                              SizedBox(
                                width: double.infinity,
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFF4C95EF),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      if (newPhase == Phase.pickup) {
                                        _changeOngoingnewOrderphase(
                                            orderId, Phase.dropoff);
                                        _selectedImage = null;
                                        Navigator.of(context).pop();
                                      } else {
                                        _changeOngoingnewOrderstatus(
                                            orderId, false);

                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardScreen(),
                                        ));
                                      }
                                    },
                                    child: Container(
                                      decoration:
                                          const BoxDecoration(boxShadow: [
                                        BoxShadow(
                                          blurRadius: 15,
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.1),
                                        )
                                      ]),
                                      height: 40,
                                      width: 211,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Center(
                                        child: Text(
                                          "Confirm",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void onQuantityChanged(double newQuantity) {
    setState(() {
      finalWeightOfLoad = newQuantity;
      print('finalweightOfLoad = $finalWeightOfLoad');
    });
  }

  String style =
      'feature:poi|visibility:off&style=feature:poi.park|visibility:on&style=feature:transit|visibility:off';
  String mapAPIkey = 'AIzaSyBkGBM8chYfUdEj6j2Wwxj_LV7KTQQMwg0';
  String getStaticMapUrl(
      double latitude, double longitude, int width, int height) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=${width}x$height&maptype=roadmap&markers=color:0x723CE8%7Clabel:C%7C$latitude,$longitude&style=$style&key=$mapAPIkey';
  }

  Future<double> getDistanceBetween(
      double startLat, double startLng, double endLat, double endLng) async {
    final Uri requestUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$mapAPIkey');

    final response = await http.get(requestUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final distanceInMeters = route['legs'][0]['distance']['value'];

        final distanceInKilometers = distanceInMeters / 1000;
        final distanceInMiles = distanceInKilometers * 0.621371;

        return distanceInMiles;
      }
    }
    throw Exception('Failed to load directions');
  }

  Future<void> openMap(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude&travelmode=driving');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final onGoingOrder = ref.watch(ongoingOrderListNotifierNewProvider);
    String mapUrl = '';
    if (onGoingOrder.isNotEmpty) {
      if (onGoingOrder[widget.index].phase == Phase.pickup) {
        mapUrl = getStaticMapUrl(
          onGoingOrder[widget.index].fromLat,
          onGoingOrder[widget.index].fromLng,
          500,
          250,
        );
      } else if (onGoingOrder[widget.index].phase == Phase.dropoff) {
        mapUrl = getStaticMapUrl(
          onGoingOrder[widget.index].toLat,
          onGoingOrder[widget.index].toLng,
          500,
          250,
        );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Image.network(
                  mapUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    if (myCurrentLatitude != null &&
                        myCurrentLongitude != null) {
                      double destinationLatitude;
                      double destinationLongitude;

                      if (onGoingOrder[widget.index].phase == Phase.pickup) {
                        destinationLatitude =
                            onGoingOrder[widget.index].fromLat;
                        destinationLongitude =
                            onGoingOrder[widget.index].fromLng;
                      } else if (onGoingOrder[widget.index].phase ==
                          Phase.dropoff) {
                        destinationLatitude = onGoingOrder[widget.index].toLat;
                        destinationLongitude = onGoingOrder[widget.index].toLng;
                      } else {
                        print('Invalid phase');
                        return;
                      }

                      openMap(
                          //myCurrentLatitude!, THIS IS FOR PRODUCTION
                          45.424800,
                          //myCurrentLongitude!, THIS IS FOR PRODUCTION
                          -75.695950,
                          destinationLatitude,
                          destinationLongitude);
                    } else {
                      print('Current location not available');
                    }
                  },
                  style: ElevatedButton.styleFrom(elevation: 15),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/navigate.svg',
                        color: const Color(0xFF723ce8),
                        height: 15,
                      ),
                      const Gap(10),
                      const Text('Navigate'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(84, 84, 84, 0.1),
                          blurRadius: 10,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/location.svg'),
                                const Gap(10),
                                Text(
                                  onGoingOrder[widget.index].fromLocationName,
                                  style: const TextStyle(
                                    color: Color(0xFF723CE8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Material(
                              color: const Color(0xFFF1ECFD),
                              shape: const CircleBorder(),
                              child: InkWell(
                                onTap: () => _makePhoneCall('8961098088'),
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/phone.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/sample_customer_image.jpg',
                              height: 32,
                              width: 32,
                            ),
                            const Gap(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    onGoingOrder[widget.index].phase ==
                                            Phase.pickup
                                        ? (onGoingOrder[widget.index].goingTo ==
                                                GoingTo.launderer
                                            ? onGoingOrder[widget.index]
                                                .fromLocationName
                                            : onGoingOrder[widget.index]
                                                .toLocationName)
                                        : (onGoingOrder[widget.index].goingTo ==
                                                GoingTo.customer
                                            ? onGoingOrder[widget.index]
                                                .fromLocationName
                                            : onGoingOrder[widget.index]
                                                .toLocationName),
                                  ),
                                  Text(
                                    onGoingOrder[widget.index].phase ==
                                            Phase.pickup
                                        ? (onGoingOrder[widget.index].goingTo ==
                                                GoingTo.launderer
                                            ? onGoingOrder[widget.index]
                                                .fromLocationAddress
                                            : onGoingOrder[widget.index]
                                                .toLocationAddress)
                                        : (onGoingOrder[widget.index].goingTo ==
                                                GoingTo.launderer
                                            ? onGoingOrder[widget.index]
                                                .toLocationAddress
                                            : onGoingOrder[widget.index]
                                                .fromLocationAddress),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF747474),
                                          fontSize: 12,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(84, 84, 84, 0.1),
                          blurRadius: 10,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Special Instruction',
                          style: TextStyle(
                              color: Color(0xFF723CE8),
                              fontWeight: FontWeight.bold),
                        ),
                        const Gap(10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: onGoingOrder[widget.index]
                                        .specialInstructions
                                        .isNotEmpty
                                    ? Text(onGoingOrder[widget.index]
                                        .specialInstructions)
                                    : Text("No special instructions provided"))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(84, 84, 84, 0.1),
                          blurRadius: 10,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DataPoint(
                                      label: 'Distance: ',
                                      value:
                                          '${onGoingOrder[widget.index].distance} mi'),
                                  const Gap(3),
                                  DataPoint(
                                      label: 'Delivery fee: ',
                                      value:
                                          '\$${onGoingOrder[widget.index].deliveryFee}'),
                                  const Gap(3),
                                  DataPoint(
                                      label: 'Total Items: ',
                                      value:
                                          '${onGoingOrder[widget.index].totalItems}'),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DataPoint(
                                      label: 'Weight: ',
                                      value: finalWeightOfLoad == null
                                          ? '${onGoingOrder[widget.index].weight} pounds'
                                          : '$finalWeightOfLoad pounds'),
                                  const Gap(3),
                                  DataPoint(
                                      label: 'Type: ',
                                      value:
                                          '${onGoingOrder[widget.index].type}'
                                              .substring(5)),
                                  const Gap(3),
                                  DataPoint(
                                      label: 'Order ID: ',
                                      value:
                                          onGoingOrder[widget.index].orderId),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                  ActionSlider.standard(
                    action: (controller) async {
                      _dialogBuilder(
                          context,
                          onGoingOrder[widget.index].orderId,
                          onGoingOrder[widget.index].phase,
                          onGoingOrder[widget.index].weight);

                      await Future(
                          await Future.delayed(const Duration(seconds: 3)));
                      controller.success();
                    },
                    toggleColor: Colors.green,
                    sliderBehavior: SliderBehavior.stretch,
                    child: Text(
                      onGoingOrder[widget.index].phase == Phase.pickup
                          ? (onGoingOrder[widget.index].goingTo ==
                                  GoingTo.launderer
                              ? 'Pickup order'
                              : 'Dropoff order')
                          : (onGoingOrder[widget.index].goingTo ==
                                  GoingTo.launderer
                              ? 'Dropoff order'
                              : 'Pickup order'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
