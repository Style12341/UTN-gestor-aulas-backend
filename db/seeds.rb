# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Generate the bedels
Administrador.create(id: 'admin', password: 'admin')
50.times do |_i|
  nombre = Faker::Name.first_name
  apellido = Faker::Name.last_name
  id = "#{nombre[0]}#{apellido[0]}#{rand(1000..9999)}"
  Bedel.create!(id:, turno: Bedel.turnos.keys.sample, nombre:,
                apellido:, password: '12345678')
end
5.times do |i|
  Aula.create!(numero_aula: i + 1, piso: Faker::Number.number(digits: 1), tipo: Aula.tipos[:sin_recursos],
               capacidad: Faker::Number.number(digits: 2), tipo_pizarron: Aula.tipos_pizarron.keys.sample, habilitada: true)
  Aula.create!(numero_aula: i + 6, piso: Faker::Number.number(digits: 1), tipo: Aula.tipos[:multimedia],
               capacidad: Faker::Number.number(digits: 2), tipo_pizarron: Aula.tipos_pizarron.keys.sample, habilitada: true)
  Aula.create!(numero_aula: i + 11, piso: Faker::Number.number(digits: 1), tipo: Aula.tipos[:informatica],
               capacidad: Faker::Number.number(digits: 2), tipo_pizarron: Aula.tipos_pizarron.keys.sample, habilitada: true)
end

Bedel.first.reservas_esporadicas.create!(id_docente: Faker::IdNumber.brazilian_id, nombre_docente: Faker::Name.first_name,
                                         apellido_docente: Faker::Name.last_name, correo_docente: Faker::Internet.email, id_curso: Faker::Number.number(digits: 4), nombre_curso: Faker::Educator.course_name, año: 2024, cantidad_alumnos: Faker::Number.number(digits: 2), fecha_solicitud: Faker::Date.between(from: 1.year.ago, to: Date.today))
Bedel.first.reservas_periodicas.create!(id_docente: Faker::IdNumber.brazilian_id, nombre_docente: Faker::Name.first_name,
                                        apellido_docente: Faker::Name.last_name, correo_docente: Faker::Internet.email, id_curso: Faker::Number.number(digits: 4), nombre_curso: Faker::Educator.course_name, año: 2024, cantidad_alumnos: Faker::Number.number(digits: 2), fecha_solicitud: Faker::Date.between(from: 1.year.ago, to: Date.today), periodicidad: ReservaPeriodica.periodicidades.keys.sample)
ReservaEsporadica.first.renglones.create!(fecha: Faker::Date.between(from: Date.today, to: Date.today + 1.year),
                                          hora_inicio: '08:00', hora_fin: '10:00', aula: Aula.all.sample)
ReservaPeriodica.first.renglones.create!(dia: 'lunes', hora_inicio: '08:00', hora_fin: '10:00', aula: Aula.all.sample)
