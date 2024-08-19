class Periodo < ApplicationRecord
  self.primary_key = :año
  validates :inicio_cuatrimestre_uno, presence: true
  validates :fin_cuatrimestre_uno, presence: true
  validates :inicio_cuatrimestre_dos, presence: true
  validates :fin_cuatrimestre_dos, presence: true
  validate :validate_date_ranges

  def self.getPeriodo(año)
    # Creates and return a fake Periodo object
    return Periodo.find_by(año:) if Periodo.find_by(año:)

    day_c1_inicio = Faker::Date.between(from: "#{año}-03-01", to: "#{año}-03-10")
    day_c1_fin = Faker::Date.between(from: "#{año}-07-05", to: "#{año}-07-15")
    day_c2_inicio = Faker::Date.between(from: "#{año}-08-01", to: "#{año}-08-10")
    day_c2_fin = Faker::Date.between(from: "#{año}-12-05", to: "#{año}-12-15")
    p1 = Periodo.new(año:, inicio_cuatrimestre_uno: day_c1_inicio, fin_cuatrimestre_uno: day_c1_fin,
                     inicio_cuatrimestre_dos: day_c2_inicio, fin_cuatrimestre_dos: day_c2_fin)
    p1.save
    p1
  end

  def self.getPeriodoByFecha(date)
    periodo = getPeriodo(date.year)
    return :cuatrimestre_1 if date.between?(periodo.inicio_cuatrimestre_uno, periodo.fin_cuatrimestre_uno)

    return :cuatrimestre_2 if date.between?(periodo.inicio_cuatrimestre_dos, periodo.fin_cuatrimestre_dos)

    nil
  end

  #   def self.getStartOfPeriodoByYearPeriodicidad(año, periodicidad)
  #     periodo = getPeriodo(año)
  #
  #     return periodo.inicio_cuatrimestre_uno if periodicidad == :cuatrimestre_1
  #
  #     periodo.inicio_cuatrimestre_dos if periodicidad == :cuatrimestre_2
  #   end
  #
  #   def self.getStartOfPeriodByFecha(date)
  #     periodo = getPeriodoByFecha(date)
  #
  #     return periodo.inicio_cuatrimestre_uno if periodo == :cuatrimestre_1
  #
  #     periodo.inicio_cuatrimestre_dos if periodo == :cuatrimestre_2
  #   end

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
