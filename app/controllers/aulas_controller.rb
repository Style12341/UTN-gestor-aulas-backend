class AulasController < ApplicationController
  include TimeHelper
  attr_accessor :aulas_compatibles_ids

  # {
  #   frecuencia(opcional): …,
  #   tipo_aula: “regular” o “multimedia” o “informatica”,
  #   cantidad_alumnos: xx,
  #   renglones: [
  #     {
  #     id: 0,
  #       dia/fecha: …,
  #       hora_inicio: “10:30”,
  #       duracion: “1:30”,
  #     }
  #     …
  #   ]
  # }
  before_action :horario_valido?, only: %i[periodica esporadica]
  before_action :periodo_valido?, only: %i[periodica]
  before_action :fecha_valida?, only: %i[esporadica]
  def periodica
    # Obtencion de aulas que esten dentro del criterio de tipo_aula y capacidad >= cantidad_alumnos
    @ans = {}
    @conflictos = {}
    @aulas_compatibles_ids = Aula.get_compatibles(params[:tipo_aula], params[:cantidad_alumnos]).pluck(:id)
    return render json: { error: 'No hay aulas disponibles' } if @aulas_compatibles_ids.empty?

    # Se obtienen las reservas validas, aquellas que fueron realizadas este año, que caigan en el periodo de la reserva
    @frecuencia = params[:frecuencia]

    set_ids_overlap_periodica(@frecuencia)
    params[:renglones].each do |r|
      dia_numero = day_to_wday(r[:dia])
      hora_inicio = r[:hora_inicio]
      hora_fin = get_hora_fin(hora_inicio, r[:duracion])
      horario = get_time_range_string(hora_inicio, hora_fin)
      conflicto_ids_aulas = get_ids_aulas_conflicto(horario, dia: dia_numero, frecuencia: @frecuencia)
      aulas_disponibles = get_aulas_disponibles(@aulas_compatibles_ids, conflicto_ids_aulas)
      if aulas_disponibles
        @ans[r[:id]] = aulas_disponibles
      else
        @conflictos[r[:id]] = get_conflictos(horario, dia: dia_numero, frecuencia: @frecuencia)
      end
    end
    if @conflictos.present?
      render json: { error: 'Algunas reservas no encontraron algún aula disponible', conflictos: @conflictos },
             status: :conflict
    else
      render json: @ans, status: :accepted
    end
  end

  def esporadica
    # Obtencion de aulas que esten dentro del criterio de tipo_aula y capacidad >= cantidad_alumnos
    @ans = {}
    @conflictos = {}
    @aulas_compatibles_ids = Aula.get_compatibles(params[:tipo_aula], params[:cantidad_alumnos]).pluck(:id)
    return render json: { error: 'No hay aulas disponibles' } if @aulas_compatibles_ids.empty?

    params[:renglones].each do |r|
      fecha = r[:fecha]
      set_ids_overlap_esporadica(fecha)
      hora_inicio = r[:hora_inicio]
      hora_fin = get_hora_fin(hora_inicio, r[:duracion])
      horario = get_time_range_string(hora_inicio, hora_fin)
      conflicto_ids_aulas = get_ids_aulas_conflicto(horario, fecha:)
      aulas_disponibles = get_aulas_disponibles(@aulas_compatibles_ids, conflicto_ids_aulas)
      if aulas_disponibles
        @ans[r[:id]] = aulas_disponibles
      else
        @conflictos[r[:id]] = get_conflictos(horario, fecha:)
      end
      @ids_reservas_p_overlap = nil
    end
    if @conflictos.present?
      render json: { error: 'Algunas reservas no encontraron algún aula disponible', conflictos: @conflictos },
             status: :conflict
    else
      render json: @ans, status: :accepted
    end
  end

  def get_ids_aulas_conflicto(horario, fecha: nil, dia: nil, frecuencia: nil)
    conflicto_dias_ids_aulas = RenglonReservaEsporadica.get_ids_aulas_conflictos(@aulas_compatibles_ids, @ids_reservas_e_overlap, horario, dia:,fecha:, frecuencia:)
    conflicto_periodos_ids_aulas = RenglonReservaPeriodica.get_ids_aulas_conflictos(
      @aulas_compatibles_ids, @ids_reservas_p_overlap, horario, dia:, fecha:
    )
    (conflicto_dias_ids_aulas + conflicto_periodos_ids_aulas).uniq
  end

  def set_ids_overlap(fecha: nil, frecuencia: nil)
    set_ids_overlap_esporadica(fecha) if fecha
    set_ids_overlap_periodica(frecuencia) if frecuencia
  end

  def set_ids_overlap_periodica(frecuencia)
    @ids_reservas_p_overlap ||= ReservaPeriodica.get_overlap_reservas_ids_by_periodicidad(Time.now.year,
                                                                                          frecuencia)
    @ids_reservas_e_overlap ||= ReservaEsporadica.get_overlap_reservas_ids_by_year(Time.now.year)
  end

  def set_ids_overlap_esporadica(fecha)
    @ids_reservas_e_overlap ||= ReservaEsporadica.get_overlap_reservas_ids_by_year(Time.now.year)
    @ids_reservas_p_overlap ||= ReservaPeriodica.get_overlap_reservas_ids_by_fecha(fecha)
  end

  private

  def get_conflictos(horario, dia: nil, fecha: nil, frecuencia: nil)
    least_conflicto_dias = RenglonReservaEsporadica.get_conflictos_with_least_overlap(@aulas_compatibles_ids,
                                                                                      @ids_reservas_e_overlap, horario, dia:, fecha:, frecuencia:)
    RenglonReservaPeriodica.get_conflictos(@aulas_compatibles_ids, @ids_reservas_p_overlap, horario, fecha:, dia:)
                           .find_with_least_overlap(range_or_from: horario).to_a.pluck(:overlap, :reserva_id, :aula_id, :horario, :fecha)
    least_conflicto_periodos = RenglonReservaPeriodica.get_conflictos_with_least_overlap(@aulas_compatibles_ids,
                                                                                         @ids_reservas_p_overlap, horario, dia:, fecha:)
    join_conflictos_serialize(least_conflicto_dias, least_conflicto_periodos)
  end

  def join_conflictos_serialize(least_conflicto_dias, least_conflicto_periodos)
    # Dado ambos conflictos nos quedamos con el que tenga menor overlap, verificar si existe primero
    overlap_dias = least_conflicto_dias[0][0] if least_conflicto_dias[0]
    overlap_periodos = least_conflicto_periodos[0][0] if least_conflicto_periodos[0]
    # Overlap is given in "HH:MM" format
    if overlap_dias == overlap_periodos
      conflictos = least_conflicto_dias + least_conflicto_periodos
    elsif !overlap_periodos || (overlap_dias && overlap_dias < overlap_periodos)
      conflictos = least_conflicto_dias
    elsif overlap_periodos
      conflictos = least_conflicto_periodos
    end
    conflictos.map do |overlap, reserva_id, aula_id, horario, fecha|
      reserva = Reserva.find(reserva_id)
      aula = Aula.find(aula_id)
      {
        aula: aula.numero_aula,
        fecha: fecha || 'Periodica',
        # Horario is a range of dates, we need to get the start hours and end hours
        horario: "#{horario.begin.strftime('%H:%M')} - #{horario.end.strftime('%H:%M')}",
        superposicion: overlap,
        docente: reserva.nombre_docente + ' ' + reserva.apellido_docente,
        curso: reserva.nombre_curso,
        correo: reserva.correo_docente
      }
    end
  end

  def get_aulas_disponibles(aulas_compatibles_ids, conflicto_ids_aulas)
    # Get elements from aulas_compatibles_ids that are not in conflicto_ids_aulas given that both are arrays
    aulas_libres_ids = aulas_compatibles_ids - conflicto_ids_aulas
    Aula.get_aulas_with_caracteristicas(aulas_libres_ids)
  end

  def horario_valido?
    # Para cada renglon verificar si es un horario valido
    ans = []
    params[:renglones].each do |r|
      hora_inicio = r[:hora_inicio]
      duracion = r[:duracion]
      ans.push(r[:id]) unless hora_fin_after_inicio(hora_inicio, get_hora_fin(hora_inicio, duracion))
    end
    return true if ans.empty?

    render json: { error: 'Existen horarios invalidos', conflictos: ans }, status: :bad_request
    false
  end

  # Si la fecha actual es posterior a la de finalizacion del cuatrimestre actual se considera invalido
  def periodo_valido?
    frecuencia = params[:frecuencia]
    return true if frecuencia == 'cuatrimestre_2'

    fin_cuatrimestre_uno = Periodo.final_cuatrimestre_1_actual
    return true if Time.now <= fin_cuatrimestre_uno

    frecuencia = '1er cuatrimestre' if frecuencia == 'cuatrimestre_1'
    render json: { error: 'periodo invalido', message: "No será posible realizar una reserva del tipo #{frecuencia} al haber finalizado el primer cuatrimestre." },
           status: :bad_request
    false
  end

  # Fecha recibida es mayor o igual a la actual
  def fecha_valida?
    params[:renglones].each do |r|
      fecha = r[:fecha]
      next unless fecha.to_date < Time.now.to_date

      render json: { error: 'fecha invalida', message: 'No será posible realizar una reserva para una fecha anterior a la actual.' },
             status: :bad_request
      return false
    end
    true
  end
end
