import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../models/health_center.dart';
import '../services/location_service.dart';
import '../providers/mascota_provider.dart';
import '../widgets/mascota_robot.dart';

class HealthCentersMapScreen extends StatefulWidget {
  const HealthCentersMapScreen({Key? key}) : super(key: key);

  @override
  State<HealthCentersMapScreen> createState() => _HealthCentersMapScreenState();
}

class _HealthCentersMapScreenState extends State<HealthCentersMapScreen> {
  late GoogleMapController mapController;
  final LocationService _locationService = LocationService();
  Position? _currentPosition;
  Set<Marker> _markers = {};
  List<HealthCenter> _healthCenters = [];
  List<HealthCenter> _filteredCenters = [];
  String _selectedType = 'Todos';
  final List<String> _types = ['Todos', 'Hospital', 'Centro de Salud', 'Clínica'];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      Position? position = await _locationService.getCurrentLocation();
      if (position != null) {
        setState(() => _currentPosition = position);
        _loadHealthCenters();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error obteniendo ubicación: $e')),
      );
    }
  }

  void _loadHealthCenters() {
    // Datos de ejemplo - puedes agregar más o cargar desde Firestore
    _healthCenters = [
      HealthCenter(
        id: '1',
        name: 'Hospital Central',
        address: 'Calle Principal 123',
        latitude: _currentPosition!.latitude + 0.01,
        longitude: _currentPosition!.longitude + 0.01,
        phone: '+1 555-0001',
        type: 'Hospital',
        distance: '1.2 km',
      ),
      HealthCenter(
        id: '2',
        name: 'Centro de Salud La Paz',
        address: 'Av. Libertad 456',
        latitude: _currentPosition!.latitude - 0.005,
        longitude: _currentPosition!.longitude + 0.015,
        phone: '+1 555-0002',
        type: 'Centro de Salud',
        distance: '2.5 km',
      ),
      HealthCenter(
        id: '3',
        name: 'Clínica San José',
        address: 'Carrera 10 # 50',
        latitude: _currentPosition!.latitude + 0.008,
        longitude: _currentPosition!.longitude - 0.012,
        phone: '+1 555-0003',
        type: 'Clínica',
        distance: '3.1 km',
      ),
      HealthCenter(
        id: '4',
        name: 'Hospital Regional',
        address: 'Calle 80 # 15-40',
        latitude: _currentPosition!.latitude - 0.015,
        longitude: _currentPosition!.longitude - 0.01,
        phone: '+1 555-0004',
        type: 'Hospital',
        distance: '4.8 km',
      ),
      HealthCenter(
        id: '5',
        name: 'Centro Médico Integral',
        address: 'Cra 7 # 45-30',
        latitude: _currentPosition!.latitude + 0.002,
        longitude: _currentPosition!.longitude + 0.008,
        phone: '+1 555-0005',
        type: 'Centro de Salud',
        distance: '1.8 km',
      ),
    ];

    _calculateDistances();
    _updateMarkers();
    _filterCenters();
  }

  void _calculateDistances() {
    for (var center in _healthCenters) {
      double distance = _locationService.calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        center.latitude,
        center.longitude,
      );
      center = HealthCenter(
        id: center.id,
        name: center.name,
        address: center.address,
        latitude: center.latitude,
        longitude: center.longitude,
        phone: center.phone,
        type: center.type,
        distance: '${distance.toStringAsFixed(1)} km',
      );
    }
    _healthCenters.sort((a, b) => double.parse(a.distance.split(' ')[0])
        .compareTo(double.parse(b.distance.split(' ')[0])));
  }

  void _updateMarkers() {
    _markers.clear();

    // Marcador de ubicación actual
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        infoWindow: const InfoWindow(title: 'Mi Ubicación'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      ),
    );

    // Marcadores de centros de salud
    for (var center in _healthCenters) {
      BitmapDescriptor iconColor;
      if (center.type == 'Hospital') {
        iconColor = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        );
      } else if (center.type == 'Clínica') {
        iconColor = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        );
      } else {
        iconColor = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        );
      }

      _markers.add(
        Marker(
          markerId: MarkerId(center.id),
          position: LatLng(center.latitude, center.longitude),
          infoWindow: InfoWindow(
            title: center.name,
            snippet: center.address,
            onTap: () => _showCenterDetails(center),
          ),
          icon: iconColor,
        ),
      );
    }

    setState(() {});
  }

  void _filterCenters() {
    if (_selectedType == 'Todos') {
      _filteredCenters = _healthCenters;
    } else {
      _filteredCenters =
          _healthCenters.where((c) => c.type == _selectedType).toList();
    }
    setState(() {});
  }

  void _showCenterDetails(HealthCenter center) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              center.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.location_on, center.address),
            _buildInfoRow(Icons.phone, center.phone),
            _buildInfoRow(Icons.local_hospital, center.type),
            _buildInfoRow(Icons.distance_on_outlined, center.distance),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openGoogleMaps(center),
                    icon: const Icon(Icons.directions),
                    label: const Text('Ruta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Provider.of<MascotaProvider>(context, listen: false)
                          .mostrarTip(
                        '📍 ${center.name} está a ${center.distance}',
                      );
                    },
                    icon: const Icon(Icons.favorite),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Future<void> _openGoogleMaps(HealthCenter center) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${center.latitude},${center.longitude}';
    // Aquí normalmente usarías url_launcher para abrir la URL
    // Por ahora solo mostramos el mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abriendo ruta a ${center.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centros de Salud Cercanos'),
        centerTitle: true,
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtros
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: _types
                        .map((type) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: FilterChip(
                                label: Text(type),
                                selected: _selectedType == type,
                                onSelected: (_) {
                                  setState(() => _selectedType = type);
                                  _filterCenters();
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
                // Mapa
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    onMapCreated: (controller) => mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 14,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
                // Lista de centros
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: _filteredCenters.length,
                    itemBuilder: (context, index) {
                      final center = _filteredCenters[index];
                      return ListTile(
                        leading: Icon(
                          center.type == 'Hospital'
                              ? Icons.local_hospital
                              : Icons.local_pharmacy,
                          color: center.type == 'Hospital'
                              ? Colors.red
                              : Colors.green,
                        ),
                        title: Text(center.name),
                        subtitle: Text(center.distance),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => _showCenterDetails(center),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
