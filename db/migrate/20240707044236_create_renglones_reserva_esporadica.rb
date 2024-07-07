class CreateRenglonesReservaEsporadica < ActiveRecord::Migration[7.1]
  def change
    create_table :renglones_reserva_esporadica do |t|
      t.date :fecha
      t.time :hora_inicio
      t.time :hora_fin
      t.references :reserva, foreign_key: true
    end
  end
end
