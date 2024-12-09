require 'rails_helper'

RSpec.describe ReservaPeriodica, type: :model do
  before do
    # Create a bedel and a few reservas to query later
    @bedel = Bedel.create!(id: 'bedel', turno: Bedel.turnos.keys.sample, nombre: 'Juan', apellido: 'Perez',
                           password: '12&A45678')
    hash_reserva = { id_docente: '1', nombre_docente: 'Juan', apellido_docente: 'Perez',
                     correo_docente: 'test@test.com', id_curso: 1, nombre_curso: 'Curso', año: (Date.current - 1.year).year, cantidad_alumnos: 15, fecha_solicitud: Date.current - 1.year, periodicidad: :anual }
    @reserva_curso_1 = @bedel.reservas_periodicas.create!(hash_reserva)
    hash_reserva[:año] = Date.current.year
    hash_reserva[:fecha_solicitud] = Date.current - 1.day
    @reservas = []
    @reservas << @bedel.reservas_periodicas.create!(hash_reserva)
    hash_reserva[:periodicidad] = :cuatrimestre_1
    @reservas << @bedel.reservas_periodicas.create!(hash_reserva)
    hash_reserva[:fecha_solicitud] = Date.current - 1.week
    hash_reserva[:periodicidad] = :cuatrimestre_2
    @reservas << @bedel.reservas_periodicas.create!(hash_reserva)
  end
  scenario 'Should return current year valid reservas' do
    expect(ReservaPeriodica.get_reservas_in_ano_periodicidad(Date.current.year, :anual)).to eq(@reservas)
  end
  scenario 'Should only return anuales and cuatrimestre_1 reservas' do
    expect(ReservaPeriodica.get_reservas_in_ano_periodicidad(Date.current.year,
                                                             :cuatrimestre_1)).to eq(@reservas[0..1])
  end
  scenario 'Should only return anuales and cuatrimestre_2 reservas' do
    expect(ReservaPeriodica.get_reservas_in_ano_periodicidad(Date.current.year,
                                                             :cuatrimestre_2)).to eq([@reservas[0],
                                                                                                 @reservas[2]])
  end
end
