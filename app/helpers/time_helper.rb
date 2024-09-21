module TimeHelper
  def get_hora_fin(hora_inicio, duracion)
    # Devuelve la hora de fin de la reserva en formato string
    hora_inicio = Time.parse(hora_inicio)
    duracion_partes = duracion.split(':').map(&:to_i)
    hora_fin = hora_inicio + duracion_partes[0].hours + duracion_partes[1].minutes
    hora_fin.strftime('%H:%M')
  end

  def get_time_range_string(hora_inicio, hora_fin)
    # Devuelve un string con el rango de horas en formato "(hh:mm,hh:mm)"
    "[#{hora_inicio},#{hora_fin})"
  end
  # Compara dos horas en formato string y devuelve true si la hora de fin es posterior a la hora de inicio en el caso de 22:00 y 04:00 devuelve false
  def hora_fin_after_inicio(hora_inicio,hora_fin)
    hora_inicio = Time.parse(hora_inicio)
    hora_fin = Time.parse(hora_fin)
    hora_fin > hora_inicio
  end
end
