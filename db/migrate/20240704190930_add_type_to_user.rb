class AddTypeToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :type, :string
    remove_column :users, :role
  end
end
