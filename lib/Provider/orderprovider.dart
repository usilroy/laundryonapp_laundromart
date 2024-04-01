import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/order_2.dart';
import '../API_calls/get_created_orders.dart';

class OrderListNotifier extends StateNotifier<List<Order>> {
  OrderListNotifier() : super([]) {
    state = dummyOrders;
  }

  void addOrder(Order order) {
    state = [...state, order];
  }

  void updateOrder(String orderId, Order updatedOrder) {
    state = [
      for (final order in state)
        if (order.orderId == orderId) updatedOrder else order,
    ];
  }

  void removeOrder(String orderId) {
    state = state.where((order) => order.orderId != orderId).toList();
  }

  void updateOngoingStatus(String orderId, bool newStatus) {
    state = state.map((order) {
      if (order.orderId == orderId) {
        return Order(
          distance: order.distance,
          deliveryFee: order.deliveryFee,
          totalItems: order.totalItems,
          weight: order.weight,
          type: order.type,
          orderId: order.orderId,
          specialInstructions: order.specialInstructions,
          status: order.status,
          goingTo: order.goingTo,
          phase: order.phase,
          fromLocationName: order.fromLocationName,
          toLocationName: order.toLocationName,
          fromLocationAddress: order.fromLocationAddress,
          toLocationAddress: order.toLocationAddress,
          fromLat: order.fromLat,
          fromLng: order.fromLng,
          toLat: order.toLat,
          toLng: order.toLng,
          ongoing: newStatus,
        );
      } else {
        return order;
      }
    }).toList();
  }

  void updateOngoingPhaseStatus(String orderId, Phase newPhase) {
    state = state.map((order) {
      if (order.orderId == orderId) {
        return Order(
          distance: order.distance,
          deliveryFee: order.deliveryFee,
          totalItems: order.totalItems,
          weight: order.weight,
          type: order.type,
          orderId: order.orderId,
          specialInstructions: order.specialInstructions,
          status: order.status,
          goingTo: order.goingTo,
          phase: newPhase,
          fromLocationName: order.fromLocationName,
          toLocationName: order.toLocationName,
          fromLocationAddress: order.fromLocationAddress,
          toLocationAddress: order.toLocationAddress,
          fromLat: order.fromLat,
          fromLng: order.fromLng,
          toLat: order.toLat,
          toLng: order.toLng,
          ongoing: order.ongoing,
        );
      } else {
        return order;
      }
    }).toList();
  }
}

final orderListProvider =
    StateNotifierProvider<OrderListNotifier, List<Order>>((ref) {
  return OrderListNotifier();
});

