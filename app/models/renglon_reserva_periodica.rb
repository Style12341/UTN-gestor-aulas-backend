class RenglonReservaPeriodica < ApplicationRecord
  include FindWithLeastOverlap
  validates_presence_of RenglonReservaPeriodica.attribute_names - %w[id]
  enum :dia, lunes: 1, martes: 2, miercoles: 3, jueves: 4, viernes: 5, sabado: 6, domingo: 0
  belongs_to :reserva, class_name: 'ReservaPeriodica', foreign_key: 'reserva_id'
  belongs_to :aula, class_name: 'Aula', foreign_key: 'aula_id'

  def self.get_conflictos(ids_aulas, ids_reservas, horario, dia: nil, fecha: nil)
    rel = RenglonReservaPeriodica.where(aula_id: ids_aulas, reserva_id: ids_reservas).where('horario && :horario',
                                                                                            horario:)
    if dia
      rel = rel.where(dia:)
    elsif fecha
      rel = rel.where(dia: fecha.to_date.wday)
    end
    rel
  end

  def self.get_ids_aulas_conflictos(ids_aulas, ids_reservas, horario, dia: nil, fecha: nil)
    get_conflictos(ids_aulas, ids_reservas, horario, dia:, fecha:).select(:aula_id).distinct.pluck(:aula_id)
  end

  def self.get_conflictos_with_least_overlap(ids_aulas,ids_reservas,horario,dia: nil, fecha: nil)
    get_conflictos(ids_aulas, ids_reservas, horario, dia:, fecha:).find_with_least_overlap(range_or_from: horario).to_a.pluck(:overlap, :reserva_id, :aula_id, :horario, :fecha)
  end


end
