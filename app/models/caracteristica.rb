class Caracteristica < ApplicationRecord
  has_many :caracteristicas_aula, dependent: :destroy
  has_many :aulas, through: :caracteristicas_aula
end
