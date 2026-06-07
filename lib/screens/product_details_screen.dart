import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Food food;

  const ProductDetailsScreen({super.key, required this.food});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedSize = 1;
  final Set<String> _extras = {'Extra cheese'};

  double get _extrasTotal => _extras.length * 1.25;
  double get _sizePrice => switch (_selectedSize) {
    0 => 0,
    1 => 1.50,
    _ => 3.25,
  };
  double get _total =>
      (widget.food.price + _sizePrice + _extrasTotal) * _quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F6),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFFFF8F6),
            leading: _CircleIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: _CircleIconButton(icon: Icons.favorite_border),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.food.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFFDE3DB),
                        child: const Icon(
                          Icons.fastfood,
                          color: Color(0xFFAB3500),
                          size: 72,
                        ),
                      );
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.18),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.48),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 24,
                    child: Row(
                      children: [
                        _InfoPill(
                          icon: Icons.star,
                          text: widget.food.rating.toStringAsFixed(1),
                        ),
                        const SizedBox(width: 8),
                        const _InfoPill(
                          icon: Icons.schedule,
                          text: '20-30 min',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -18, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8F6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.food.name,
                              style: const TextStyle(
                                color: Color(0xFF261814),
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                height: 1.12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.food.category,
                              style: const TextStyle(
                                color: Color(0xFFAB3500),
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _QuantityStepper(
                        value: _quantity,
                        onChanged: (value) => setState(() => _quantity = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.food.description,
                    style: const TextStyle(
                      color: Color(0xFF594139),
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 26),
                  const _DetailSectionTitle('Choose size'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SizeOption(
                          label: 'Small',
                          price: r'+$0',
                          selected: _selectedSize == 0,
                          onTap: () => setState(() => _selectedSize = 0),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SizeOption(
                          label: 'Regular',
                          price: r'+$1.50',
                          selected: _selectedSize == 1,
                          onTap: () => setState(() => _selectedSize = 1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SizeOption(
                          label: 'Large',
                          price: r'+$3.25',
                          selected: _selectedSize == 2,
                          onTap: () => setState(() => _selectedSize = 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  const _DetailSectionTitle('Add extras'),
                  const SizedBox(height: 12),
                  _ExtraTile(
                    label: 'Extra cheese',
                    price: r'+$1.25',
                    selected: _extras.contains('Extra cheese'),
                    onChanged: _toggleExtra,
                  ),
                  _ExtraTile(
                    label: 'Garlic sauce',
                    price: r'+$1.25',
                    selected: _extras.contains('Garlic sauce'),
                    onChanged: _toggleExtra,
                  ),
                  _ExtraTile(
                    label: 'Fresh herbs',
                    price: r'+$1.25',
                    selected: _extras.contains('Fresh herbs'),
                    onChanged: _toggleExtra,
                  ),
                  const SizedBox(height: 26),
                  const _DetailSectionTitle('Special instructions'),
                  const SizedBox(height: 12),
                  TextField(
                    minLines: 3,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Add notes for the kitchen...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
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
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(color: Color(0xFF8D7168), fontSize: 12),
                    ),
                    Text(
                      '\$${_total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFFAB3500),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.food.name} added to cart'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.of(context).pushNamed('/cart');
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleExtra(String label, bool selected) {
    setState(() {
      if (selected) {
        _extras.add(label);
      } else {
        _extras.remove(label);
      }
    });
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CircleIconButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: const Color(0xFF261814)),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        shape: const CircleBorder(),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFAB3500), size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF261814),
              fontSize: 13,
              fontWeight: FontWeight.w800,
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
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: value == 1 ? null : () => onChanged(value - 1),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF261814),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
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
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 40,
        height: 44,
        child: Icon(
          icon,
          color: onTap == null
              ? const Color(0xFFE1BFB5)
              : const Color(0xFFAB3500),
          size: 18,
        ),
      ),
    );
  }
}

class _DetailSectionTitle extends StatelessWidget {
  final String title;

  const _DetailSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF261814),
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String label;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const _SizeOption({
    required this.label,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFE9E3) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFFF6B35) : const Color(0xFFE1BFB5),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF261814),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(color: Color(0xFF8D7168), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExtraTile extends StatelessWidget {
  final String label;
  final String price;
  final bool selected;
  final void Function(String label, bool selected) onChanged;

  const _ExtraTile({
    required this.label,
    required this.price,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: selected,
      onChanged: (value) => onChanged(label, value ?? false),
      title: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF261814),
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(price),
      activeColor: const Color(0xFFFF6B35),
      checkColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      checkboxScaleFactor: 1.25,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
