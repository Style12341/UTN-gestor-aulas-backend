class AddLeastOverlapFunctionToDb < ActiveRecord::Migration[7.2]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION least_overlap_timerange(
        input_range timerange,
        range_column timerange
      ) RETURNS interval AS $$
      BEGIN
        RETURN GREATEST(
          LEAST(upper(input_range), upper(range_column)) - GREATEST(lower(input_range), lower(range_column)),
          '0 seconds'::interval
        );
      END;
      $$ LANGUAGE plpgsql;
    SQL
  end

  def down
    execute <<-SQL
      DROP FUNCTION IF EXISTS least_overlap_timerange(timerange, timerange);
    SQL
  end
end
