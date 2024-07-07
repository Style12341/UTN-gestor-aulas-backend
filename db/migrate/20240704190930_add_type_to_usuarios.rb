class AddTypeToUsuarios < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :type, :string
    remove_column :usuarios, :role
  end
end
