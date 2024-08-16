class CreatePeriodos < ActiveRecord::Migration[7.1]
  def change
    create_table :periodos, id: false,primary_key: :año do |t|
      t.integer :año, null: false
      t.date :inicio_cuatrimestre_uno
      t.date :fin_cuatrimestre_uno
      t.date :inicio_cuatrimestre_dos
      t.date :fin_cuatrimestre_dos
      t.index :año, unique: true
    end
  end
end
