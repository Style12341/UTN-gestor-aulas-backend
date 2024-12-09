class Aula < ApplicationRecord
  validates_presence_of Aula.attribute_names - %w[id]
  enum :tipo, regular: 0, sin_recursos: 0, informatica: 1, multimedia: 2
  enum :tipo_pizarron, tiza: 0, marcador: 1
  has_many :periodos_reservados, class_name: 'RenglonReservaPeriodica', dependent: :destroy, foreign_key: 'aula_id'
  has_many :dias_reservados, class_name: 'RenglonReservaEsporadica', dependent: :destroy, foreign_key: 'aula_id'
  has_many :caracteristicas_aula, dependent: :destroy
  has_many :caracteristicas, through: :caracteristicas_aula

  #   # Returns an array of hashes , each hash will have aula informations and the caracteristicas with their cantidad
  def self.get_aulas_with_caracteristicas(aulas)
    aulas.map do |a|
      { aula: a.numero_aula, piso: a.piso, capacidad: a.capacidad, tipo_pizarron: a.tipo_pizarron.capitalize,
        caracteristicas: a.caracteristicas_con_cantidad }
    end
  end

  def self.get_compatibles(tipo, cantidad_alumnos)
    where(tipo:).where('capacidad >= ?', cantidad_alumnos)
  end

  # get caracteristicas with their cantidad on caracteristicas_aula
  def caracteristicas_con_cantidad
    # Load all caractristicas
    caracteristicas_aula.includes(:caracteristica).map do |ca|
      { nombre: ca.caracteristica.nombre, cantidad: ca.cantidad }
    end
  end

  def add_caracteristica(caracteristica, cantidad)
    cantidad = [cantidad, 1].max
    caracteristica = Caracteristica.find_by(nombre: caracteristica) unless caracteristica.is_a? Caracteristica
    caracteristicas_aula.create(caracteristica:, cantidad:)
  end
end
