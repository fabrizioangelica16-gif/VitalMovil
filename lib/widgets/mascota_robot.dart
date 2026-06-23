import 'package:flutter/material.dart';
import '../models/mascota_state.dart';

class MascotaRobot extends StatefulWidget {
  final MascotaState mascotaState;
  final VoidCallback? onTap;

  const MascotaRobot({
    Key? key,
    required this.mascotaState,
    this.onTap,
  }) : super(key: key);

  @override
  State<MascotaRobot> createState() => _MascotaRobotState();
}

class _MascotaRobotState extends State<MascotaRobot>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getColorPorEstado() {
    switch (widget.mascotaState.estado) {
      case EstadoMascota.feliz:
        return Colors.green;
      case EstadoMascota.preocupado:
        return Colors.orange;
      case EstadoMascota.celebrando:
        return Colors.blue;
      case EstadoMascota.pensando:
        return Colors.purple;
      default:
        return Colors.blue.shade400;
    }
  }

  IconData _getIconoPorEstado() {
    switch (widget.mascotaState.estado) {
      case EstadoMascota.feliz:
        return Icons.mood;
      case EstadoMascota.preocupado:
        return Icons.sentiment_dissatisfied;
      case EstadoMascota.celebrando:
        return Icons.celebration;
      case EstadoMascota.pensando:
        return Icons.school;
      default:
        return Icons.android;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cabeza del Robot
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 120,
                height: 140,
                decoration: BoxDecoration(
                  color: _getColorPorEstado(),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 3, color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      color: _getColorPorEstado().withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ojos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Boca (sonrisa/expresión)
                    _getColorPorEstado() == Colors.green
                        ? const Text('😊', style: TextStyle(fontSize: 30))
                        : _getColorPorEstado() == Colors.orange
                            ? const Text('😕', style: TextStyle(fontSize: 30))
                            : const Text('🤖', style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Cuerpo del Robot
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBoton(Colors.red),
                      _buildBoton(Colors.yellow),
                      _buildBoton(Colors.green),
                    ],
                  ),
                  // Display
                  Container(
                    width: 80,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Brazos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 15,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 80),
                Container(
                  width: 15,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Mensaje
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: _getColorPorEstado().withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _getColorPorEstado(),
                  width: 2,
                ),
              ),
              child: Text(
                widget.mascotaState.mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Emoji según estado
            Icon(
              _getIconoPorEstado(),
              size: 40,
              color: _getColorPorEstado(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoton(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1),
      ),
    );
  }
}
