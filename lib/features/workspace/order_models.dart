import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum OrderStatus { pending, packing, shipped, delivered, cancelled }

class OrderLineItem {
  const OrderLineItem({
    required this.name,
    required this.sku,
    required this.image,
    required this.unitPrice,
    this.qty = 1,
  });

  final String name;
  final String sku;
  final String image;
  final double unitPrice;
  final int qty;

  double get lineTotal => unitPrice * qty;

  String get unitPriceLabel => 'GH₵ ${unitPrice.toStringAsFixed(2)}';

  String get lineTotalLabel => 'GH₵ ${lineTotal.toStringAsFixed(2)}';
}

class StoreOrder {
  const StoreOrder({
    required this.id,
    required this.customer,
    required this.phone,
    required this.email,
    required this.placedAt,
    required this.status,
    required this.items,
    required this.deliveryFee,
    required this.addressTitle,
    required this.addressLines,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentPaid,
    this.discount = 0,
    this.notes,
    this.pendingAt,
    this.packingAt,
    this.shippedAt,
    this.deliveredAt,
  });

  final String id;
  final String customer;
  final String phone;
  final String email;
  final String placedAt;
  final OrderStatus status;
  final List<OrderLineItem> items;
  final double deliveryFee;
  final double discount;
  final String addressTitle;
  final List<String> addressLines;
  final String paymentMethod;
  final String paymentStatus;
  final bool paymentPaid;
  final String? notes;
  final String? pendingAt;
  final String? packingAt;
  final String? shippedAt;
  final String? deliveredAt;

  int get itemCount => items.fold(0, (sum, item) => sum + item.qty);

  String get image => items.first.image;

  String get initials {
    final parts = customer.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);

  double get total => subtotal + deliveryFee - discount;

  String get subtotalLabel => 'GH₵ ${subtotal.toStringAsFixed(2)}';

  String get deliveryLabel => 'GH₵ ${deliveryFee.toStringAsFixed(2)}';

  String get discountLabel => '- GH₵ ${discount.toStringAsFixed(2)}';

  String get totalLabel => 'GH₵ ${total.toStringAsFixed(2)}';
}

extension OrderStatusStyle on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.packing => 'Packing',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };

  Color get bg => switch (this) {
        OrderStatus.pending => AppColors.alertAmber,
        OrderStatus.packing => AppColors.alertAmber,
        OrderStatus.shipped => AppColors.priorityBlue,
        OrderStatus.delivered => const Color(0xFFE3F0E6),
        OrderStatus.cancelled => AppColors.alertRose,
      };

  Color get fg => switch (this) {
        OrderStatus.pending => AppColors.alertAmberIcon,
        OrderStatus.packing => AppColors.alertAmberIcon,
        OrderStatus.shipped => const Color(0xFF5B8FB8),
        OrderStatus.delivered => const Color(0xFF4C9A62),
        OrderStatus.cancelled => AppColors.alertRoseIcon,
      };

  Color get dot => switch (this) {
        OrderStatus.pending => const Color(0xFFE8A23A),
        OrderStatus.packing => const Color(0xFFE8A23A),
        OrderStatus.shipped => const Color(0xFF4A8FD4),
        OrderStatus.delivered => const Color(0xFF4C9A62),
        OrderStatus.cancelled => const Color(0xFFE05252),
      };

  int get stepIndex => switch (this) {
        OrderStatus.pending => 0,
        OrderStatus.packing => 1,
        OrderStatus.shipped => 2,
        OrderStatus.delivered => 3,
        OrderStatus.cancelled => 0,
      };

  String? get nextAction => switch (this) {
        OrderStatus.pending => 'Mark as Packing',
        OrderStatus.packing => 'Mark as Shipped',
        OrderStatus.shipped => 'Mark as Delivered',
        OrderStatus.delivered => null,
        OrderStatus.cancelled => null,
      };

  IconData get nextActionIcon => switch (this) {
        OrderStatus.pending => Icons.local_shipping_outlined,
        OrderStatus.packing => Icons.local_shipping_outlined,
        OrderStatus.shipped => Icons.check_circle_outline,
        _ => Icons.local_shipping_outlined,
      };
}

