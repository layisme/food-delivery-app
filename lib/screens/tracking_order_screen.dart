import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingOrderScreen extends StatelessWidget {
  const TrackingOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F6),
        elevation: 0,
        foregroundColor: const Color(0xFF261814),
        title: const Text(
          'Track Order',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          const _DeliveryMapCard(),
          const SizedBox(height: 24),
          const Text(
            'Your courier is on the way',
            style: TextStyle(
              color: Color(0xFF261814),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Order #RB-2048 • Arriving at Current Location',
            style: TextStyle(color: Color(0xFF594139), fontSize: 15),
          ),
          const SizedBox(height: 24),
          const _CourierCard(),
          const SizedBox(height: 24),
          const _TrackingTimeline(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFAB3500),
                    side: const BorderSide(color: Color(0xFFE1BFB5)),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
}

class _EtaPill extends StatelessWidget {
  const _EtaPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        children: [
          Icon(Icons.schedule, color: Color(0xFFAB3500), size: 16),
          SizedBox(width: 7),
          Text(
            'ETA 18 min',
            style: TextStyle(
              color: Color(0xFF261814),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryMapCard extends StatefulWidget {
  const _DeliveryMapCard();

  @override
  State<_DeliveryMapCard> createState() => _DeliveryMapCardState();
}

class _DeliveryMapCardState extends State<_DeliveryMapCard> {
  static const String _deliveryMarkerAsset =
      'https://www.figma.com/api/mcp/asset/3905b2b6-5e39-42cb-9d28-c04a2f2cfef3';

  static const LatLng _pickup = LatLng(11.557418, 104.928734);
  static const LatLng _courier = LatLng(11.554145, 104.926265);
  static const LatLng _dropoff = LatLng(11.550892, 104.922968);

  static const List<LatLng> _routePoints = [
    _pickup,
    LatLng(11.556652, 104.927811),
    LatLng(11.555501, 104.927274),
    _courier,
    LatLng(11.552961, 104.925156),
    LatLng(11.551836, 104.924318),
    _dropoff,
  ];

  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 286,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9E3),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _courier,
                zoom: 15.1,
              ),
              onMapCreated: (controller) => _controller = controller,
              markers: {
                Marker(
                  markerId: const MarkerId('pickup'),
                  position: _pickup,
                  infoWindow: const InfoWindow(
                    title: 'The Golden Grill',
                    snippet: 'Pickup',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange,
                  ),
                ),
                Marker(
                  markerId: const MarkerId('dropoff'),
                  position: _dropoff,
                  infoWindow: const InfoWindow(
                    title: 'Current Location',
                    snippet: 'Drop-off',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              },
              polylines: {
                const Polyline(
                  polylineId: PolylineId('delivery-route'),
                  points: _routePoints,
                  color: Color(0xFFFF6B35),
                  width: 6,
                  jointType: JointType.round,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.08),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: _AnimatedDeliveryMarker(imageUrl: _deliveryMarkerAsset),
          ),
          Positioned(
            left: 18,
            top: 18,
            child: _MapLocationLabel(
              icon: Icons.storefront,
              title: 'The Golden Grill',
              subtitle: 'Pickup',
              color: const Color(0xFFAB3500),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 70,
            child: _MapLocationLabel(
              icon: Icons.home_outlined,
              title: 'Current Location',
              subtitle: 'Drop-off',
              color: const Color(0xFF00677E),
            ),
          ),
          // Positioned(
          //   left: 135,
          //   top: 108,
          //   child: Container(
          //     width: 74,
          //     height: 74,
          //     decoration: BoxDecoration(
          //       color: const Color(0xFFFF6B35),
          //       shape: BoxShape.circle,
          //       border: Border.all(color: Colors.white, width: 5),
          //       boxShadow: [
          //         BoxShadow(
          //           color: const Color(0xFFFF6B35).withValues(alpha: 0.35),
          //           blurRadius: 24,
          //           offset: const Offset(0, 10),
          //         ),
          //       ],
          //     ),
          //     child: const Icon(
          //       Icons.delivery_dining,
          //       color: Colors.white,
          //       size: 34,
          //     ),
          //   ),
          // ),
          Positioned(
            right: 18,
            top: 18,
            child: IconButton(
              onPressed: _recenterMap,
              icon: const Icon(Icons.my_location, color: Color(0xFF261814)),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const Positioned(left: 18, bottom: 18, child: _EtaPill()),
        ],
      ),
    );
  }

  Future<void> _recenterMap() async {
    await _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(_courier, 15.3),
    );
  }
}

class _AnimatedDeliveryMarker extends StatefulWidget {
  final String imageUrl;

  const _AnimatedDeliveryMarker({required this.imageUrl});

  @override
  State<_AnimatedDeliveryMarker> createState() =>
      _AnimatedDeliveryMarkerState();
}

class _AnimatedDeliveryMarkerState extends State<_AnimatedDeliveryMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _lift;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    )..repeat(reverse: true);
    _lift = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _pulse = Tween<double>(
      begin: 0.78,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final verticalOffset = -24 * _lift.value;
        return Transform.translate(
          offset: const Offset(0, -12),
          child: SizedBox(
            width: 82,
            height: 92,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: 6,
                  child: Transform.scale(
                    scale: _pulse.value,
                    child: Container(
                      width: 34,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF261814).withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: SizedBox(
                    width: 44,
                    height: 64,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Transform.translate(
                            offset: Offset(0, verticalOffset),
                            child: Container(
                              width: 44,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF6B35,
                                    ).withValues(alpha: 0.38),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: OverflowBox(
                                maxWidth: 84,
                                maxHeight: 80,
                                child: Image.network(
                                  widget.imageUrl,
                                  width: 84,
                                  height: 80,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 44,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6B35),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.delivery_dining,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
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
        );
      },
    );
  }
}

class _MapLocationLabel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _MapLocationLabel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 176),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8D7168),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF261814),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourierCard extends StatelessWidget {
  const _CourierCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE9E3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Color(0xFFAB3500)),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dara Sok',
                  style: TextStyle(
                    color: Color(0xFF261814),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Courier • Honda Click',
                  style: TextStyle(color: Color(0xFF594139), fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.star, color: Color(0xFFFFB800), size: 18),
          const SizedBox(width: 4),
          const Text(
            '4.9',
            style: TextStyle(
              color: Color(0xFF261814),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingTimeline extends StatelessWidget {
  const _TrackingTimeline();

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Order confirmed', 'Restaurant accepted your order', true),
      ('Preparing food', 'Freshly cooking your meal', true),
      ('Picked up', 'Courier is heading to you', true),
      ('Delivered', 'Enjoy your meal', false),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            _TimelineStep(
              title: steps[i].$1,
              subtitle: steps[i].$2,
              active: steps[i].$3,
              isLast: i == steps.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFFFF6B35)
                    : const Color(0xFFE1BFB5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                active ? Icons.check : Icons.circle,
                size: active ? 16 : 8,
                color: Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 44,
                color: active
                    ? const Color(0xFFFF6B35)
                    : const Color(0xFFE1BFB5),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: active
                        ? const Color(0xFF261814)
                        : const Color(0xFF8D7168),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF594139),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
