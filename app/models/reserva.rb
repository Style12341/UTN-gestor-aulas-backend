class Reserva < ApplicationRecord
  belongs_to :bedel, class_name: 'Bedel', foreign_key: 'bedel_id'
  validates_presence_of Reserva.attribute_names - %w[id periodicidad]
  validates :cantidad_alumnos, numericality: { only_integer: true, greater_than: 0 }
end
