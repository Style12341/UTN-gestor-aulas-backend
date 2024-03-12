class ReservasController < ApplicationController
  include TimeHelper
  include ConflictVerifier
  # POST /reservas/periodica
  # receives array of reservations
  # each reservation has the following fields:
  # - bedel_id
  # - id_docente
  # - id_curso
  # - periodicidad
  # - correo_contacto
  # - cantidad_alumnos
  # - renglones [array of renglones]
  # - numero_aula
  # - dia
  # - hora_inicio
  # - duracion
  def create_periodica
    docente = DocentesController.get_docente_by_id(params[:id_docente])
    curso = CursosController.get_course_by_id(params[:id_curso])
    bedel = (params[:bedel_id] == 'admin' ? Bedel.first : Bedel.find(params[:bedel_id]))
    if docente.nil? || curso.nil?
      render json: { error: 'Docente o curso no encontrado' }, status: :bad_request
      return
    end
    reserva_params = { correo_docente: params[:correo_contacto], año: Time.now.year, cantidad_alumnos: params[:cantidad_alumnos], fecha_solicitud: Time.now,
                       periodicidad: params[:frecuencia], bedel: }.merge(docente).merge(curso)
    # wrap in a transaction
    ActiveRecord::Base.transaction do
      reserva = ReservaPeriodica.create!(reserva_params)
      params[:renglones].each do |r|
        hora_fin = get_hora_fin(r[:hora_inicio], r[:duracion])
        horario = get_time_range_string(r[:hora_inicio], hora_fin)
        aula = Aula.find_by(numero_aula: r[:numero_aula])
        if still_available(aula.id, horario, dia: day_to_wday(r[:dia]), frecuencia: reserva.periodicidad)
          reserva.add_renglon(r[:dia], horario, aula)
        else
          render json: { error: 'Error aula reservada', message: 'Hubo un error al seleccionar las aulas, por favor verifique la disponibilidad nuevamente' },
                 status: :conflict
          return
        end
      end
    end
    render json: { message: 'success' }, status: :created
  end

  # POST /reservas/esporadica
  # Same as esporadica but with fecha instead of dia in renglones
  def create_esporadica
    docente = DocentesController.get_docente_by_id(params[:id_docente])
    curso = CursosController.get_course_by_id(params[:id_curso])
    bedel = (params[:bedel_id] == 'admin' ? Bedel.first : Bedel.find(params[:bedel_id]))
    if docente.nil? || curso.nil?
      render json: { error: 'Docente o curso no encontrado' }, status: :bad_request
      return
    end
    reserva_params = { correo_docente: params[:correo_contacto], año: Time.now.year, cantidad_alumnos: params[:cantidad_alumnos], fecha_solicitud: Time.now,
                       periodicidad: params[:frecuencia], bedel: }.merge(docente).merge(curso)
    # wrap in a transaction
    ActiveRecord::Base.transaction do
      reserva = ReservaEsporadica.create(reserva_params)
      params[:renglones].each do |r|
        hora_fin = get_hora_fin(r[:hora_inicio], r[:duracion])
        horario = get_time_range_string(r[:hora_inicio], hora_fin)
        aula = Aula.find_by(numero_aula: r[:numero_aula])
        raise ActiveRecord::RecordInvalid unless still_available(aula.id, horario, fecha: r[:fecha])

        reserva.add_renglon(r[:fecha], horario, aula)
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: { error: 'Error aula reservada', message: 'Hubo un error al seleccionar las aulas, por favor verifique la disponibilidad nuevamente' },
           status: :conflict
  else
    render json: { message: 'success' }, status: :created
  end

  private

  def still_available(id_aula, horario, fecha: nil, dia: nil, frecuencia: nil)
    set_aulas_compatibles_ids([id_aula])
    set_ids_reservas(fecha:, frecuencia:)
    ids_aulas_conflicto = get_ids_aulas_conflicto(horario, fecha:, dia:, frecuencia:)
    !ids_aulas_conflicto.include?(id_aula)
  end
end
