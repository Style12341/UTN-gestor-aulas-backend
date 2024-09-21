class RenglonReservaPeriodica < ApplicationRecord
  include FindWithLeastOverlap
  validates_presence_of RenglonReservaPeriodica.attribute_names - %w[id]
  enum :dia, lunes: 1, martes: 2, miercoles: 3, jueves: 4, viernes: 5, sabado: 6, domingo: 0
  belongs_to :reserva, class_name: 'ReservaPeriodica', foreign_key: 'reserva_id'
  belongs_to :aula, class_name: 'Aula', foreign_key: 'aula_id'
end
