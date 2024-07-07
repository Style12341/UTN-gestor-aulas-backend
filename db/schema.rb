# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_07_210347) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aulas", force: :cascade do |t|
    t.integer "numero_aula"
    t.integer "piso"
    t.integer "tipo"
    t.integer "capacidad"
    t.integer "tipo_pizarron"
    t.boolean "habilitada"
  end

  create_table "caracteristicas", force: :cascade do |t|
    t.string "nombre"
  end

  create_table "caracteristicas_aula", primary_key: ["caracteristica_id", "aula_id"], force: :cascade do |t|
    t.integer "cantidad"
    t.bigint "caracteristica_id", null: false
    t.bigint "aula_id", null: false
    t.index ["aula_id"], name: "index_caracteristicas_aula_on_aula_id"
    t.index ["caracteristica_id"], name: "index_caracteristicas_aula_on_caracteristica_id"
  end

  create_table "renglones_reserva_esporadica", force: :cascade do |t|
    t.date "fecha"
    t.time "hora_inicio"
    t.time "hora_fin"
    t.bigint "reserva_id"
    t.bigint "aula_id"
    t.index ["aula_id"], name: "index_renglones_reserva_esporadica_on_aula_id"
    t.index ["reserva_id"], name: "index_renglones_reserva_esporadica_on_reserva_id"
  end

  create_table "renglones_reserva_periodica", force: :cascade do |t|
    t.integer "dia"
    t.time "hora_inicio"
    t.time "hora_fin"
    t.bigint "reserva_id"
    t.bigint "aula_id"
    t.index ["aula_id"], name: "index_renglones_reserva_periodica_on_aula_id"
    t.index ["reserva_id"], name: "index_renglones_reserva_periodica_on_reserva_id"
  end

  create_table "reservas", force: :cascade do |t|
    t.string "id_docente"
    t.string "nombre_docente"
    t.string "apellido_docente"
    t.string "correo_docente"
    t.integer "id_curso"
    t.string "nombre_curso"
    t.string "año"
    t.integer "cantidad_alumnos"
    t.datetime "fecha_solicitud"
    t.string "type"
    t.integer "periodicidad"
    t.string "bedel_id"
    t.index ["bedel_id"], name: "index_reservas_on_bedel_id"
  end

  create_table "usuarios", id: :string, force: :cascade do |t|
    t.integer "turno"
    t.string "nombre"
    t.string "apellido"
    t.string "password_digest"
    t.datetime "deleted_at"
    t.string "type"
  end

  add_foreign_key "caracteristicas_aula", "aulas"
  add_foreign_key "caracteristicas_aula", "caracteristicas"
  add_foreign_key "renglones_reserva_esporadica", "aulas"
  add_foreign_key "renglones_reserva_esporadica", "reservas"
  add_foreign_key "renglones_reserva_periodica", "aulas"
  add_foreign_key "renglones_reserva_periodica", "reservas"
  add_foreign_key "reservas", "usuarios", column: "bedel_id"
end
