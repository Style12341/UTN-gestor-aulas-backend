class Aula < ApplicationRecord
  validates_presence_of Aula.attribute_names - %w[id]
  enum tipo: { sin_recursos: 0, informatica: 1, multimedia: 2 }
  enum tipo_pizarron: { tiza: 0, marcador: 1 }
  has_many :periodos_reservados, class_name: 'RenglonReservaPeriodica', dependent: :destroy, foreign_key: 'aula_id'
  has_many :dias_reservados, class_name: 'RenglonReservaEsporadica', dependent: :destroy, foreign_key: 'aula_id'
  has_many :caracteristicas_aula, dependent: :destroy
  has_many :caracteristicas, through: :caracteristicas_aula
  # get caracteristicas with their cantidad on caracteristicas_aula
  def caracteristicas_con_cantidad
    caracteristicas_aula.map { |ca| { caracteristica: ca.caracteristica.nombre, cantidad: ca.cantidad } }
  end

  def add_caracteristica(caracteristica, cantidad)
    cantidad = [cantidad, 1].max
    caracteristica = Caracteristica.find_by(nombre: caracteristica) unless caracteristica.is_a? Caracteristica
    caracteristicas_aula.create(caracteristica:, cantidad:)
  end
end
