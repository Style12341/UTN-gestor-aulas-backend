require 'rails_helper'
# Reservas periodicas
RSpec.describe 'Esporadicas', type: :request do
  before do
    @bedel = Bedel.create!(id: 'bedel', turno: Bedel.turnos.keys.sample, nombre: 'Juan', apellido: 'Perez',
                           password: '123')
    @aula = Aula.create!(id: 1, piso: 1, numero_aula: 10, capacidad: 15, tipo: 'regular', tipo_pizarron: 'tiza',
                         habilitada: true)
    @caracteristica = Caracteristica.create!(nombre: 'Aire Acondicionado')
    @caracteristica_2 = Caracteristica.create!(nombre: 'Proyector')
    CaracteristicaAula.create!(aula: @aula, caracteristica: @caracteristica, cantidad: 2)
    CaracteristicaAula.create!(aula: @aula, caracteristica: @caracteristica_2, cantidad: 1)
    @reserva_pasado = @bedel.reservas_periodicas.create!(id_docente: '1', nombre_docente: 'Juan', apellido_docente: 'Perez', correo_docente: 'test@test.com',
                                                         id_curso: 1, nombre_curso: 'Curso', año: 2023, cantidad_alumnos: 15, fecha_solicitud: Date.today - 1.year, periodicidad: 'anual')
    @renglon_pasado = @reserva_pasado.renglones.create!(dia: 'lunes', horario: '[10:30, 13:00)', aula: @aula)

    @reserva_curso_1 = @bedel.reservas_periodicas.create!(id_docente: '1', nombre_docente: 'Juan', apellido_docente: 'Perez',
                                                          correo_docente: 'test@test.com', id_curso: 1, nombre_curso: 'Curso', año: 2024, cantidad_alumnos: 15, fecha_solicitud: Date.today, periodicidad: 'anual')
    @renglon_curso_1_lunes = @reserva_curso_1.renglones.create!(dia: 'lunes', horario: '[10:30, 13:00)',
                                                                aula: @aula)
    @renglon_curso_1_martes = @reserva_curso_1.renglones.create!(dia: 'martes', horario: '[10:30, 13:00)',
                                                                 aula: @aula)
    @reserva_curso_2 = @bedel.reservas_periodicas.create!(id_docente: '2', nombre_docente: 'Tomas', apellido_docente: 'Perez',
                                                          correo_docente: 'test@test.com', id_curso: 2, nombre_curso: 'Curso2', año: 2024, cantidad_alumnos: 15, fecha_solicitud: Date.today, periodicidad: 'anual')
    @renglon_curso_2_martes = @reserva_curso_2.renglones.create!(dia: 'martes', horario: '[15:30, 18:00)',
                                                                 aula: @aula)
    @renglon_curso_2_miercoles = @reserva_curso_2.renglones.create!(dia: 'miercoles', horario: '[15:30, 18:00)',
                                                                    aula: @aula)
    @reserva_curso_3 = @bedel.reservas_periodicas.create!(id_docente: '3', nombre_docente: 'Pepe', apellido_docente: 'Perez',
                                                          correo_docente: 'test@test.com', id_curso: 2, nombre_curso: 'Curso3', año: 2024, cantidad_alumnos: 15, fecha_solicitud: Date.today, periodicidad: 'anual')
    @renglon_curso_3_miercoles = @reserva_curso_3.renglones.create!(dia: 'jueves', horario: '[15:30, 18:00)',
                                                                    aula: @aula)
    @reserva_esporadica_miercoles = @bedel.reservas_esporadicas.create!(id_docente: '4', nombre_docente: 'Martin', apellido_docente: 'Perez',
                                                                        correo_docente: 'test@test.com', id_curso: 2, nombre_curso: 'Curso3', año: 2024, cantidad_alumnos: 15, fecha_solicitud: Date.today)
    @renglon_esporadica_miercoles = @reserva_esporadica_miercoles.renglones.create!(fecha: '2024/12/04'.to_date,
                                                                                    horario: '[15:30, 18:00)', aula: @aula)
    @reserva_to_make = {
      id_bedel: 'bedel', id_docente: '5', nombre_docente: 'Martin', apellido_docente: 'Perez', correo_docente: 'test@test.com', tipo_aula: 'regular', curso: 'test', cantidad_alumnos: 15, fecha_solicitud: Date.today, renglones: [{
        id: 0, fecha: '', hora_inicio: '11:30', duracion: '2:00'
      }]
    }
  end
  scenario 'Should return overlap with reserva periodica on Lunes recursos regulares' do
    # Obtenemos alguna fecha en la cual sea lunes
    @reserva_to_make[:renglones][0][:fecha] = Date.today.beginning_of_week.strftime('%Y/%m/%d')
    post disponibilidad_esporadica_url, params: @reserva_to_make
    expect(response).to have_http_status(:conflict)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    body = JSON.parse(response.body)
    # Body should contain the error message and data pertinent to show the overlap
    expect(body['error']).to eq('Algunas reservas no encontraron algún aula disponible')
    expect(body['conflictos']).to be_a(Hash)
    conflicto = body['conflictos']['0']
    expect(conflicto.size).to eq(1)
    conflicto.each do |obj|
      expect(obj.keys).to contain_exactly('aula', 'fecha', 'horario', 'superposicion', 'docente', 'curso', 'correo')
      expect(obj['aula']).to eq(@aula.numero_aula)
      expect(obj['fecha']).to eq('Periodica')
      expect(obj['horario']).to eq('10:30 - 13:00')
      expect(obj['superposicion']).to eq('01:30') # 1 hora y 30 minutos
      expect(obj['docente']).to eq('Juan Perez')
      expect(obj['curso']).to eq('Curso')
      expect(obj['correo']).to eq('test@test.com')
    end
  end
  scenario 'Should return two overlaps with reserva periodica on Martes recursos regulares' do
    @reserva_to_make[:renglones][0][:fecha] = Date.today.beginning_of_week.next_day.strftime('%Y/%m/%d')
    @reserva_to_make[:renglones][0][:hora_inicio] = '12:30'
    @reserva_to_make[:renglones][0][:duracion] = '3:30'
    post disponibilidad_esporadica_url, params: @reserva_to_make
    expect(response).to have_http_status(:conflict)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Pretty print json
    #
    body = JSON.parse(response.body)
    # Body should contain the error message and data pertinent to show the overlap
    expect(body['error']).to eq('Algunas reservas no encontraron algún aula disponible')
    expect(body['conflictos']).to be_a(Hash)
    conflicto = body['conflictos']['0']
    expect(conflicto.size).to eq(2)
    primer_renglon = conflicto[0]
    segundo_renglon = conflicto[1]
    expect(primer_renglon.keys).to contain_exactly('aula', 'fecha', 'horario', 'superposicion', 'docente', 'curso',
                                                   'correo')
    expect(primer_renglon['aula']).to eq(@aula.numero_aula)
    expect(primer_renglon['fecha']).to eq('Periodica')
    expect(primer_renglon['horario']).to eq('10:30 - 13:00')
    expect(primer_renglon['superposicion']).to eq('00:30') # 30 minutos
    expect(primer_renglon['docente']).to eq('Juan Perez')
    expect(primer_renglon['curso']).to eq('Curso')
    expect(primer_renglon['correo']).to eq('test@test.com')
    expect(segundo_renglon.keys).to contain_exactly('aula', 'fecha', 'horario', 'superposicion', 'docente', 'curso',
                                                    'correo')
    expect(segundo_renglon['aula']).to eq(@aula.numero_aula)
    expect(segundo_renglon['fecha']).to eq('Periodica')
    expect(segundo_renglon['horario']).to eq('15:30 - 18:00')
    expect(segundo_renglon['superposicion']).to eq('00:30') # 30 minutos
    expect(segundo_renglon['docente']).to eq('Tomas Perez')
    expect(segundo_renglon['curso']).to eq('Curso2')
    expect(segundo_renglon['correo']).to eq('test@test.com')
  end
  scenario 'Should return valid aula for reserva periodica on Martes recursos regulares in between classes' do
    @reserva_to_make[:renglones][0][:fecha] = Date.today.beginning_of_week.next_day.strftime('%Y/%m/%d')
    @reserva_to_make[:renglones][0][:hora_inicio] = '13:00'
    @reserva_to_make[:renglones][0][:duracion] = '2:30'
    post disponibilidad_esporadica_url, params: @reserva_to_make
    expect(response).to have_http_status(:accepted)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    body = JSON.parse(response.body)
    expect(body['0']).to be_a(Array)
    expect(body['0'].size).to eq(1)
    expect(body['0'][0].keys).to contain_exactly('aula', 'piso', 'capacidad', 'tipo_pizarron', 'caracteristicas')
    expect(body['0'][0]['aula']).to eq(@aula.numero_aula)
    expect(body['0'][0]['piso']).to eq(@aula.piso)
    expect(body['0'][0]['capacidad']).to eq(@aula.capacidad)
    expect(body['0'][0]['tipo_pizarron']).to eq(@aula.tipo_pizarron.capitalize)
    expect(body['0'][0]['caracteristicas']).to be_a(Array)
    expect(body['0'][0]['caracteristicas'].size).to eq(2)
    expect(body['0'][0]['caracteristicas'][0]['nombre']).to eq(@caracteristica.nombre)
    expect(body['0'][0]['caracteristicas'][0]['cantidad']).to eq(2)
    expect(body['0'][0]['caracteristicas'][1]['nombre']).to eq(@caracteristica_2.nombre)
    expect(body['0'][0]['caracteristicas'][1]['cantidad']).to eq(1)
  end
end
