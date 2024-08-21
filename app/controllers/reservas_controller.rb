class ReservasController < ApplicationController
  include TimeHelper
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
    if docente.nil? || curso.nil?
      render json: { error: 'Docente o curso no encontrado' }, status: :not_found
      return
    end
    reserva_params = { correo_docente: params[:correo_contacto], año: Time.now.year, cantidad_alumnos: params[:cantidad_alumnos], fecha_solicitud: Time.now,
                       periodicidad: params[:frecuencia], bedel_id: params[:bedel_id] }.merge(docente).merge(curso)
    # wrap in a transaction
    reserva = ReservaPeriodica.create!(reserva_params)
    params[:renglones].each do |r|
      hora_fin = get_hora_fin(r[:hora_inicio], r[:duracion])
      horario = get_time_range_string(r[:hora_inicio], hora_fin)
      aula = Aula.find_by(numero_aula: r[:numero_aula])
      reserva.renglones.create!(dia: r[:dia], horario:, aula:)
    end
    render json: { message: 'success' }, status: :created
  end

  # POST /reservas/esporadica
  # Same as esporadica but with fecha instead of dia in renglones
  def create_esporadica
    docente = DocentesController.get_docente_by_id(params[:id_docente])
    curso = CursosController.get_course_by_id(params[:id_curso])
    if docente.nil? || curso.nil?
      render json: { error: 'Docente o curso no encontrado' }, status: :not_found
      return
    end
    reserva_params = { correo_docente: params[:correo_contacto], año: Time.now.year, cantidad_alumnos: params[:cantidad_alumnos], fecha_solicitud: Time.now,
                       periodicidad: params[:frecuencia], bedel_id: params[:bedel_id] }.merge(docente).merge(curso)
    # wrap in a transaction
    reserva = ReservaEsporadica.create!(reserva_params)
    params[:renglones].each do |r|
      hora_fin = get_hora_fin(r[:hora_inicio], r[:duracion])
      horario = get_time_range_string(r[:hora_inicio], hora_fin)
      aula = Aula.find_by(numero_aula: r[:numero_aula])
      reserva.renglones.create!(fecha: r[:fecha], horario:, aula:)
    end
    render json: { message: 'success' }, status: :created
  end

  # get out of params
end
