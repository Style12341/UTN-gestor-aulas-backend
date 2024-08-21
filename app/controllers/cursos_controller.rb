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
      render json: @@courses.select { |course|
                     I18n.transliterate(course[1].downcase).include?(params[:search].downcase)
                   }
    else
      render json: @@courses
    end
  end

  def self.get_course_by_id(id)
    ## Get the course by id and transform it into a hash id[0] and course[1]
    course = @@courses.find { |course| course[0] == id }
    return nil if course.nil?

    { id_curso: course[0], nombre_curso: course[1] }
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

    # csv id,course
    courses = []
    CSV.foreach(file_path, headers: true) do |row|
      courses << [row['id'], row['course']]
    end
    # Case and accent insensitive sort
    courses.sort! do |a, b|
      I18n.transliterate(a[1]).downcase <=> I18n.transliterate(b[1]).downcase
    end
    # Cache the courses in memory
    @@courses = courses
  end
end
