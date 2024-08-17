require 'csv'

class DocentesController < ApplicationController
  before_action :check_and_reload_docentes

  # Class variable to store the docentes in memory
  @@docentes = []
  @@last_hash_signature = nil

  def index
    # Example action to display the cached docentes
    if params[:search]
      # Normalize the search string before comparing it with the docente names
      params[:search] = I18n.transliterate(params[:search])
      render json: @@docentes.select { |docente|
                     I18n.transliterate(docente.downcase).include?(params[:search].downcase)
                   }
    else
      render json: @@docentes
    end
  end

  private

  def check_and_reload_docentes
    csv_path = Rails.root.join('public', 'files', 'docentes', 'docentes.csv')
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
    CSV.foreach(file_path, headers: false) do |row|
      docentes << row[0] # Assuming the docente name is in the first column
    end
    # Case and accent insensitive sort
    docentes.sort! do |a, b|
      I18n.transliterate(a).downcase <=> I18n.transliterate(b).downcase
    end

    # Cache the docentes in memory
    @@docentes = docentes
  end
end
