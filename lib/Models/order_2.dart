import 'dart:convert';

enum OrderStatus {
  created,
  confirmed,
  transit,
  delivered,
  laundromart_accepted
}

enum GoingTo { launderer, customer }

enum Phase { pickup, dropoff }

enum Type { Laundry, IronOnly, DryCleaning }

OrderStatus parseOrderStatus(String status) {
  switch (status) {
    case 'order_created':
      return OrderStatus.created;
    case 'laundromart_accepted':
      return OrderStatus.laundromart_accepted;
    default:
      return OrderStatus.created;
  }
}

Type parseType(String type) {
  switch (type) {
    case 'Laundry':
      return Type.Laundry;
    case 'IronOnly':
      return Type.IronOnly;
    case 'DryCleaning':
      return Type.DryCleaning;
    default:
      return Type.Laundry;
  }
}

class Order {
  double distance;
  double deliveryFee;
  int totalItems;
  double weight;
  Type type;
  String orderId;
  String specialInstructions;
  OrderStatus status;
  GoingTo goingTo;
  Phase phase;
  String fromLocationName;
  String toLocationName;
  String fromLocationAddress;
  String toLocationAddress;
  double fromLat;
  double fromLng;
  double toLat;
  double toLng;
  bool ongoing;
  bool warmWater;
  bool scented;

  Order({
    required this.distance,
    required this.deliveryFee,
    required this.totalItems,
    required this.weight,
    required this.type,
    required this.orderId,
    required this.specialInstructions,
    required this.status,
    required this.goingTo,
    required this.phase,
    required this.fromLocationName,
    required this.toLocationName,
    required this.fromLocationAddress,
    required this.toLocationAddress,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.ongoing,
    this.warmWater = false,
    this.scented = false,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final items = json['details']['items'] as Map<String, dynamic>;
    final totalItems = items.values
        .fold(0, (previousValue, element) => previousValue + (element as int));
    final additionalRequests =
        json['details']['additional_requests'] as Map<String, dynamic>?;

    return Order(
      distance: 0.0,
      deliveryFee: 0.0,
      totalItems: totalItems,
      weight: json['details']['weight'].toDouble(),
      type: parseType(json['category']),
      orderId: json['id'].toString(),
      specialInstructions: json['details']['special_instructions'] ?? '',
      status: parseOrderStatus(json['order_status']),
      goingTo: GoingTo.customer,
      phase: Phase.pickup,
      fromLocationName: "Unknown",
      toLocationName: json['customer_address']['full_address'],
      fromLocationAddress: "Unknown",
      toLocationAddress: json['customer_address']['full_address'],
      fromLat: 0.0,
      fromLng: 0.0,
      toLat: json['customer_address']['latitude'].toDouble(),
      toLng: json['customer_address']['longitude'].toDouble(),
      ongoing: false,
      warmWater: additionalRequests?['warm_water'] ?? false,
      scented: additionalRequests?['scented'] ?? false,
    );
  }
}
