class Aula < ApplicationRecord
  validates_presence_of Aula.attribute_names - %w[id]
  enum tipo: { sin_recursos: 0, informatica: 1, multimedia: 2 }
  enum tipo_pizarron: { tiza: 0, marcador: 1 }
  has_many :periodos_reservados, class_name: 'RenglonReservaPeriodica', dependent: :destroy, foreign_key: 'aula_id'
  has_many :dias_reservados, class_name: 'RenglonReservaEsporadica', dependent: :destroy, foreign_key: 'aula_id'
end
