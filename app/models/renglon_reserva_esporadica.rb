class RenglonReservaEsporadica < ApplicationRecord
  include FindWithLeastOverlap

  validates_presence_of RenglonReservaEsporadica.attribute_names - %w[id]
  belongs_to :reserva, class_name: 'ReservaEsporadica', foreign_key: 'reserva_id'
  belongs_to :aula, class_name: 'Aula', foreign_key: 'aula_id'

end
