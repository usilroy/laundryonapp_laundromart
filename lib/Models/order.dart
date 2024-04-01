class Order {
  final int id;
  final String category;
  final OrderDetails details;
  final String pickupTime;
  final String dropoffTime;
  final CustomerAddress customerAddress;
  final dynamic laundromartAddress;
  final dynamic pickupDriverId;
  final dynamic dropoffDriverId;
  final dynamic orderPayment;
  final String orderStatus;
  final Map<String, dynamic> orderMeta;
  final String paymentStatus;
  final String createdAt;
  final String updatedAt;
  final dynamic deletedAt;

  Order({
    required this.id,
    required this.category,
    required this.details,
    required this.pickupTime,
    required this.dropoffTime,
    required this.customerAddress,
    this.laundromartAddress,
    this.pickupDriverId,
    this.dropoffDriverId,
    this.orderPayment,
    required this.orderStatus,
    required this.orderMeta,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        category: json['category'],
        details: OrderDetails.fromJson(json['details']),
        pickupTime: json['pickup_time'],
        dropoffTime: json['dropoff_time'],
        customerAddress: CustomerAddress.fromJson(json['customer_address']),
        laundromartAddress: json['laundromart_address'],
        pickupDriverId: json['pickup_driver_id'],
        dropoffDriverId: json['dropoff_driver_id'],
        orderPayment: json['order_payment'],
        orderStatus: json['order_status'],
        orderMeta: Map<String, dynamic>.from(json['order_meta']),
        paymentStatus: json['payment_status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        deletedAt: json['deleted_at'],
      );
}

class OrderDetails {
  final double weight;
  final Map<String, int> items;
  final AdditionalRequests additionalRequests;
  final dynamic specialInstructions;

  OrderDetails({
    required this.weight,
    required this.items,
    required this.additionalRequests,
    this.specialInstructions,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        weight: json['weight'].toDouble(),
        items: Map<String, int>.from(json['items']),
        additionalRequests:
            AdditionalRequests.fromJson(json['additional_requests']),
        specialInstructions: json['special_instructions'],
      );
}

class AdditionalRequests {
  final bool warmWater;

  AdditionalRequests({
    required this.warmWater,
  });

  factory AdditionalRequests.fromJson(Map<String, dynamic> json) =>
      AdditionalRequests(
        warmWater: json['warm_water'],
      );
}

class CustomerAddress {
  final String landmark;
  final double latitude;
  final double longitude;
  final String buzzerCode;
  final String addressType;
  final String fullAddress;
  final String deliveryDoor;

  CustomerAddress({
    required this.landmark,
    required this.latitude,
    required this.longitude,
    required this.buzzerCode,
    required this.addressType,
    required this.fullAddress,
    required this.deliveryDoor,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
        landmark: json['landmark'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        buzzerCode: json['buzzer_code'],
        addressType: json['address_type'],
        fullAddress: json['full_address'],
        deliveryDoor: json['delivery_door'],
      );
}
