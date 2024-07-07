class AddAulaToRenglones < ActiveRecord::Migration[7.1]
  def change
    add_reference :renglones_reserva_esporadica, :aula, foreign_key: true
    add_reference :renglones_reserva_periodica, :aula, foreign_key: true
  end
end
