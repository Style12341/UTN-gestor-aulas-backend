class CreateReservas < ActiveRecord::Migration[7.1]
  def change
    create_table :reservas do |t|
      t.string :id_docente
      t.string :nombre_docente
      t.string :apellido_docente
      t.string :correo_docente
      t.integer :id_curso
      t.string :nombre_curso
      t.string :año
      t.integer :cantidad_alumnos
      t.datetime :fecha_solicitud
      t.string :type
      t.integer :periodicidad
      t.references :bedel, foreign_key: { to_table: :usuarios }, type: :string
    end
  end
end
