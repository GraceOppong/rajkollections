import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/workspace_bottom_nav.dart';
import 'inventory_product.dart';
import 'order_models.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _landmark = TextEditingController();
  final _search = TextEditingController();
  final _notes = TextEditingController();
  final _searchFocus = FocusNode();

  var _customerType = 'Individual';
  var _region = 'Greater Accra';
  var _city = 'Accra';
  var _discount = 0.0;
  final _items = <_DraftItem>[
    _DraftItem(product: kInventoryProducts.first, qty: 1),
  ];

  static const _deliveryFee = 20.0;
  static const _types = ['Individual', 'Business', 'Walk-in'];
  static const _cities = {
    'Greater Accra': ['Accra', 'Tema', 'Madina', 'East Legon'],
    'Ashanti': ['Kumasi', 'Obuasi'],
    'Western': ['Takoradi', 'Tarkwa'],
    'Eastern': ['Koforidua'],
    'Central': ['Cape Coast'],
  };

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _landmark.dispose();
    _search.dispose();
    _notes.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  int get _itemCount => _items.fold(0, (sum, item) => sum + item.qty);

  double get _subtotal => _items.fold(0, (sum, item) => sum + item.lineTotal);

  double get _total => _subtotal + _deliveryFee - _discount;

  List<InventoryProduct> get _matches {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return kInventoryProducts
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.sku.toLowerCase().contains(q) ||
              p.barcode.toLowerCase().contains(q),
        )
        .take(5)
        .toList();
  }

  void _addProduct(InventoryProduct product) {
    final i = _items.indexWhere((item) => item.product.sku == product.sku);
    setState(() {
      if (i >= 0) {
        _items[i] = _items[i].copyWith(qty: _items[i].qty + 1);
      } else {
        _items.add(_DraftItem(product: product, qty: 1));
      }
      _search.clear();
    });
  }

  void _setQty(int index, int qty) {
    setState(() {
      if (qty < 1) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(qty: qty);
      }
    });
  }

  Future<void> _pick({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onPicked,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 8),
              for (final option in options)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: option == current ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.coffee,
                    ),
                  ),
                  trailing: option == current
                      ? const Icon(Icons.check, size: 18, color: AppColors.bronze)
                      : null,
                  onTap: () => Navigator.pop(context, option),
                ),
            ],
          ),
        );
      },
    );
    if (result == null || !mounted) return;
    onPicked(result);
  }

  Future<void> _selectExisting() async {
    final seen = <String>{};
    final customers = kOrders.where((o) => seen.add(o.customer)).toList();
    final picked = await showModalBottomSheet<StoreOrder>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Select Existing',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 8),
              for (final customer in customers)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.creamDark,
                    child: Text(
                      customer.initials,
                      style: AppTypography.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffee,
                      ),
                    ),
                  ),
                  title: Text(
                    customer.customer,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  subtitle: Text(
                    customer.phone,
                    style: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  onTap: () => Navigator.pop(context, customer),
                ),
            ],
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() {
      _name.text = picked.customer;
      _phone.text = picked.phone;
      _email.text = picked.email;
    });
  }

  Future<void> _useSavedAddress() async {
    final seen = <String>{};
    final orders = kOrders.where((o) => seen.add(o.addressLines.join(', '))).toList();
    final picked = await showModalBottomSheet<StoreOrder>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Use Saved Address',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 8),
              for (final order in orders)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    order.customer,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  subtitle: Text(
                    order.addressLines.join(', '),
                    style: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  onTap: () => Navigator.pop(context, order),
                ),
            ],
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() {
      _address.text = picked.addressLines.join(', ');
      if (picked.addressLines.last.toLowerCase().contains('accra')) {
        _region = 'Greater Accra';
        _city = 'Accra';
      }
    });
  }

  Future<void> _addDiscount() async {
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => _DiscountSheet(initial: _discount),
    );
    if (result == null || !mounted) return;
    setState(() => _discount = result.clamp(0, _subtotal));
  }

  Future<void> _scanBarcode() async {
    final picked = await showModalBottomSheet<InventoryProduct>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Scan Barcode',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose a product to add from inventory.',
                style: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              for (final product in kInventoryProducts)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(product.image, width: 36, height: 36, fit: BoxFit.cover),
                  ),
                  title: Text(
                    product.name,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  subtitle: Text(
                    'SKU: ${product.sku}',
                    style: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  onTap: () => Navigator.pop(context, product),
                ),
            ],
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    _addProduct(picked);
  }

  void _createOrder() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final maxWidth = contentMaxWidth(context);
    final horizontal = tablet ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontal - 8, 2, horizontal - 8, 0),
                  child: const _Header(),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 12),
                    children: [
                      _SectionCard(
                        icon: Icons.person_outline,
                        title: 'Customer Information',
                        action: 'Select Existing',
                        onAction: _selectExisting,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _LabeledField(
                                    label: 'Full Name',
                                    icon: Icons.person_outline,
                                    controller: _name,
                                    hint: 'Enter customer name',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _LabeledField(
                                    label: 'Phone Number',
                                    icon: Icons.phone_outlined,
                                    controller: _phone,
                                    hint: '+233 XX XXX XXXX',
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: _LabeledField(
                                    label: 'Email (Optional)',
                                    icon: Icons.mail_outline,
                                    controller: _email,
                                    hint: 'customer@email.com',
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _LabeledPicker(
                                    label: 'Customer Type',
                                    icon: Icons.person_outline,
                                    value: _customerType,
                                    onTap: () => _pick(
                                      title: 'Customer Type',
                                      options: _types,
                                      current: _customerType,
                                      onPicked: (v) => setState(() => _customerType = v),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _SectionCard(
                        icon: Icons.location_on_outlined,
                        title: 'Delivery Address',
                        action: 'Use Saved Address',
                        onAction: _useSavedAddress,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _IconField(
                              icon: Icons.location_on_outlined,
                              controller: _address,
                              hint: 'Enter full delivery address',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'E.g. House number, street, area, city',
                              style: AppTypography.inter(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: _LabeledPicker(
                                    label: 'Region',
                                    value: _region,
                                    onTap: () => _pick(
                                      title: 'Region',
                                      options: _cities.keys.toList(),
                                      current: _region,
                                      onPicked: (v) => setState(() {
                                        _region = v;
                                        _city = _cities[v]!.first;
                                      }),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _LabeledPicker(
                                    label: 'City',
                                    value: _city,
                                    onTap: () => _pick(
                                      title: 'City',
                                      options: _cities[_region]!,
                                      current: _city,
                                      onPicked: (v) => setState(() => _city = v),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            _LabeledField(
                              label: 'Landmark (Optional)',
                              icon: Icons.apartment_outlined,
                              controller: _landmark,
                              hint: 'E.g. Near MELCOM, opposite school',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _SectionCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'Add Items',
                        actionIcon: Icons.qr_code_scanner,
                        action: 'Scan Barcode',
                        onAction: _scanBarcode,
                        child: Column(
                          children: [
                            TextField(
                              controller: _search,
                              focusNode: _searchFocus,
                              onChanged: (_) => setState(() {}),
                              style: AppTypography.inter(fontSize: 12, color: AppColors.coffee),
                              cursorColor: AppColors.bronze,
                              decoration: _inputDecoration(
                                hint: 'Search product by name, SKU or scan barcode...',
                                prefix: Icons.search,
                              ),
                            ),
                            if (_matches.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              for (final product in _matches)
                                ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      product.image,
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    product.name,
                                    style: AppTypography.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.coffee,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${product.sku}  ·  ${product.unitPriceLabel}',
                                    style: AppTypography.inter(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  onTap: () => _addProduct(product),
                                ),
                            ],
                            const SizedBox(height: 6),
                            for (var i = 0; i < _items.length; i++) ...[
                              _ItemRow(
                                item: _items[i],
                                onMinus: () => _setQty(i, _items[i].qty - 1),
                                onPlus: () => _setQty(i, _items[i].qty + 1),
                                onDelete: () => _setQty(i, 0),
                              ),
                              if (i != _items.length - 1) const SizedBox(height: 8),
                            ],
                            const SizedBox(height: 6),
                            Material(
                              color: AppColors.cream.withValues(alpha: 0.7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: AppColors.sand.withValues(alpha: 0.35)),
                              ),
                              child: InkWell(
                                onTap: () => _searchFocus.requestFocus(),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add, size: 14, color: AppColors.coffee),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Add Another Item',
                                        style: AppTypography.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.coffee,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _SectionCard(
                        icon: Icons.description_outlined,
                        title: 'Order Summary',
                        compact: true,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _SummaryLine(
                                    label: 'Subtotal ($_itemCount item${_itemCount == 1 ? '' : 's'})',
                                    value: 'GH₵ ${_subtotal.toStringAsFixed(2)}',
                                  ),
                                  Divider(height: 8, color: AppColors.sand.withValues(alpha: 0.28)),
                                  const _SummaryLine(
                                    label: 'Delivery Fee',
                                    value: 'GH₵ 20.00',
                                  ),
                                  Divider(height: 8, color: AppColors.sand.withValues(alpha: 0.28)),
                                  _SummaryLine(
                                    label: 'Discount',
                                    value: 'GH₵ ${_discount.toStringAsFixed(2)}',
                                  ),
                                  Divider(height: 8, color: AppColors.sand.withValues(alpha: 0.28)),
                                  _SummaryLine(
                                    label: 'Total',
                                    value: 'GH₵ ${_total.toStringAsFixed(2)}',
                                    bold: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 132,
                              child: Column(
                                children: [
                                  Material(
                                    color: AppColors.alertRose.withValues(alpha: 0.55),
                                    borderRadius: BorderRadius.circular(8),
                                    child: InkWell(
                                      onTap: _addDiscount,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(7, 6, 6, 6),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.percent,
                                              size: 12,
                                              color: AppColors.alertRoseIcon,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'Add Discount',
                                                style: AppTypography.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.alertRoseIcon,
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.chevron_right,
                                              size: 14,
                                              color: AppColors.alertRoseIcon,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.cream.withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.sand.withValues(alpha: 0.22),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.description_outlined,
                                                size: 12,
                                                color: AppColors.bronze,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  'Order Notes',
                                                  style: AppTypography.inter(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.coffee,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          TextField(
                                            controller: _notes,
                                            minLines: 1,
                                            maxLines: 2,
                                            style: AppTypography.inter(
                                              fontSize: 10,
                                              color: AppColors.coffee,
                                            ),
                                            cursorColor: AppColors.bronze,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: 'Add any special instructions...',
                                              hintStyle: AppTypography.inter(
                                                fontSize: 10,
                                                color: AppColors.textSecondary,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white.withValues(alpha: 0.55),
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 6,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(6),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Material(
                        color: AppColors.bronze,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: _createOrder,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Create Order',
                              textAlign: TextAlign.center,
                              style: AppTypography.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: WorkspaceBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index != 1) Navigator.of(context).pop();
        },
      ),
    );
  }
}

InputDecoration _inputDecoration({required String hint, IconData? prefix}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.35)),
  );
  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
    prefixIcon: prefix == null ? null : Icon(prefix, size: 16, color: AppColors.coffeeMuted),
    prefixIconConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.7),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.bronze),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(4, 6, 8, 6),
            child: Icon(Icons.chevron_left, size: 24, color: AppColors.coffee),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Create New Order',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              Text(
                'Add customer details, items and delivery information.',
                textAlign: TextAlign.center,
                style: AppTypography.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 36),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.action,
    this.actionIcon,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final String? action;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, compact ? 8 : 10, 12, compact ? 8 : 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: compact ? 14 : 16, color: AppColors.bronze),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.inter(
                      fontSize: compact ? 12 : 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coffee,
                    ),
                  ),
                ),
                if (action != null)
                  InkWell(
                    onTap: onAction,
                    child: Row(
                      children: [
                        if (actionIcon != null) ...[
                          Icon(actionIcon, size: 13, color: AppColors.bronze),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          action!,
                          style: AppTypography.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bronze,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: compact ? 6 : 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
    this.icon,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.coffee,
          ),
        ),
        const SizedBox(height: 4),
        _IconField(
          icon: icon,
          controller: controller,
          hint: hint,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}

class _IconField extends StatelessWidget {
  const _IconField({
    required this.controller,
    required this.hint,
    this.icon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.inter(fontSize: 12, color: AppColors.coffee),
      cursorColor: AppColors.bronze,
      decoration: _inputDecoration(hint: hint, prefix: icon),
    );
  }
}

class _LabeledPicker extends StatelessWidget {
  const _LabeledPicker({
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.coffee,
          ),
        ),
        const SizedBox(height: 4),
        Material(
          color: Colors.white.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.sand.withValues(alpha: 0.35)),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: AppColors.coffeeMuted),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.inter(fontSize: 12, color: AppColors.coffee),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onDelete,
  });

  final _DraftItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(item.product.image, width: 48, height: 48, fit: BoxFit.cover),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                style: AppTypography.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              Text(
                'SKU: ${item.product.sku}',
                style: AppTypography.inter(fontSize: 10, color: AppColors.textSecondary),
              ),
              Text(
                item.product.unitPriceLabel,
                style: AppTypography.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coffee,
                ),
              ),
            ],
          ),
        ),
        _QtyButton(icon: Icons.remove, onTap: onMinus),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${item.qty}',
            style: AppTypography.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.coffee,
            ),
          ),
        ),
        _QtyButton(icon: Icons.add, onTap: onPlus),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onDelete,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.alertRoseIcon),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.creamDark,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 14, color: AppColors.coffee),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.inter(
              fontSize: bold ? 12 : 10,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.coffee,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.inter(
            fontSize: bold ? 12 : 10,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: AppColors.coffee,
          ),
        ),
      ],
    );
  }
}

