class Periodo < ApplicationRecord
  self.primary_key = :año
  validates :inicio_cuatrimestre_uno, presence: true
  validates :fin_cuatrimestre_uno, presence: true
  validates :inicio_cuatrimestre_dos, presence: true
  validates :fin_cuatrimestre_dos, presence: true
  validate :validate_date_ranges

  private

  def validate_date_ranges
    year_start = Date.new(año, 1, 1)
    year_end = Date.new(año, 12, 31)
  
    if inicio_cuatrimestre_uno > fin_cuatrimestre_uno
      errors.add(:inicio_cuatrimestre_uno, 'no puede ser posterior a la fecha de fin del primer cuatrimestre')
    end
    if inicio_cuatrimestre_dos > fin_cuatrimestre_dos
      errors.add(:inicio_cuatrimestre_dos, 'no puede ser posterior a la fecha de fin del segundo cuatrimestre')
    end
    if inicio_cuatrimestre_dos < inicio_cuatrimestre_uno
      errors.add(:inicio_cuatrimestre_dos, 'no puede ser anterior a la fecha de inicio del primer cuatrimestre')
    end
  
    if inicio_cuatrimestre_uno < year_start
      errors.add(:inicio_cuatrimestre_uno, 'no puede ser anterior a la fecha de inicio del año')
    end
  
    if fin_cuatrimestre_dos > year_end
      errors.add(:fin_cuatrimestre_dos, 'no puede ser posterior a la fecha de fin del año')
    end
  
    if inicio_cuatrimestre_uno > year_end
      errors.add(:inicio_cuatrimestre_uno, 'no puede ser posterior a la fecha de fin del año')
    end
  
    return unless fin_cuatrimestre_uno < year_start
  
    errors.add(:fin_cuatrimestre_uno, 'no puede ser anterior a la fecha de inicio del año')
  end
end