final dummyOrders = [
  Order(
    distance: 10.5,
    deliveryFee: 3.50,
    totalItems: 4,
    weight: 15,
    type: Type.Laundry,
    orderId: "ORD001",
    specialInstructions: "Handle with care",
    status: OrderStatus.transit,
    goingTo: GoingTo.customer,
    phase: Phase.pickup,
    fromLocationName: "Downtown Laundry",
    toLocationName: "John Doe's Home",
    fromLocationAddress:
        "123 Anytown, USA 12345, Main Street 1234 Elm Street, Cityville, USA, 123 Road 345600, new place",
    toLocationAddress: "456 Suburb Ln, Cityville",
    fromLat: 43.651070,
    fromLng: -79.347015,
    toLat: 43.700110,
    toLng: -79.416300,
    ongoing: false,
  ),
  Order(
    distance: 6.8,
    deliveryFee: 2.75,
    totalItems: 3,
    weight: 26,
    type: Type.Laundry,
    orderId: "ORD006",
    specialInstructions:
        "Please ring the doorbell twice and wait for 2 minutes before leaving. Leave the package at the front desk of the apartment building and notify me via text.",
    status: OrderStatus.created,
    goingTo: GoingTo.launderer,
    phase: Phase.pickup,
    fromLocationName: "Mani Gill",
    toLocationName: "The Eco Cleaners",
    fromLocationAddress: "12 Valley Rd, Springtown",
    toLocationAddress: "34 Main St, Springtown",
    fromLat: 45.421530,
    fromLng: -75.697193,
    toLat: 45.429578,
    toLng: -75.694258,
    ongoing: false,
  ),
  Order(
    distance: 4.5,
    deliveryFee: 1.95,
    totalItems: 2,
    weight: 18,
    type: Type.IronOnly,
    orderId: "ORD007",
    specialInstructions: "Light starch on shirts",
    status: OrderStatus.confirmed,
    goingTo: GoingTo.customer,
    phase: Phase.pickup,
    fromLocationName: "Iron Fast Service",
    toLocationName: "Olivia's Apartment",
    fromLocationAddress: "56 Ironside Ave, Ironville",
    toLocationAddress: "789 Apartment Way, Ironville",
    fromLat: 43.653225,
    fromLng: -79.383186,
    toLat: 43.655600,
    toLng: -79.381700,
    ongoing: false,
  ),
  Order(
    distance: 9.2,
    deliveryFee: 3.25,
    totalItems: 5,
    weight: 21,
    type: Type.DryCleaning,
    orderId: "ORD008",
    specialInstructions: "Extra care for silk garments",
    status: OrderStatus.transit,
    goingTo: GoingTo.customer,
    phase: Phase.pickup,
    fromLocationName: "Prestige Dry Cleaners",
    toLocationName: "Mark's Residence",
    fromLocationAddress: "123 Prestige Blvd, Clean City",
    toLocationAddress: "321 Home Street, Clean City",
    fromLat: 49.282730,
    fromLng: -123.120735,
    toLat: 49.280700,
    toLng: -123.115000,
    ongoing: false,
  ),
  Order(
    distance: 5.6,
    deliveryFee: 2.50,
    totalItems: 4,
    weight: 32,
    type: Type.Laundry,
    orderId: "ORD009",
    specialInstructions: "Fold all items neatly",
    status: OrderStatus.delivered,
    goingTo: GoingTo.customer,
    phase: Phase.pickup,
    fromLocationName: "Sunny Laundry",
    toLocationName: "Julia's Cottage",
    fromLocationAddress: "45 Sunshine Ave, Sunnyside",
    toLocationAddress: "678 Cottage Lane, Sunnyside",
    fromLat: 53.546125,
    fromLng: -113.493823,
    toLat: 53.540600,
    toLng: -113.490000,
    ongoing: false,
  ),
  Order(
    distance: 7.1,
    deliveryFee: 2.80,
    totalItems: 6,
    weight: 28,
    type: Type.DryCleaning,
    orderId: "ORD010",
    specialInstructions: "Press all trousers",
    status: OrderStatus.transit,
    goingTo: GoingTo.launderer,
    phase: Phase.pickup,
    fromLocationName: "Joe's Downtown Office",
    toLocationName: "Urban Cleaners",
    fromLocationAddress: "789 Metropolitan Ave, City Center",
    toLocationAddress: "101 Office Park Rd, City Center",
    fromLat: 51.048615,
    fromLng: -114.070847,
    toLat: 51.050110,
    toLng: -114.072400,
    ongoing: false,
  )
];

class OrderListNotifiernew extends StateNotifier<List<Order>> {
  OrderListNotifiernew() : super([]);

  Future<void> fetchAndSetOrders(String bearerToken) async {
    final orders = await getCreatedOrders(bearerToken);
    state = orders;
  }

  Future<void> updateOrderStatusAndRefresh(
      String bearerToken, String orderId) async {
    bool success = await updateOrderStatus(bearerToken, orderId);
    if (success) {
      state = state.map((order) {
        if (order.orderId == orderId) {
          return Order(
            distance: order.distance,
            deliveryFee: order.deliveryFee,
            totalItems: order.totalItems,
            weight: order.weight,
            type: order.type,
            orderId: order.orderId,
            specialInstructions: order.specialInstructions,
            status: OrderStatus.laundromart_accepted,
            goingTo: order.goingTo,
            phase: order.phase,
            fromLocationName: order.fromLocationName,
            toLocationName: order.toLocationName,
            fromLocationAddress: order.fromLocationAddress,
            toLocationAddress: order.toLocationAddress,
            fromLat: order.fromLat,
            fromLng: order.fromLng,
            toLat: order.toLat,
            toLng: order.toLng,
            ongoing: order.ongoing,
          );
        } else {
          return order;
        }
      }).toList();
    }
  }
}

final orderListNotifierNewProvider =
    StateNotifierProvider<OrderListNotifiernew, List<Order>>((ref) {
  return OrderListNotifiernew();
});

class OngoingOrderListNotifiernew extends StateNotifier<List<Order>> {
  OngoingOrderListNotifiernew() : super([]);

  Future<void> fetchAndSetOngoingOrders(String bearerToken) async {
    final orders = await getOngoingOrders(bearerToken);
    state = orders;
  }
}

final ongoingOrderListNotifierNewProvider =
    StateNotifierProvider<OngoingOrderListNotifiernew, List<Order>>((ref) {
  return OngoingOrderListNotifiernew();
});
