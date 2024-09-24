require 'rails_helper'

RSpec.describe ReservaEsporadica, type: :model do
  before do
    # Create a bedel and a few reservas to query later
    @bedel = Bedel.create!(id: 'bedel', turno: Bedel.turnos.keys.sample, nombre: 'Juan', apellido: 'Perez',
                           password: '12&A45678')
    hash_reserva = { id_docente: '1', nombre_docente: 'Juan', apellido_docente: 'Perez',
                     correo_docente: 'test@test.com', id_curso: 1, nombre_curso: 'Curso', año: 2023, cantidad_alumnos: 15, fecha_solicitud: Date.today - 1.year }
    @reserva_curso_1 = @bedel.reservas_esporadicas.create!(hash_reserva)
    hash_reserva[:año] = 2024
    hash_reserva[:fecha_solicitud] = Date.today - 1.day
    @reservas_ids = []
    @reservas_ids << @bedel.reservas_esporadicas.create!(hash_reserva).id
    hash_reserva[:fecha_solicitud] = Date.today - 1.month
    @reservas_ids << @bedel.reservas_esporadicas.create!(hash_reserva).id
    hash_reserva[:fecha_solicitud] = Date.today - 1.week
    @reservas_ids << @bedel.reservas_esporadicas.create!(hash_reserva).id
  end
  scenario 'Should return no valid reservas before the given date and the start of year' do
    ReservaEsporadica.where(id: @reservas_ids).delete_all
    expect(ReservaEsporadica.get_overlap_reservas_ids_by_year(Date.today.year)).to be_empty
  end
  scenario 'Should return valid reservas before the given date and the start of year' do
    expect(ReservaEsporadica.get_overlap_reservas_ids_by_year(Date.today.year)).to eq(@reservas_ids)
  end
end
