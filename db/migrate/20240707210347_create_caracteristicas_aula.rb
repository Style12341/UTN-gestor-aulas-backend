class CreateCaracteristicasAula < ActiveRecord::Migration[7.1]
  def change
    create_table :caracteristicas_aula, primary_key: %i[caracteristica_id aula_id] do |t|
      t.integer :cantidad
      t.references :caracteristica, null: false, foreign_key: true
      t.references :aula, null: false, foreign_key: true
    end
  end
end
