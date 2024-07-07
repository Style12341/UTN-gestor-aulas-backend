class CreateCaracteristicas < ActiveRecord::Migration[7.1]
  def change
    create_table :caracteristicas do |t|
      t.string :nombre
    end
  end
end
