# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Create public/files/docentes/docentes.csv
# Create if not exists

File.open(Rails.root.join('public', 'files', 'docentes', 'docentes.csv'), 'w') do |file|
  file.write("id, nombre, apellido\n")
  file.write("1,Claudio,Bracalenti\n")
  file.write("2,Santiago,Marneto\n")
  file.write("3,Cristian,Impini\n")
  50.times do |i|
    file.write("#{i + 4},#{Faker::Name.first_name},#{Faker::Name.last_name}\n")
  end
end
# Generate the bedels
Administrador.create(id: 'admin', password: 'admin')
50.times do |_i|
  nombre = Faker::Name.first_name
  apellido = Faker::Name.last_name
  id = "#{nombre[0]}#{apellido[0]}#{rand(1000..9999)}"
  Bedel.create!(id:, turno: Bedel.turnos.keys.sample, nombre:,
                apellido:, password: '12345678')
end
Caracteristica.create!(nombre: 'Cañon')
Caracteristica.create!(nombre: 'Pizarron digital')
Caracteristica.create!(nombre: 'Aire acondicionado')
Caracteristica.create!(nombre: 'Ventilador')
Caracteristica.create!(nombre: 'Calefaccion')
Caracteristica.create!(nombre: 'Computadora')
Caracteristica.create!(nombre: 'Televisor')
5.times do |i|
  a1 = Aula.create!(numero_aula: i + 1, piso: Faker::Number.number(digits: 1), tipo: Aula.tipos[:sin_recursos],
                    capacidad: Faker::Number.number(digits: 2), tipo_pizarron: Aula.tipos_pizarron.keys.sample, habilitada: true)
  a2 = Aula.create!(numero_aula: i + 6, piso: Faker::Number.number(digits: 1), tipo: Aula.tipos[:multimedia],
                    capacidad: Faker::Number.number(digits: 2), tipo_pizarron: Aula.tipos_pizarron.keys.sample, habilitada: true)
  a3 = Aula.create!(numero_aula: i + 11, piso: Faker::Number.number(digits: 1), tipo: Aula.tipos[:informatica],
                    capacidad: Faker::Number.number(digits: 2), tipo_pizarron: Aula.tipos_pizarron.keys.sample, habilitada: true)
  3.times do |_j|
    a1.add_caracteristica(Caracteristica.all.sample, Faker::Number.number(digits: 1))
    a2.add_caracteristica(Caracteristica.all.sample, Faker::Number.number(digits: 1))
    a3.add_caracteristica(Caracteristica.all.sample, Faker::Number.number(digits: 1))
  end
end

Bedel.first.reservas_esporadicas.create!(id_docente: Faker::IdNumber.brazilian_id, nombre_docente: Faker::Name.first_name,
                                         apellido_docente: Faker::Name.last_name, correo_docente: Faker::Internet.email, id_curso: Faker::Number.number(digits: 4), nombre_curso: Faker::Educator.course_name, año: 2024, cantidad_alumnos: Faker::Number.number(digits: 2), fecha_solicitud: Faker::Date.between(from: 1.year.ago, to: Date.today))
Bedel.first.reservas_periodicas.create!(id_docente: Faker::IdNumber.brazilian_id, nombre_docente: Faker::Name.first_name,
                                        apellido_docente: Faker::Name.last_name, correo_docente: Faker::Internet.email, id_curso: Faker::Number.number(digits: 4), nombre_curso: Faker::Educator.course_name, año: 2024, cantidad_alumnos: Faker::Number.number(digits: 2), fecha_solicitud: Faker::Date.between(from: 1.year.ago, to: Date.today), periodicidad: ReservaPeriodica.periodicidades.keys.sample)

ReservaEsporadica.first.renglones.create!(fecha: Faker::Date.between(from: Date.today, to: Date.today + 1.year),
                                          horario: '[08:00,10:00]', aula: Aula.all.sample)

ReservaPeriodica.first.renglones.create!(dia: 'lunes', horario: '[08:00,10:00]', aula: Aula.all.sample)
