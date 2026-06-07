import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final double total;

  const CheckoutScreen({super.key, this.total = 25.50});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _paymentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F6),
        elevation: 0,
        foregroundColor: const Color(0xFF261814),
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 128),
        children: [
          const _CheckoutSection(
            title: 'Delivery address',
            child: _AddressCard(),
          ),
          const SizedBox(height: 18),
          const _CheckoutSection(
            title: 'Delivery time',
            child: _DeliveryTime(),
          ),
          const SizedBox(height: 18),
          _CheckoutSection(
            title: 'Payment method',
            child: Column(
              children: [
                _PaymentOption(
                  icon: Icons.qr_code_2,
                  title: 'KHQR',
                  subtitle: 'Scan and pay instantly',
                  selected: _paymentIndex == 0,
                  onTap: () => setState(() => _paymentIndex = 0),
                ),
                const SizedBox(height: 10),
                _PaymentOption(
                  icon: Icons.credit_card,
                  title: 'Visa / Master',
                  subtitle: 'Ending in 4288',
                  selected: _paymentIndex == 1,
                  onTap: () => setState(() => _paymentIndex = 1),
                ),
                const SizedBox(height: 10),
                _PaymentOption(
                  icon: Icons.payments_outlined,
                  title: 'Cash on delivery',
                  subtitle: 'Pay the courier at arrival',
                  selected: _paymentIndex == 2,
                  onTap: () => setState(() => _paymentIndex = 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _CheckoutSection(
            title: 'Order summary',
            child: Column(
              children: [
                _SummaryLine(label: 'Items', value: widget.total - 2.60),
                const SizedBox(height: 12),
                const _SummaryLine(label: 'Fees', value: 2.60),
                const Divider(height: 28, color: Color(0xFFE1BFB5)),
                _SummaryLine(
                  label: 'Total',
                  value: widget.total,
                  emphasized: true,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          color: Colors.white,
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/tracking-order');
              },
              icon: const Icon(Icons.lock_outline),
              label: Text('Place order • \$${widget.total.toStringAsFixed(2)}'),
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
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _CheckoutSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF261814),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.location_on_outlined, color: Color(0xFFAB3500)),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Location',
                style: TextStyle(
                  color: Color(0xFF261814),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Street 310, Boeung Keng Kang, Phnom Penh',
                style: TextStyle(color: Color(0xFF594139), height: 1.35),
              ),
            ],
          ),
        ),
        Icon(Icons.edit_outlined, color: Color(0xFFAB3500)),
      ],
    );
  }
}

class _DeliveryTime extends StatelessWidget {
  const _DeliveryTime();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.schedule, color: Color(0xFFAB3500)),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Arrives in 20-30 minutes',
            style: TextStyle(
              color: Color(0xFF261814),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          'ASAP',
          style: TextStyle(
            color: Color(0xFFAB3500),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFE9E3) : const Color(0xFFFFF8F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFFF6B35) : const Color(0xFFE1BFB5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFAB3500)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF261814),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF8D7168),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? const Color(0xFFFF6B35)
                  : const Color(0xFFE1BFB5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final double value;
  final bool emphasized;

  const _SummaryLine({
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
