class CaracteristicaAula < ApplicationRecord
  self.primary_key = %i[caracteristica_id aula_id]
  validates :cantidad, presence: true
  validates :aula_id, uniqueness: { scope: :caracteristica_id }
  belongs_to :caracteristica
  belongs_to :aula
end
