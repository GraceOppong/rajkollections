import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum StockStatus { inStock, lowStock, outOfStock }

class InventoryActivity {
  const InventoryActivity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color bg;
  final Color fg;
}

class InventoryProduct {
  const InventoryProduct({
    required this.name,
    required this.sku,
    required this.category,
    required this.image,
    required this.status,
    required this.units,
    required this.description,
    required this.tags,
    required this.reorderLevel,
    required this.unitsOnOrder,
    required this.unitPrice,
    required this.brand,
    required this.barcode,
    required this.addedOn,
    required this.lastUpdated,
    required this.activity,
    this.warehouse = 'Accra Main',
    this.shelf = 'A-12',
    this.supplier = 'RK Sourcing',
  });

  final String name;
  final String sku;
  final String category;
  final String image;
  final StockStatus status;
  final int units;
  final String description;
  final List<String> tags;
  final int reorderLevel;
  final int unitsOnOrder;
  final double unitPrice;
  final String brand;
  final String barcode;
  final String addedOn;
  final String lastUpdated;
  final List<InventoryActivity> activity;
  final String warehouse;
  final String shelf;
  final String supplier;

  double get totalValue => units * unitPrice;

  String get unitPriceLabel => 'GH₵ ${unitPrice.toStringAsFixed(2)}';

  String get totalValueLabel => 'GH₵ ${totalValue.toStringAsFixed(2)}';
}

extension StockStatusStyle on StockStatus {
  String get label => switch (this) {
        StockStatus.inStock => 'In stock',
        StockStatus.lowStock => 'Low stock',
        StockStatus.outOfStock => 'Out of stock',
      };

  String get hint => switch (this) {
        StockStatus.inStock => 'Ready to fulfill orders',
        StockStatus.lowStock => 'Consider reordering soon',
        StockStatus.outOfStock => 'Restock to continue selling',
      };

  Color get bg => switch (this) {
        StockStatus.inStock => Color(0xFFE3F0E6),
        StockStatus.lowStock => AppColors.alertAmber,
        StockStatus.outOfStock => AppColors.alertRose,
      };

  Color get fg => switch (this) {
        StockStatus.inStock => Color(0xFF4C9A62),
        StockStatus.lowStock => AppColors.alertAmberIcon,
        StockStatus.outOfStock => AppColors.alertRoseIcon,
      };

  Color get dot => switch (this) {
        StockStatus.inStock => Color(0xFF4C9A62),
        StockStatus.lowStock => const Color(0xFFE8A23A),
        StockStatus.outOfStock => const Color(0xFFE05252),
      };
}

