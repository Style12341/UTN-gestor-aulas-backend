class AddIndexAnoPeriodicidadToReservas < ActiveRecord::Migration[7.2]
  def change
    add_index :reservas, %i[año periodicidad]
  end
end
