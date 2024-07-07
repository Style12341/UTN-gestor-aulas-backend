class CreateRenglonesReservaPeriodica < ActiveRecord::Migration[7.1]
  def change
    create_table :renglones_reserva_periodica do |t|
      t.integer :dia
      t.time :hora_inicio
      t.time :hora_fin
      t.references :reserva, foreign_key: true
    end
  end
end
