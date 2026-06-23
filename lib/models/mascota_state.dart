enum EstadoMascota { feliz, normal, preocupado, celebrando, pensando }

class MascotaState {
  EstadoMascota estado;
  String mensaje;
  DateTime ultimaActualizacion;

  MascotaState({
    this.estado = EstadoMascota.normal,
    this.mensaje = '¡Hola! Soy tu enfermero robot',
    required this.ultimaActualizacion,
  });

  void actualizarEstado(EstadoMascota nuevoEstado, String nuevoMensaje) {
    estado = nuevoEstado;
    mensaje = nuevoMensaje;
    ultimaActualizacion = DateTime.now();
  }

  void reaccionarAPresion(double sistolica, double diastolica) {
    if (sistolica < 120 && diastolica < 80) {
      actualizarEstado(EstadoMascota.feliz, '¡Excelente presión! 💚');
    } else if (sistolica < 140 && diastolica < 90) {
      actualizarEstado(EstadoMascota.preocupado, 'Tu presión está elevada ⚠️');
    } else {
      actualizarEstado(EstadoMascota.preocupado, '¡Busca ayuda médica! 🚨');
    }
  }

  void reaccionarAFrecuenciaCardiaca(int fc) {
    if (fc >= 60 && fc <= 100) {
      actualizarEstado(EstadoMascota.feliz, '¡Pulso perfecto! 💓');
    } else {
      actualizarEstado(EstadoMascota.preocupado, 'Tu pulso está fuera de rango');
    }
  }

  void celebrar() {
    actualizarEstado(EstadoMascota.celebrando, '¡Excelente trabajo! 🎉');
  }

  void pensar() {
    actualizarEstado(EstadoMascota.pensando, 'Analizando tus signos vitales...');
  }
}
