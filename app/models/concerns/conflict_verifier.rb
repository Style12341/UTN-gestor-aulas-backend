module ConflictVerifier
  def set_aulas_compatibles(aulas)
    @aulas_compatibles = aulas
  end

  def get_aulas_conflicto(horario, fecha: nil, dia: nil, frecuencia: nil)
    conflicto_dias_aulas = RenglonReservaEsporadica.get_aulas_conflictos(@aulas_compatibles,
                                                                         @reservas_e_overlap, horario, dia:, fecha:, frecuencia:)
    conflicto_periodos_aulas = RenglonReservaPeriodica.get_aulas_conflictos(
      @aulas_compatibles, @reservas_p_overlap, horario, dia:, fecha:
    )
    (conflicto_dias_aulas + conflicto_periodos_aulas).uniq { |aula| aula.id }
  end

  def set_reservas(fecha: nil, frecuencia: nil)
    set_esporadica(fecha) if fecha
    set_periodica(frecuencia) if frecuencia
  end

  private

  def set_periodica(frecuencia)
    @reservas_p_overlap ||= ReservaPeriodica.get_reservas_in_ano_periodicidad(Time.now.year,
                                                                              frecuencia)
    @reservas_e_overlap ||= ReservaEsporadica.get_reservas_by_year(Time.now.year)
  end

  def set_esporadica(fecha)
    @reservas_e_overlap ||= ReservaEsporadica.get_reservas_by_year(Time.now.year)
    @reservas_p_overlap ||= ReservaPeriodica.get_reservas_by_fecha(fecha)
  end
end
