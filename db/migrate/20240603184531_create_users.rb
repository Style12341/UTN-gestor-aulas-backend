class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :string do |t|
      t.integer :role , default: 0
      t.integer :turno
      t.string :nombre
      t.string :apellido
      t.string :password_digest
      t.timestamps
    end
  end
end