const kOrders = <StoreOrder>[
  StoreOrder(
    id: 'RK-10234',
    customer: 'Ama Osei',
    phone: '+233 24 123 4567',
    email: 'amaosei@gmail.com',
    placedAt: '16 Sep 2025, 10:24 AM',
    status: OrderStatus.pending,
    deliveryFee: 20,
    addressTitle: 'Delivery Address',
    addressLines: ['12 Adabraka Road', 'East Legon', 'Accra, Ghana'],
    paymentMethod: 'Mobile Money',
    paymentStatus: 'Paid',
    paymentPaid: true,
    pendingAt: '16 Sep, 10:24 AM',
    items: [
      OrderLineItem(
        name: 'Wireless Earbuds',
        sku: 'WE-BLK',
        image: 'assets/images/inv_earbuds.jpg',
        unitPrice: 200,
      ),
      OrderLineItem(
        name: 'Baseball Cap',
        sku: 'BC-BLK',
        image: 'assets/images/inv_cap.jpg',
        unitPrice: 50,
      ),
    ],
  ),
  StoreOrder(
    id: 'RK-10233',
    customer: 'Kofi Mensah',
    phone: '+233 20 555 0182',
    email: 'kofi.mensah@gmail.com',
    placedAt: '16 Sep 2025, 09:12 AM',
    status: OrderStatus.packing,
    deliveryFee: 20,
    addressTitle: 'Delivery Address',
    addressLines: ['8 Spintex Road', 'Baatsona', 'Accra, Ghana'],
    paymentMethod: 'Mobile Money',
    paymentStatus: 'Paid',
    paymentPaid: true,
    notes: 'Please include a receipt in the package.',
    pendingAt: '16 Sep, 09:12 AM',
    packingAt: '16 Sep, 09:40 AM',
    items: [
      OrderLineItem(
        name: 'Classic T-Shirt',
        sku: 'TS-WHT-L',
        image: 'assets/images/inv_tshirt.jpg',
        unitPrice: 100,
      ),
    ],
  ),
  StoreOrder(
    id: 'RK-10232',
    customer: 'Akua Serwaa',
    phone: '+233 54 882 4410',
    email: 'akua.serwaa@outlook.com',
    placedAt: '15 Sep 2025, 04:36 PM',
    status: OrderStatus.shipped,
    deliveryFee: 20,
    addressTitle: 'Delivery Address',
    addressLines: ['21 Osu Oxford Street', 'Osu', 'Accra, Ghana'],
    paymentMethod: 'Card',
    paymentStatus: 'Paid',
    paymentPaid: true,
    pendingAt: '15 Sep, 04:36 PM',
    packingAt: '15 Sep, 05:10 PM',
    shippedAt: '16 Sep, 08:02 AM',
    items: [
      OrderLineItem(
        name: 'Travel Backpack',
        sku: 'TB-BLK',
        image: 'assets/images/inv_backpack.jpg',
        unitPrice: 300,
      ),
    ],
  ),
  StoreOrder(
    id: 'RK-10231',
    customer: 'Daniel Addo',
    phone: '+233 27 114 9088',
    email: 'daniel.addo@gmail.com',
    placedAt: '15 Sep 2025, 11:20 AM',
    status: OrderStatus.delivered,
    deliveryFee: 20,
    addressTitle: 'Delivery Address',
    addressLines: ['4 Airport Residential', 'Airport', 'Accra, Ghana'],
    paymentMethod: 'Mobile Money',
    paymentStatus: 'Paid',
    paymentPaid: true,
    pendingAt: '15 Sep, 11:20 AM',
    packingAt: '15 Sep, 12:05 PM',
    shippedAt: '15 Sep, 02:40 PM',
    deliveredAt: '15 Sep, 05:18 PM',
    items: [
      OrderLineItem(
        name: 'Yoga Mat',
        sku: 'YM-GRY',
        image: 'assets/images/inv_yoga_mat.jpg',
        unitPrice: 180,
      ),
    ],
  ),
  StoreOrder(
    id: 'RK-10230',
    customer: 'Esi Tetteh',
    phone: '+233 55 321 6677',
    email: 'esi.tetteh@yahoo.com',
    placedAt: '14 Sep 2025, 02:18 PM',
    status: OrderStatus.cancelled,
    deliveryFee: 15,
    addressTitle: 'Delivery Address',
    addressLines: ['16 Dansoman High Street', 'Dansoman', 'Accra, Ghana'],
    paymentMethod: 'Mobile Money',
    paymentStatus: 'Refunded',
    paymentPaid: false,
    notes: 'Customer cancelled before packing.',
    pendingAt: '14 Sep, 02:18 PM',
    items: [
      OrderLineItem(
        name: 'Water Bottle',
        sku: 'WB-SLV',
        image: 'assets/images/inv_bottle.jpg',
        unitPrice: 65,
      ),
    ],
  ),
  StoreOrder(
    id: 'RK-10229',
    customer: 'Kwame Boakye',
    phone: '+233 24 990 1123',
    email: 'kwame.boakye@gmail.com',
    placedAt: '14 Sep 2025, 10:01 AM',
    status: OrderStatus.shipped,
    deliveryFee: 20,
    addressTitle: 'Delivery Address',
    addressLines: ['9 Madina Market Road', 'Madina', 'Accra, Ghana'],
    paymentMethod: 'Cash on Delivery',
    paymentStatus: 'Unpaid',
    paymentPaid: false,
    pendingAt: '14 Sep, 10:01 AM',
    packingAt: '14 Sep, 11:22 AM',
    shippedAt: '14 Sep, 03:15 PM',
    items: [
      OrderLineItem(
        name: 'Baseball Cap',
        sku: 'BC-BLK',
        image: 'assets/images/inv_cap.jpg',
        unitPrice: 80,
      ),
    ],
  ),
];
