import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mascota_provider.dart';
import '../widgets/mascota_robot.dart';
import '../models/mascota_dialogos.dart';
import 'vital_signs_input_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MascotaProvider>(context, listen: false).saludar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VitalMovil'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade400,
      ),
      body: Consumer<MascotaProvider>(
        builder: (context, mascotaProvider, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        MascotaRobot(
                          mascotaState: mascotaProvider.mascotaState,
                          onTap: () {
                            mascotaProvider.mostrarTip(
                              MascotaDialogos.obtenerTip(),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        _buildBotonesInicio(context, mascotaProvider),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Vitales'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Mapas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildBotonesInicio(
      BuildContext context, MascotaProvider mascotaProvider) {
    return Column(
      children: [
        _buildBotonPrincipal(
          icon: Icons.medical_services,
          label: 'Medir Signos Vitales',
          color: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VitalSignsInputScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 15),
        _buildBotonPrincipal(
          icon: Icons.location_on,
          label: 'Centros de Salud',
          color: Colors.green,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mapa en desarrollo 🗺️')),
            );
          },
        ),
        const SizedBox(height: 15),
        _buildBotonPrincipal(
          icon: Icons.history,
          label: 'Historial',
          color: Colors.orange,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Historial en desarrollo 📊')),
            );
          },
        ),
        const SizedBox(height: 15),
        _buildBotonPrincipal(
          icon: Icons.school,
          label: 'Aprende',
          color: Colors.purple,
          onPressed: () {
            mascotaProvider.mostrarTip(MascotaDialogos.obtenerTip());
          },
        ),
      ],
    );
  }

  Widget _buildBotonPrincipal({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
