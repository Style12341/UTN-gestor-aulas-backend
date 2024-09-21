require 'rails_helper'

RSpec.describe 'Reservas', type: :request do
  before do
    @bedel = Bedel.create!(id: 'test', turno: :mañana, password: '12&A45678', nombre: 'test', apellido: 'test')
    @aula = Aula.create!(numero_aula: 1, capacidad: 40, piso: 1, tipo_pizarron: :tiza, habilitada: true, tipo: :regular)
    get '/cursos'
    @curso_id = JSON.parse(response.body).first[0]
    get '/docentes'
    @docente_id = JSON.parse(response.body).first[0]
  end

  scenario 'creates a reserva periodica' do
    post '/reservas/periodica', params: {
      bedel_id: @bedel.id,
      id_docente: @docente_id,
      id_curso: @curso_id,
      frecuencia: :cuatrimestre_1,
      correo_contacto: 'test@test.com',
      cantidad_alumnos: 40,
      renglones: [
        {
          numero_aula: @aula.numero_aula,
          dia: :lunes,
          hora_inicio: '08:00',
          duracion: '02:00'
        },
        {
          numero_aula: @aula.numero_aula,
          dia: :martes,
          hora_inicio: '08:00',
          duracion: '02:00'
        }
      ]
    }
    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)).to eq('message' => 'success')
    r = ReservaPeriodica.first
    expect(r.correo_docente).to eq('test@test.com')
    expect(r.cantidad_alumnos).to eq(40)
    expect(r.periodicidad).to eq('cuatrimestre_1')
    expect(r.bedel_id).to eq(@bedel.id)
    expect(r.id_docente).to eq(@docente_id)
    expect(r.renglones.count).to eq(2)
  end
  scenario 'creates a reserva esporadica' do
    post '/reservas/esporadica', params: {
      bedel_id: @bedel.id,
      id_docente: @docente_id,
      id_curso: @curso_id,
      correo_contacto: 'test@test.com',
      cantidad_alumnos: 40,
      renglones: [
        {
          numero_aula: @aula.numero_aula,
          fecha: '2021-01-01',
          hora_inicio: '08:00',
          duracion: '02:00'
        },
        {
          numero_aula: @aula.numero_aula,
          fecha: '2021-01-02',
          hora_inicio: '08:00',
          duracion: '02:00'
        }
      ]
    }
    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)).to eq('message' => 'success')
    r = ReservaEsporadica.first
    expect(r.correo_docente).to eq('test@test.com')
    expect(r.cantidad_alumnos).to eq(40)
    expect(r.periodicidad).to eq(nil)
    expect(r.bedel_id).to eq(@bedel.id)
    expect(r.id_docente).to eq(@docente_id)
    expect(r.renglones.count).to eq(2)
  end
  scenario 'returns not found if docente or curso is not found' do
    post '/reservas/esporadica', params: {
      bedel_id: @bedel.id,
      id_docente: @docente_id,
      id_curso: 9000,
      correo_contacto: 'test@test.com',
      cantidad_alumnos: 40,
      renglones: [
        {
          numero_aula: @aula.numero_aula,
          fecha: '2021-01-01',
          hora_inicio: '08:00',
          duracion: '02:00'
        },
        {
          numero_aula: @aula.numero_aula,
          fecha: '2021-01-02',
          hora_inicio: '08:00',
          duracion: '02:00'
        }
      ]
    }
    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)).to eq('error' => 'Docente o curso no encontrado')
    post '/reservas/periodica', params: {
      bedel_id: @bedel.id,
      id_docente: 9000,
      id_curso: @curso_id,
      frecuencia: :cuatrimestre_1,
      correo_contacto: 'test@test.com',
      cantidad_alumnos: 40,
      renglones: [
        {
          numero_aula: @aula.numero_aula,
          dia: :lunes,
          hora_inicio: '08:00',
          duracion: '02:00'
        },
        {
          numero_aula: @aula.numero_aula,
          dia: :martes,
          hora_inicio: '08:00',
          duracion: '02:00'
        }
      ]
    }
    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)).to eq('error' => 'Docente o curso no encontrado')
  end
  scenario 'admin can create reservas' do
    post '/reservas/esporadica', params: {
      bedel_id: 'admin',
      id_docente: @docente_id,
      id_curso: @curso_id,
      correo_contacto: 'test@test.com',
      cantidad_alumnos: 40,
      renglones: [
        {
          numero_aula: @aula.numero_aula,
          fecha: '2021-01-01',
          hora_inicio: '08:00',
          duracion: '02:00'
        },
        {
          numero_aula: @aula.numero_aula,
          fecha: '2021-01-02',
          hora_inicio: '08:00',
          duracion: '02:00'
        }
      ]
    }
    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)).to eq('message' => 'success')
  end
end