class _DraftItem {
  const _DraftItem({required this.product, required this.qty});

  final InventoryProduct product;
  final int qty;

  double get lineTotal => product.unitPrice * qty;

  _DraftItem copyWith({int? qty}) => _DraftItem(product: product, qty: qty ?? this.qty);
}

class _DiscountSheet extends StatefulWidget {
  const _DiscountSheet({required this.initial});

  final double initial;

  @override
  State<_DiscountSheet> createState() => _DiscountSheetState();
}

class _DiscountSheetState extends State<_DiscountSheet> {
  late final _controller = TextEditingController(
    text: widget.initial == 0 ? '' : widget.initial.toStringAsFixed(0),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close([double? value]) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Discount',
                      style: AppTypography.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffee,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _close,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close, size: 20, color: AppColors.coffee),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: AppTypography.inter(fontSize: 13, color: AppColors.coffee),
                cursorColor: AppColors.bronze,
                onSubmitted: (_) => _close(double.tryParse(_controller.text.trim()) ?? 0),
                decoration: _inputDecoration(hint: 'Discount amount (GH₵)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: AppColors.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.sand.withValues(alpha: 0.55)),
                      ),
                      child: InkWell(
                        onTap: _close,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: AppTypography.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coffee,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Material(
                      color: AppColors.bronze,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => _close(double.tryParse(_controller.text.trim()) ?? 0),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          child: Text(
                            'Apply',
                            textAlign: TextAlign.center,
                            style: AppTypography.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
