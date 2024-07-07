class CreateAulas < ActiveRecord::Migration[7.1]
  def change
    create_table :aulas do |t|
      t.integer :numero_aula
      t.integer :piso
      t.integer :tipo
      t.integer :capacidad
      t.integer :tipo_pizarron
      t.boolean :habilitada
    end
  end
end
