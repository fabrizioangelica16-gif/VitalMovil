import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mascota_provider.dart';
import '../widgets/mascota_robot.dart';
import '../models/mascota_dialogos.dart';

class VitalSignsInputScreen extends StatefulWidget {
  const VitalSignsInputScreen({Key? key}) : super(key: key);

  @override
  State<VitalSignsInputScreen> createState() => _VitalSignsInputScreenState();
}

class _VitalSignsInputScreenState extends State<VitalSignsInputScreen> {
  final TextEditingController _sistolicaController = TextEditingController();
  final TextEditingController _diastolicaController = TextEditingController();
  final TextEditingController _fcController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();

  @override
  void dispose() {
    _sistolicaController.dispose();
    _diastolicaController.dispose();
    _fcController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  void _guardarMediciones() {
    final sistolica = double.tryParse(_sistolicaController.text) ?? 0;
    final diastolica = double.tryParse(_diastolicaController.text) ?? 0;
    final fc = int.tryParse(_fcController.text) ?? 0;

    if (sistolica > 0 && diastolica > 0 && fc > 0) {
      final mascotaProvider = Provider.of<MascotaProvider>(context, listen: false);
      mascotaProvider.reaccionarAMedicion(sistolica, diastolica, fc);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Mediciones guardadas! 📊')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar Signos Vitales')),
      body: Consumer<MascotaProvider>(
        builder: (context, mascotaProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Mascota
                MascotaRobot(
                  mascotaState: mascotaProvider.mascotaState,
                  onTap: () {
                    mascotaProvider.mostrarTip(MascotaDialogos.obtenerTip());
                  },
                ),
                const SizedBox(height: 30),
                // Formulario
                _buildCampo('Presión Sistólica (mmHg)', _sistolicaController),
                const SizedBox(height: 15),
                _buildCampo('Presión Diastólica (mmHg)', _diastolicaController),
                const SizedBox(height: 15),
                _buildCampo('Frecuencia Cardíaca (lpm)', _fcController),
                const SizedBox(height: 15),
                _buildCampo('Temperatura (°C)', _tempController),
                const SizedBox(height: 30),
                // Botones
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _guardarMediciones,
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          mascotaProvider.mostrarMotivacion(
                            MascotaDialogos.obtenerMotivacion(),
                          );
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text('Motivación'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCampo(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.medical_services),
      ),
    );
  }
}
