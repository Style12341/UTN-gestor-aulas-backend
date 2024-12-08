class RenglonReservaEsporadica < ApplicationRecord
  include FindWithLeastOverlap
  validates_presence_of RenglonReservaEsporadica.attribute_names - %w[id]
  belongs_to :reserva, class_name: 'ReservaEsporadica', foreign_key: 'reserva_id'
  belongs_to :aula, class_name: 'Aula', foreign_key: 'aula_id'

  def self.get_conflictos(ids_aulas, ids_reservas, horario, dia: nil, fecha: nil, frecuencia: nil)
    rel = where(aula_id: ids_aulas, reserva_id: ids_reservas).where('horario && :horario', horario:)
    # Se obtiene un intervalo de fechas para la frecuencia dada, para no tener renglones fuera de la frecuencia dada
    # ex, si la frecuencia es cuatrimestral_2 solo deberia haber renglones dentro del intervalo anual y del cuatrimestre 2
    if dia && frecuencia
      final = Periodo.getIntervalo(frecuencia).end
      inicio = DateTime.current
      # Si se pasa el dia se busca por dia,extrae que dia es de la fecha
      rel = rel.where("DATE_PART('dow', fecha) = :dia", dia:).where('fecha BETWEEN :inicio AND :final', inicio:, final:)
    elsif fecha
      rel = rel.where(fecha:)
    end
    rel
  end

  def self.get_ids_aulas_conflictos(ids_aulas, ids_reservas, horario, dia: nil, fecha: nil, frecuencia: nil)
    get_conflictos(ids_aulas, ids_reservas, horario, dia:, fecha:,
                                                     frecuencia:).select(:aula_id).distinct.pluck(:aula_id)
  end

  def self.get_conflictos_with_least_overlap(ids_aulas, ids_reservas, horario, dia: nil, fecha: nil, frecuencia: nil)
    get_conflictos(ids_aulas, ids_reservas, horario, dia:,
                                                     fecha:, frecuencia:).find_with_least_overlap(range_or_from: horario).to_a.pluck(
                                                       :overlap, :reserva_id, :aula_id, :horario, :fecha
                                                     )
  end
end