const kInventoryProducts = <InventoryProduct>[
  InventoryProduct(
    name: 'Wireless Earbuds',
    sku: 'WE-BLK',
    category: 'Electronics',
    image: 'assets/images/inv_earbuds.jpg',
    status: StockStatus.outOfStock,
    units: 0,
    description:
        'High-quality wireless earbuds with\nnoise cancellation and long battery life.',
    tags: ['Electronics', 'Audio', 'Wireless'],
    reorderLevel: 10,
    unitsOnOrder: 50,
    unitPrice: 200,
    brand: 'RK Collection',
    barcode: '8934567123456',
    addedOn: '12 Aug 2025',
    lastUpdated: '16 Sep 2025, 10:24 AM',
    activity: [
      InventoryActivity(
        title: 'Stock level reached 0',
        subtitle: 'Out of stock',
        time: 'Today, 9:18 AM',
        icon: Icons.inventory_2_outlined,
        bg: AppColors.alertRose,
        fg: AppColors.alertRoseIcon,
      ),
      InventoryActivity(
        title: 'Stock adjusted',
        subtitle: '-20 units (Manual adjustment)',
        time: '14 Sep 2025, 4:32 PM',
        icon: Icons.south_outlined,
        bg: Color(0xFFE3F0E6),
        fg: Color(0xFF4C9A62),
      ),
    ],
  ),
  InventoryProduct(
    name: 'Classic T-Shirt',
    sku: 'TS-WHT-L',
    category: 'Apparel',
    image: 'assets/images/inv_tshirt.jpg',
    status: StockStatus.inStock,
    units: 120,
    description: 'Soft cotton crew-neck T-shirt with a clean, everyday fit.',
    tags: ['Apparel', 'Cotton', 'Casual'],
    reorderLevel: 24,
    unitsOnOrder: 0,
    unitPrice: 85,
    brand: 'RK Collection',
    barcode: '8934567123457',
    addedOn: '12 Aug 2025',
    lastUpdated: '15 Sep 2025, 2:10 PM',
    shelf: 'B-04',
    activity: [
      InventoryActivity(
        title: 'Stock received',
        subtitle: '+80 units (Shipment SH-002)',
        time: 'Yesterday, 11:40 AM',
        icon: Icons.inventory_2_outlined,
        bg: Color(0xFFE3F0E6),
        fg: Color(0xFF4C9A62),
      ),
      InventoryActivity(
        title: 'Order packed',
        subtitle: '-4 units (Order RK-10231)',
        time: '15 Sep 2025, 2:10 PM',
        icon: Icons.inventory_2_outlined,
        bg: AppColors.priorityBlue,
        fg: Color(0xFF5B8FB8),
      ),
    ],
  ),
  InventoryProduct(
    name: 'Travel Backpack',
    sku: 'TB-BLK',
    category: 'Bags',
    image: 'assets/images/inv_backpack.jpg',
    status: StockStatus.lowStock,
    units: 5,
    description: 'Durable travel backpack with a padded laptop sleeve.',
    tags: ['Bags', 'Travel', 'Outdoor'],
    reorderLevel: 10,
    unitsOnOrder: 20,
    unitPrice: 350,
    brand: 'RK Collection',
    barcode: '8934567123458',
    addedOn: '12 Aug 2025',
    lastUpdated: '16 Sep 2025, 8:12 AM',
    shelf: 'C-08',
    activity: [
      InventoryActivity(
        title: 'Low stock alert',
        subtitle: '5 units remaining',
        time: 'Today, 8:12 AM',
        icon: Icons.warning_amber_outlined,
        bg: AppColors.alertAmber,
        fg: AppColors.alertAmberIcon,
      ),
      InventoryActivity(
        title: 'Order packed',
        subtitle: '-2 units (Order RK-10228)',
        time: '15 Sep 2025, 5:32 PM',
        icon: Icons.inventory_2_outlined,
        bg: AppColors.priorityBlue,
        fg: Color(0xFF5B8FB8),
      ),
    ],
  ),
  InventoryProduct(
    name: 'Yoga Mat',
    sku: 'YM-GRY',
    category: 'Fitness',
    image: 'assets/images/inv_yoga_mat.jpg',
    status: StockStatus.inStock,
    units: 45,
    description: 'Non-slip yoga mat for studio and home practice.',
    tags: ['Fitness', 'Studio', 'Home'],
    reorderLevel: 15,
    unitsOnOrder: 0,
    unitPrice: 120,
    brand: 'RK Collection',
    barcode: '8934567123459',
    addedOn: '12 Aug 2025',
    lastUpdated: '14 Sep 2025, 9:05 AM',
    shelf: 'D-02',
    activity: [
      InventoryActivity(
        title: 'Stock counted',
        subtitle: '45 units confirmed',
        time: '14 Sep 2025, 9:05 AM',
        icon: Icons.check_circle_outline,
        bg: Color(0xFFE3F0E6),
        fg: Color(0xFF4C9A62),
      ),
      InventoryActivity(
        title: 'Order packed',
        subtitle: '-3 units (Order RK-10220)',
        time: '12 Sep 2025, 3:18 PM',
        icon: Icons.inventory_2_outlined,
        bg: AppColors.priorityBlue,
        fg: Color(0xFF5B8FB8),
      ),
    ],
  ),
  InventoryProduct(
    name: 'Water Bottle',
    sku: 'WB-SLV',
    category: 'Accessories',
    image: 'assets/images/inv_bottle.jpg',
    status: StockStatus.inStock,
    units: 200,
    description: 'Stainless steel bottle that keeps drinks cold or hot.',
    tags: ['Accessories', 'Drinkware', 'Travel'],
    reorderLevel: 40,
    unitsOnOrder: 0,
    unitPrice: 65,
    brand: 'RK Collection',
    barcode: '8934567123460',
    addedOn: '12 Aug 2025',
    lastUpdated: '16 Sep 2025, 7:50 AM',
    shelf: 'E-11',
    activity: [
      InventoryActivity(
        title: 'Stock received',
        subtitle: '+100 units (Shipment SH-001)',
        time: 'Today, 7:50 AM',
        icon: Icons.inventory_2_outlined,
        bg: Color(0xFFE3F0E6),
        fg: Color(0xFF4C9A62),
      ),
      InventoryActivity(
        title: 'Order packed',
        subtitle: '-6 units (Order RK-10234)',
        time: 'Yesterday, 4:12 PM',
        icon: Icons.inventory_2_outlined,
        bg: AppColors.priorityBlue,
        fg: Color(0xFF5B8FB8),
      ),
    ],
  ),
  InventoryProduct(
    name: 'Baseball Cap',
    sku: 'BC-BLK',
    category: 'Apparel',
    image: 'assets/images/inv_cap.jpg',
    status: StockStatus.lowStock,
    units: 8,
    description: 'Classic six-panel cap with an adjustable strap.',
    tags: ['Apparel', 'Accessories', 'Headwear'],
    reorderLevel: 12,
    unitsOnOrder: 24,
    unitPrice: 55,
    brand: 'RK Collection',
    barcode: '8934567123461',
    addedOn: '12 Aug 2025',
    lastUpdated: '16 Sep 2025, 9:02 AM',
    shelf: 'B-09',
    activity: [
      InventoryActivity(
        title: 'Low stock alert',
        subtitle: '8 units remaining',
        time: 'Today, 9:02 AM',
        icon: Icons.warning_amber_outlined,
        bg: AppColors.alertAmber,
        fg: AppColors.alertAmberIcon,
      ),
      InventoryActivity(
        title: 'Stock adjusted',
        subtitle: '-4 units (Manual adjustment)',
        time: '13 Sep 2025, 1:20 PM',
        icon: Icons.south_outlined,
        bg: Color(0xFFE3F0E6),
        fg: Color(0xFF4C9A62),
      ),
    ],
  ),
];
