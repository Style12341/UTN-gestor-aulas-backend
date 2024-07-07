class RenglonReservaPeriodica < ApplicationRecord
  validates_presence_of RenglonReservaPeriodica.attribute_names - %w[id]
  enum dia: { lunes: 0, martes: 1, miercoles: 2, jueves: 3, viernes: 4, sabado: 5, domingo: 6 }
  belongs_to :reserva, class_name: 'ReservaPeriodica', foreign_key: 'reserva_id'
end
