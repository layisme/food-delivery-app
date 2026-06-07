import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final bool embedded;

  const CartScreen({super.key, this.embedded = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<_CartItemData> _items = [
    const _CartItemData(
      name: 'Double Cheese',
      restaurant: 'Burger Artisan Co.',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/4f82994e-883a-4e5f-ba67-04dac8c14fdd',
      price: 8.90,
      options: 'Regular • Extra cheese',
    ),
    const _CartItemData(
      name: 'Harvest Bowl',
      restaurant: 'Fresh Garden',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/6de1e99e-b35e-48f7-bd9e-87ad16b2a81e',
      price: 12.50,
      options: 'Large • Fresh herbs',
    ),
  ];

  final Map<int, int> _quantities = {0: 1, 1: 1};

  double get _subtotal {
    var value = 0.0;
    for (var i = 0; i < _items.length; i++) {
      value += _items[i].price * (_quantities[i] ?? 1);
    }
    return value;
  }

  double get _deliveryFee => 1.75;
  double get _serviceFee => 0.85;
  double get _total => _subtotal + _deliveryFee + _serviceFee;

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(20, widget.embedded ? 16 : 12, 20, 164),
          children: [
            _Header(
              title: 'Cart',
              subtitle: '${_items.length} items from your favorites',
              showBack: !widget.embedded,
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < _items.length; i++) ...[
              _CartItem(
                item: _items[i],
                quantity: _quantities[i] ?? 1,
                onQuantityChanged: (value) {
                  setState(() => _quantities[i] = value);
                },
              ),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 10),
            _PromoCodeBox(),
            const SizedBox(height: 20),
            _SummaryCard(
              subtotal: _subtotal,
              deliveryFee: _deliveryFee,
              serviceFee: _serviceFee,
              total: _total,
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _CartCheckoutBar(
            total: _total,
            onPressed: () {
              Navigator.of(context).pushNamed('/checkout', arguments: _total);
            },
          ),
        ),
      ],
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F6),
      body: SafeArea(child: content),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBack;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.showBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack) ...[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF261814),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF594139), fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartItem extends StatelessWidget {
  final _CartItemData item;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const _CartItem({
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.imageUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF261814),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.restaurant,
                  style: const TextStyle(
                    color: Color(0xFFAB3500),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.options,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF8D7168),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF261814),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    _QuantityStepper(
                      value: quantity,
                      onChanged: onQuantityChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: value == 1 ? null : () => onChanged(value - 1),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          _StepButton(icon: Icons.add, onTap: () => onChanged(value + 1)),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 34,
        height: 36,
        child: Icon(
          icon,
          color: onTap == null
              ? const Color(0xFFE1BFB5)
              : const Color(0xFFAB3500),
          size: 16,
        ),
      ),
    );
  }
}

class _PromoCodeBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9E3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_offer_outlined, color: Color(0xFFAB3500)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Apply promo code',
              style: TextStyle(
                color: Color(0xFF261814),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Color(0xFFAB3500)),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;

  const _SummaryCard({
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: subtotal),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Delivery', value: deliveryFee),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Service fee', value: serviceFee),
          const Divider(height: 28, color: Color(0xFFE1BFB5)),
          _SummaryRow(label: 'Total', value: total, emphasized: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool emphasized;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: emphasized
                ? const Color(0xFF261814)
                : const Color(0xFF594139),
            fontSize: emphasized ? 18 : 14,
            fontWeight: emphasized ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: emphasized
                ? const Color(0xFFAB3500)
                : const Color(0xFF261814),
            fontSize: emphasized ? 20 : 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _CartCheckoutBar extends StatelessWidget {
  final double total;
  final VoidCallback onPressed;

  const _CartCheckoutBar({required this.total, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            child: Text('Checkout • \$${total.toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }
}

class _CartItemData {
  final String name;
  final String restaurant;
  final String imageUrl;
  final double price;
  final String options;

  const _CartItemData({
    required this.name,
    required this.restaurant,
    required this.imageUrl,
    required this.price,
    required this.options,
  });
}
