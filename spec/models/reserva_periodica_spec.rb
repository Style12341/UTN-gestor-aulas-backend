require 'rails_helper'

RSpec.describe ReservaPeriodica, type: :model do
  before do
    # Create a bedel and a few reservas to query later
    @bedel = Bedel.create!(id: 'bedel', turno: Bedel.turnos.keys.sample, nombre: 'Juan', apellido: 'Perez',
                           password: '12&A45678')
    hash_reserva = { id_docente: '1', nombre_docente: 'Juan', apellido_docente: 'Perez',
                     correo_docente: 'test@test.com', id_curso: 1, nombre_curso: 'Curso', año: (Date.today - 1.year).year, cantidad_alumnos: 15, fecha_solicitud: Date.today - 1.year, periodicidad: :anual }
    @reserva_curso_1 = @bedel.reservas_periodicas.create!(hash_reserva)
    hash_reserva[:año] = Date.today.year
    hash_reserva[:fecha_solicitud] = Date.today - 1.day
    @reservas_ids = []
    @reservas_ids << @bedel.reservas_periodicas.create!(hash_reserva).id
    hash_reserva[:periodicidad] = :cuatrimestre_1
    @reservas_ids << @bedel.reservas_periodicas.create!(hash_reserva).id
    hash_reserva[:fecha_solicitud] = Date.today - 1.week
    hash_reserva[:periodicidad] = :cuatrimestre_2
    @reservas_ids << @bedel.reservas_periodicas.create!(hash_reserva).id
  end
  scenario 'Should return current year valid reservas' do
    expect(ReservaPeriodica.get_reservas_ids_in_ano_periodicidad(Date.today.year, :anual)).to eq(@reservas_ids)
  end
  scenario 'Should only return anuales and cuatrimestre_1 reservas' do
    expect(ReservaPeriodica.get_reservas_ids_in_ano_periodicidad(Date.today.year,
                                                             :cuatrimestre_1)).to eq(@reservas_ids[0..1])
  end
  scenario 'Should only return anuales and cuatrimestre_2 reservas' do
    expect(ReservaPeriodica.get_reservas_ids_in_ano_periodicidad(Date.today.year,
                                                             :cuatrimestre_2)).to eq([@reservas_ids[0],
                                                                                                 @reservas_ids[2]])
  end
end
