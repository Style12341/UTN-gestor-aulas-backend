require 'csv'

class CursosController < ApplicationController
  before_action :check_and_reload_courses

  # Class variable to store the courses in memory
  @@courses = []
  @@last_hash_signature = nil

  def index
    # Example action to display the cached courses
    if params[:search]
      # In case of special characters such as í, é, etc., we need to normalize the string
      # before comparing it with the course names
      params[:search] = I18n.transliterate(params[:search])
      render json: @@courses.select { |course| I18n.transliterate(course.downcase).include?(params[:search].downcase) }
    else
      render json: @@courses
    end
  end

  private

  def check_and_reload_courses
    csv_path = Rails.root.join('public', 'files', 'courses', 'courses.csv')
    current_hash_signature = calculate_hash_signature(csv_path)

    # If the hash has changed, reload the courses
    return unless @@last_hash_signature != current_hash_signature

    @@last_hash_signature = current_hash_signature
    reload_courses_from_csv(csv_path)
  end

  def calculate_hash_signature(file_path)
    # Calculate the hash of the file contents
    Digest::SHA256.file(file_path).hexdigest
  end

  def reload_courses_from_csv(file_path)
    # Reload the courses from the CSV file and cache them in memory
    courses = []

    CSV.foreach(file_path, headers: false) do |row|
      courses << row[0] # Assuming the course name is in the first column
    end
    # Case and accent insensitive sort
    courses.sort! do |a, b|
      I18n.transliterate(a).downcase <=> I18n.transliterate(b).downcase
    end
    # Cache the courses in memory
    @@courses = courses
  end
end
