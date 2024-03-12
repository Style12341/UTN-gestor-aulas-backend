# frozen_string_literal: true

module LeastOverlapGetter
  extend ActiveSupport::Concern
  included do
    scope :with_least_overlap, lambda { |range_or_from:, to: nil|
      find_with_least_overlap(range_or_from:, to:)
    }
  end

  class_methods do
    def find_with_least_overlap(range_or_from:, to: nil)
      timerange = convert_to_timerange(range_or_from, to)
      min_overlap = calculate_min_overlap(timerange)
      return nil if min_overlap.nil?

      select("*, to_char(least_overlap_timerange('#{timerange}', horario), 'HH24:MI') AS overlap")
        .where("least_overlap_timerange('#{timerange}', horario) = interval '#{min_overlap}'")
        .order('overlap ASC')
    end

    private

    # Converts either a timerange or from/to values into a timerange string
    def convert_to_timerange(range_or_from, to)
      if to.nil?
        # Assuming `range_or_from` is already in the format '(start_time, end_time)'
        range_or_from
      else
        "(#{range_or_from}, #{to})"
      end
    end

    # Calculates the minimum overlap for a given timerange
    def calculate_min_overlap(timerange)
      select("to_char(LEAST(least_overlap_timerange('#{timerange}', horario)), 'HH24:MI') AS min_overlap")
        .where('horario && ?', timerange)
        .order('min_overlap ASC')
        .first&.min_overlap
    end
  end
end
