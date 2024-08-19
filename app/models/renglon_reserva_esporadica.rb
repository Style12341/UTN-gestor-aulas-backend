class RenglonReservaEsporadica < ApplicationRecord
  validates_presence_of RenglonReservaEsporadica.attribute_names - %w[id]
  belongs_to :reserva, class_name: 'ReservaEsporadica', foreign_key: 'reserva_id'
  belongs_to :aula, class_name: 'Aula', foreign_key: 'aula_id'
  scope :with_least_overlap, lambda { |range_or_from:, to: nil|
    find_with_least_overlap(range_or_from:, to:)
  }
  def self.find_with_least_overlap(range_or_from:, to: nil)
    timerange = convert_to_timerange(range_or_from, to)
    min_overlap = calculate_min_overlap(timerange)
    puts min_overlap
    select("*, least_overlap_timerange('#{timerange}', horario) AS overlap")
      .where("least_overlap_timerange('#{timerange}', horario) = interval '#{min_overlap}'")
      .order('overlap ASC')
  end

  # Converts either a timerange or from/to values into a timerange string
  def self.convert_to_timerange(range_or_from, to)
    if to.nil?
      # Assuming `range_or_from` is already in the format '(start_time, end_time)'
      range_or_from
    else
      "(#{range_or_from}, #{to})"
    end
  end

  # Calculates the minimum overlap for a given timerange
  def self.calculate_min_overlap(timerange)
    select("LEAST(least_overlap_timerange('#{timerange}', horario)) AS min_overlap")
      .order('min_overlap ASC')
      .limit(1).take.min_overlap
  end
end
