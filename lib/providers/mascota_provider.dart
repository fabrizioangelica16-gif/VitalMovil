import 'package:flutter/material.dart';
import '../models/mascota_state.dart';
import '../widgets/mascota_robot.dart';

class MascotaProvider extends ChangeNotifier {
  late MascotaState _mascotaState;

  MascotaProvider() {
    _mascotaState = MascotaState(
      ultimaActualizacion: DateTime.now(),
      mensaje: '¡Hola! Soy tu Enfermero Robot 🤖',
    );
  }

  MascotaState get mascotaState => _mascotaState;

  void saludar() {
    _mascotaState.actualizarEstado(
      EstadoMascota.feliz,
      '¡Hola! Soy tu enfermero robot, aquí para cuidar tu salud 💚',
    );
    notifyListeners();
  }

  void reaccionarAMedicion(double sistolica, double diastolica, int fc) {
    _mascotaState.pensar();
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      if (sistolica < 120 && diastolica < 80 && fc >= 60 && fc <= 100) {
        _mascotaState.celebrar();
      } else {
        _mascotaState.reaccionarAPresion(sistolica, diastolica);
      }
      notifyListeners();
    });
  }

  void mostrarTip(String tip) {
    _mascotaState.actualizarEstado(EstadoMascota.pensando, tip);
    notifyListeners();
  }

  void mostrarMotivacion(String motivacion) {
    _mascotaState.actualizarEstado(EstadoMascota.celebrando, motivacion);
    notifyListeners();
  }

  void resetear() {
    _mascotaState = MascotaState(
      ultimaActualizacion: DateTime.now(),
      mensaje: '¿Listos para medir tus signos vitales? 📊',
    );
    notifyListeners();
  }
}
