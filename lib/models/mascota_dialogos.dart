class MascotaDialogos {
  static const Map<String, List<String>> saludos = {
    'inicial': [
      '¡Hola! Soy RoboEnfermero, tu asistente de salud 🤖',
      'Bienvenido, soy tu compañero de salud digital',
      '¡Hola estudiante! Listo para aprender sobre signos vitales',
    ],
    'toma_vitales': [
      '¿Vamos a medir tus signos vitales? 📊',
      'Es hora de un chequeo de salud',
      'Necesito que registres tus vitales hoy',
    ],
  };

  static const Map<String, List<String>> interpretacionBP = {
    'normal': [
      '¡Excelente! Tu presión está perfecta 💚',
      'Presión normal, sigue así',
      'Tu tensión es óptima, ¡bien hecho!',
    ],
    'elevada': [
      'Tu presión está un poco elevada, intenta relajarte',
      'Presión elevada, considera descansar',
      'Podría estar mejor, respira profundo',
    ],
    'hipertension1': [
      'Tu presión está en Hipertensión Etapa 1. Consulta un médico',
      '⚠️ Presión alta detectada. Busca atención médica',
      'Te recomiendo visitar un centro de salud',
    ],
    'hipertension2': [
      '🚨 Hipertensión Etapa 2. ¡Busca ayuda médica urgente!',
      '¡Necesitas atención médica ya!',
      'Por favor, dirígete a un hospital',
    ],
  };

  static const Map<String, List<String>> interpretacionFC = {
    'bradicardia': [
      'Tu frecuencia cardíaca está baja (Bradicardia)',
      'Pulso lento detectado, descansa un poco',
      'Tu corazón late lentamente, consulta si persiste',
    ],
    'normal': [
      '¡Tu corazón late perfectamente! 💓',
      'Frecuencia cardíaca excelente',
      'Tu pulso está en rango normal',
    ],
    'taquicardia': [
      'Tu frecuencia cardíaca está elevada (Taquicardia)',
      'Tu pulso está rápido, intenta calmarte',
      'Ritmo cardíaco acelerado, respira lentamente',
    ],
  };

  static const Map<String, List<String>> tips = [
    '💡 Tip: Los signos vitales son indicadores clave de salud',
    '💡 Bebe agua regularmente para mantener la presión estable',
    '💡 El ejercicio regular ayuda a mantener un corazón sano',
    '💡 La presión arterial cambia durante el día, mide a la misma hora',
    '💡 El estrés puede aumentar tu presión arterial',
    '💡 Una buena noche de sueño es esencial para la salud',
    '💡 Come alimentos bajos en sodio para presión saludable',
    '💡 Medir tus vitales regularmente es importante para prevenir enfermedades',
  ];

  static const Map<String, List<String>> motivacion = [
    '¡Eres increíble por cuidar tu salud! 🌟',
    '¡Seguimos juntos en este camino hacia la salud! 💪',
    '¡Excelente trabajo! Mantén estos hábitos saludables',
    '¡Lo estás haciendo bien! Sigue adelante',
    '¡Tu salud es prioridad! Gracias por medirte',
  ];

  static String obtenerDialogo(String categoria, String tipo) {
    final dialogos = saludos[categoria] ?? [];
    if (dialogos.isEmpty) return 'Hola, ¿cómo estás?';
    return dialogos[DateTime.now().millisecond % dialogos.length];
  }

  static String obtenerMensajePresion(String estado) {
    final mensajes = interpretacionBP[estado] ?? [];
    if (mensajes.isEmpty) return 'Consulta un especialista';
    return mensajes[DateTime.now().millisecond % mensajes.length];
  }

  static String obtenerMensajeFC(String estado) {
    final mensajes = interpretacionFC[estado] ?? [];
    if (mensajes.isEmpty) return 'Mantén un ritmo cardíaco saludable';
    return mensajes[DateTime.now().millisecond % mensajes.length];
  }

  static String obtenerTip() {
    return tips[DateTime.now().millisecond % tips.length];
  }

  static String obtenerMotivacion() {
    return motivacion[DateTime.now().millisecond % motivacion.length];
  }
}
