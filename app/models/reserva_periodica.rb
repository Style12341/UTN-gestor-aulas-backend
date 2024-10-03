class ReservaPeriodica < Reserva
  enum :periodicidad, anual: 0, cuatrimestre_1: 1, cuatrimestre_2: 2
  validates :periodicidad, presence: true
  has_many :renglones, class_name: 'RenglonReservaPeriodica', dependent: :destroy, foreign_key: 'reserva_id'
  # Se toman como validas las reservas solicitadas en el año dado y que caigan en el periodo de la reserva
  def self.get_overlap_reservas_ids_by_periodicidad(año, periodicidad)
    rel = where(año:)

    # Si no es anual se busca solo por ese periodo y las anualas
    rel = rel.where(periodicidad: [:anual, periodicidad]) if periodicidad != :anual

    # Si no se devuelven la de todos los periodos ya que es anual
    rel.pluck(:id)
  end

  # Se toman como validas las reservas solicitadas en el año dado y que caigan en el periodo de la fecha correspondiente
  def self.get_overlap_reservas_ids_by_fecha(fecha)
    fecha = fecha.to_date
    año = fecha.year
    periodicidad = Periodo.getPeriodoByFecha(fecha)
    where(año:).where(periodicidad: [:anual, periodicidad]).pluck(:id)
  end

  def add_renglon(dia, horario, aula)
    r = RenglonReservaPeriodica.new(dia:, horario:, aula:)
    renglones << r
  end
end
