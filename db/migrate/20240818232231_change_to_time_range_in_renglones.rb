class ChangeToTimeRangeInRenglones < ActiveRecord::Migration[7.2]
  def change
    # Create the timerange type
    execute <<-SQL
      CREATE FUNCTION time_subtype_diff(x time, y time) RETURNS float8 AS
      'SELECT EXTRACT(EPOCH FROM (x - y))' LANGUAGE sql STRICT IMMUTABLE;

      CREATE TYPE timerange AS RANGE (
          subtype = time,
          subtype_diff = time_subtype_diff
      );
    SQL
    # Start using horario column insted of hora_inicio and hora_fin, maintaining the same data
    add_column :renglones_reserva_esporadica, :horario, :timerange
    add_column :renglones_reserva_periodica, :horario, :timerange
    # Update horario column with the data from hora_inicio and hora_fin
    RenglonReservaEsporadica.all.each do |renglon|
      renglon.update(horario: renglon.hora_inicio..renglon.hora_fin)
    end
    RenglonReservaPeriodica.all.each do |renglon|
      renglon.update(horario: renglon.hora_inicio..renglon.hora_fin)
    end
    # Remove hora_inicio and hora_fin columns
    remove_column :renglones_reserva_esporadica, :hora_inicio
    remove_column :renglones_reserva_esporadica, :hora_fin
    remove_column :renglones_reserva_periodica, :hora_inicio
    remove_column :renglones_reserva_periodica, :hora_fin
  end
end
