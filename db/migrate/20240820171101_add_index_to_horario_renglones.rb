class AddIndexToHorarioRenglones < ActiveRecord::Migration[7.2]
  #Add GiST indexes to renglones
  def change
    add_index :renglones_reserva_esporadica, :horario, using: :gist
    add_index :renglones_reserva_periodica, :horario, using: :gist
  end
end
