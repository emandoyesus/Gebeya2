import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class DeliveryLocationPoint {
  final String subcity;
  final String landmark;
  final String description;
  final double latitude;
  final double longitude;

  const DeliveryLocationPoint({
    required this.subcity,
    required this.landmark,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

class DeliveryPinPickerModal extends StatefulWidget {
  final String initialSubcity;
  final Function(DeliveryLocationPoint point) onLocationSelected;

  const DeliveryPinPickerModal({
    super.key,
    required this.initialSubcity,
    required this.onLocationSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required String initialSubcity,
    required Function(DeliveryLocationPoint point) onLocationSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeliveryPinPickerModal(
        initialSubcity: initialSubcity,
        onLocationSelected: onLocationSelected,
      ),
    );
  }

  @override
  State<DeliveryPinPickerModal> createState() => _DeliveryPinPickerModalState();
}

class _DeliveryPinPickerModalState extends State<DeliveryPinPickerModal> {
  late DeliveryLocationPoint _selectedPoint;
  String _searchFilter = '';

  // Curated popular dispatch landmarks across Addis Ababa subcities
  final List<DeliveryLocationPoint> _availablePoints = const [
    // Bole
    DeliveryLocationPoint(
      subcity: 'Bole',
      landmark: 'Bole Medhanialem Church Area',
      description: 'Near Edna Mall, Olympia St. & Cameroon Ave',
      latitude: 8.9954,
      longitude: 38.7892,
    ),
    DeliveryLocationPoint(
      subcity: 'Bole',
      landmark: 'Bole Atlas / Shala Park',
      description: 'Behind Atlas Hotel, Cape Verde St.',
      latitude: 9.0068,
      longitude: 38.7811,
    ),
    DeliveryLocationPoint(
      subcity: 'Bole',
      landmark: 'Bole Bulbula Roundabout',
      description: 'Goro / Bulbula Commercial Axis',
      latitude: 8.9721,
      longitude: 38.7964,
    ),
    DeliveryLocationPoint(
      subcity: 'Bole',
      landmark: 'Bole Rwanda / Japanese Embassy',
      description: 'Rwanda Roundabout, Ring Road',
      latitude: 8.9892,
      longitude: 38.7754,
    ),

    // Kazanchis & Kirkos
    DeliveryLocationPoint(
      subcity: 'Kazanchis',
      landmark: 'Kazanchis UNECA / Interluxury Hotel',
      description: 'Menelik II Ave, Near ECA Compound',
      latitude: 9.0182,
      longitude: 38.7667,
    ),
    DeliveryLocationPoint(
      subcity: 'Kirkos',
      landmark: 'Meskel Square / Stadium',
      description: 'Exhibition Center & Commercial Bank HQ Area',
      latitude: 9.0108,
      longitude: 38.7618,
    ),
    DeliveryLocationPoint(
      subcity: 'Kirkos',
      landmark: 'Gotera Interchange / Lancia',
      description: 'Debre Zeit Road Junction',
      latitude: 8.9886,
      longitude: 38.7554,
    ),

    // Yeka & Megenagna
    DeliveryLocationPoint(
      subcity: 'Yeka',
      landmark: 'Megenagna Square / Zefmesh Mall',
      description: 'Roundabout, Light Rail Station, Haile Gebreselassie Ave',
      latitude: 9.0205,
      longitude: 38.8021,
    ),
    DeliveryLocationPoint(
      subcity: 'Yeka',
      landmark: 'CMC Michael Commercial Zone',
      description: 'Near Civil Service University & St. Michael Church',
      latitude: 9.0284,
      longitude: 38.8415,
    ),
    DeliveryLocationPoint(
      subcity: 'Yeka',
      landmark: 'Ayat Zone 2 / Light Rail Terminal',
      description: 'Ayat Village & Tafo Road',
      latitude: 9.0345,
      longitude: 38.8680,
    ),

    // Arada & Piazza
    DeliveryLocationPoint(
      subcity: 'Arada',
      landmark: 'Piazza / St. George Cathedral Area',
      description: 'De Gaulle Square, Churchill Ave',
      latitude: 9.0350,
      longitude: 38.7512,
    ),
    DeliveryLocationPoint(
      subcity: 'Arada',
      landmark: '4 Kilo / Parliament & AAU Campus',
      description: 'King George VI St., National Museum vicinity',
      latitude: 9.0378,
      longitude: 38.7625,
    ),

    // Lideta & Mexico
    DeliveryLocationPoint(
      subcity: 'Lideta',
      landmark: 'Mexico Square / Senga Tera Financial District',
      description: 'Near Ethiopian Airlines Ticket Office & Banks Hub',
      latitude: 9.0124,
      longitude: 38.7441,
    ),
    DeliveryLocationPoint(
      subcity: 'Lideta',
      landmark: 'Lideta Condominium / Church',
      description: 'Balcha Hospital & Federal High Court Axis',
      latitude: 9.0062,
      longitude: 38.7368,
    ),

    // Gulele
    DeliveryLocationPoint(
      subcity: 'Gulele',
      landmark: 'Shiro Meda Artisan Craft Market',
      description: 'Entoto Ave, Traditional Cotton & Tibeb Center',
      latitude: 9.0556,
      longitude: 38.7621,
    ),

    // Nifas Silk-Lafto
    DeliveryLocationPoint(
      subcity: 'Nifas Silk-Lafto',
      landmark: 'Sarbet / Old Airport (Vatican)',
      description: 'AU HQ Vicinity, Roosevelt St.',
      latitude: 8.9958,
      longitude: 38.7352,
    ),
    DeliveryLocationPoint(
      subcity: 'Nifas Silk-Lafto',
      landmark: 'Jemo 1 / Glass Factory Roundabout',
      description: 'Jemo Condominium Main Gate',
      latitude: 8.9568,
      longitude: 38.7185,
    ),

    // Akaki-Kality
    DeliveryLocationPoint(
      subcity: 'Akaki-Kality',
      landmark: 'Kality Customs / Drivers Training Center',
      description: 'Kality Roundabout, Expressway Junction',
      latitude: 8.9054,
      longitude: 38.7654,
    ),

    // Kolfe Keranio
    DeliveryLocationPoint(
      subcity: 'Kolfe Keranio',
      landmark: 'Tor Hailoch / Total Roundabout',
      description: 'Ambo Road, Armed Forces General Hospital Area',
      latitude: 9.0185,
      longitude: 38.7214,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Default to the first match in current selected subcity or Bole
    _selectedPoint = _availablePoints.firstWhere(
      (p) => p.subcity.toLowerCase() == widget.initialSubcity.toLowerCase(),
      orElse: () => _availablePoints.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredList = _availablePoints.where((p) {
      if (_searchFilter.isEmpty) return true;
      final q = _searchFilter.toLowerCase();
      return p.landmark.toLowerCase().contains(q) ||
          p.subcity.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pin_drop_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dispatch Pin Picker',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Zero-cost GPS coordinates for couriers',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Visual Interactive Map Canvas Widget
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131D38) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Stack(
              children: [
                // Stylized Vector Map Grid
                CustomPaint(
                  size: Size.infinite,
                  painter: _MapGridPainter(isDark: isDark),
                ),

                // Center Pin with Pulse
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _selectedPoint.landmark,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(
                        Icons.location_on_rounded,
                        size: 38,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ),

                // GPS Badge in corner
                Positioned(
                  bottom: 8,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'GPS: ${_selectedPoint.latitude.toStringAsFixed(4)}° N, ${_selectedPoint.longitude.toStringAsFixed(4)}° E',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Subcity: ${_selectedPoint.subcity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Search Field
          TextField(
            onChanged: (val) => setState(() => _searchFilter = val),
            decoration: InputDecoration(
              hintText: 'Search Addis Ababa landmark or subcity...',
              prefixIcon: const Icon(Icons.search_rounded),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              suffixIcon: _searchFilter.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () => setState(() => _searchFilter = ''),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 12),

          // Landmarks List
          Expanded(
            child: ListView.separated(
              itemCount: filteredList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final point = filteredList[index];
                final isSelected = point.landmark == _selectedPoint.landmark;

                return InkWell(
                  onTap: () {
                    setState(() => _selectedPoint = point);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (isDark ? AppColors.darkCard : AppColors.lightCard),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          size: 18,
                          color: isSelected ? AppColors.primary : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    point.landmark,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected ? AppColors.primary : null,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      point.subcity,
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                point.description,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Apply Location Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                widget.onLocationSelected(_selectedPoint);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: Text('Set Delivery Pin: ${_selectedPoint.landmark}'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Canvas Painter that renders vector road networks and grid patterns
class _MapGridPainter extends CustomPainter {
  final bool isDark;
  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = 1;

    final roadPaint = Paint()
      ..color = (isDark ? const Color(0xFF23355A) : const Color(0xFFCBD5E1))
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final highwayPaint = Paint()
      ..color = (isDark ? const Color(0xFF2C4472) : const Color(0xFF94A3B8))
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Grid lines
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Stylized Ring Road / Highways
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.3), highwayPaint);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.7, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width * 0.5, size.height * 0.8), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
