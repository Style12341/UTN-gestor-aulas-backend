require 'csv'

class DocentesController < ApplicationController
  before_action :check_and_reload_docentes
  # Class variable to store the docentes in memory
  @@docentes = []
  @@last_hash_signature = nil

  def index
    # Example action to display the cached docentes
    if params[:apellido] || params[:nombre]
      # Normalize the search string before comparing it with the docente names
      params[:apellido] = I18n.transliterate(params[:apellido]) if params[:apellido]
      params[:nombre] = I18n.transliterate(params[:nombre]) if params[:nombre]
      render json: @@docentes.select { |docente|
                     I18n.transliterate(docente[1].downcase).include?(params[:nombre]&.downcase || '') && I18n.transliterate(docente[2].downcase).include?(params[:apellido]&.downcase || '')
                   }
    else
      render json: @@docentes
    end
  end

  def self.get_docente_by_id(id)
    docente = @@docentes.find { |docente| docente[0] == id }
    return nil if docente.nil?

    { id_docente: docente[0], nombre_docente: docente[1], apellido_docente: docente[2] }
  end

  private

  def check_and_reload_docentes
    csv_path = Rails.root.join('public', 'docentes.csv')
    current_hash_signature = calculate_hash_signature(csv_path)

    # If the hash has changed, reload the docentes
    return unless @@last_hash_signature != current_hash_signature

    @@last_hash_signature = current_hash_signature
    reload_docentes_from_csv(csv_path)
  end

  def calculate_hash_signature(file_path)
    # Calculate the hash of the file contents
    Digest::SHA256.file(file_path).hexdigest
  end

  def reload_docentes_from_csv(file_path)
    # Reload the docentes from the CSV file and cache them in memory
    docentes = []
    # id,nombre,apellido
    CSV.foreach(file_path, headers: true) do |row|
      docentes << [row['id'], row['nombre'], row['apellido']]
    end
    # Case and accent insensitive sort
    docentes.sort! do |a, b|
      I18n.transliterate(a[1]).downcase <=> I18n.transliterate(b[1]).downcase && I18n.transliterate(a[2]).downcase <=> I18n.transliterate(b[2]).downcase
    end

    # Cache the docentes in memory
    @@docentes = docentes
  end
end
