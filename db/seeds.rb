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
50.times do |_i|
  nombre = Faker::Name.first_name
  apellido = Faker::Name.last_name
  id = "#{nombre[0]}#{apellido[0]}#{rand(1000..9999)}"
  Bedel.create!(id:, turno: Bedel.turnos.keys.sample, nombre:,
               apellido:, password: '12345678')
end
