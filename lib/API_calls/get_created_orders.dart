import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/order_2.dart';

Future<List<Order>> getCreatedOrders(String bearerToken) async {
  const url = 'http://68.183.204.241/order/?order_status=order_created';
  List<Order> ordersList = [];

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> ordersJson = json.decode(response.body);
      ordersList = ordersJson.map((json) => Order.fromJson(json)).toList();
    } else {
      print(
          'Failed to fetch created orders. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred while fetching created orders: $e');
  }
  return ordersList;
}

Future<List<Order>> getOngoingOrders(String bearerToken) async {
  const url = 'http://68.183.204.241/laundromart/order';
  List<Order> ordersList = [];

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> ordersJson = json.decode(response.body);
      ordersList = ordersJson.map((json) => Order.fromJson(json)).toList();
      print("Call to ongoing orders occured");
    } else {
      print(
          'Failed to fetch ongoing orders. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred while fetching ongoing orders: $e');
  }
  return ordersList;
}

Future<bool> updateOrderStatus(String bearerToken, String orderId) async {
  final url = 'http://68.183.204.241/laundromart/accept-order/$orderId';
  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Order status updated successfully.');
      return true;
    } else {
      print(
          'Failed to update order status. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error occurred while updating order status: $e');
    return false;
  }
}
