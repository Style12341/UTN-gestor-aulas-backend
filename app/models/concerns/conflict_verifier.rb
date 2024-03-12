module ConflictVerifier
  def set_aulas_compatibles_ids(ids)
    @aulas_compatibles_ids = ids
  end

  def get_ids_aulas_conflicto(horario, fecha: nil, dia: nil, frecuencia: nil)
    conflicto_dias_ids_aulas = RenglonReservaEsporadica.get_ids_aulas_conflictos(@aulas_compatibles_ids,
                                                                                 @ids_reservas_e_overlap, horario, dia:, fecha:, frecuencia:)
    conflicto_periodos_ids_aulas = RenglonReservaPeriodica.get_ids_aulas_conflictos(
      @aulas_compatibles_ids, @ids_reservas_p_overlap, horario, dia:, fecha:
    )
    (conflicto_dias_ids_aulas + conflicto_periodos_ids_aulas).uniq
  end

  def set_ids_reservas(fecha: nil, frecuencia: nil)
    set_ids_esporadica(fecha) if fecha
    set_ids_periodica(frecuencia) if frecuencia
  end

  private
  def set_ids_periodica(frecuencia)
    @ids_reservas_p_overlap ||= ReservaPeriodica.get_reservas_ids_in_ano_periodicidad(Time.now.year,
                                                                                      frecuencia)
    @ids_reservas_e_overlap ||= ReservaEsporadica.get_reservas_ids_by_year(Time.now.year)
  end

  def set_ids_esporadica(fecha)
    @ids_reservas_e_overlap ||= ReservaEsporadica.get_reservas_ids_by_year(Time.now.year)
    @ids_reservas_p_overlap ||= ReservaPeriodica.get_reservas_ids_by_fecha(fecha)
  end
end
