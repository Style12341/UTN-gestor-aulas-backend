class Bedel < Usuario
  enum :turno, todos: 0, mañana: 1, tarde: 2, noche: 3
  validates :nombre, presence: true
  validates :apellido, presence: true
  validates :turno, presence: true
  validate :validate_password
  has_many :reservas, class_name: 'Reserva', dependent: :destroy, foreign_key: 'bedel_id'
  has_many :reservas_periodicas, class_name: 'ReservaPeriodica', dependent: :destroy, foreign_key: 'bedel_id'
  has_many :reservas_esporadicas, class_name: 'ReservaEsporadica', dependent: :destroy, foreign_key: 'bedel_id'

  def self.filter_by_turno_apellido(turno, apellido)
    turno = Bedel.turnos.keys if turno.blank?
    apellido = '' if apellido.blank?
    where(turno:).where('apellido ILIKE ?', "#{apellido}%")
  end

  private

  def validate_password
    errors_list = ValidacionesController.validate_password(password)
    errors_list.each do |error|
      errors.add(:errors, error)
    end
  end
end
