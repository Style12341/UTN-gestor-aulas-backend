require 'rails_helper'

RSpec.describe 'Cursos', type: :request do
  before do
  end
  scenario 'Get Cursos stored in courses.csv' do
    get cursos_url
    expect(response).to have_http_status(:success)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of(Array)
    file_path = Rails.root.join('public', 'courses.csv')
    courses = []
    CSV.foreach(file_path, headers: true) do |row|
      courses << [row['id'], row['course']]
    end
    courses.each do |course|
      expect(body).to include(course)
    end
  end
  scenario 'Get Cursos stored in courses.csv after updating the file' do
    # Update the courses.csv file
    get cursos_url
    expect(response).to have_http_status(:success)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of(Array)
    file_path = Rails.root.join('public', 'courses.csv')
    courses_orig = []
    CSV.foreach(file_path, headers: true) do |row|
      courses_orig << [row['id'], row['course']]
    end
    courses_orig.each do |course|
      expect(body).to include(course)
    end
    CSV.open(file_path, 'w') do |csv|
      csv << %w[id course]
      csv << ['1', 'New Course 1']
      csv << ['2', 'New Course 2']
    end

    get cursos_url
    CSV.open(file_path, 'w') do |csv|
      csv << %w[id course]
      for course in courses_orig
        csv << [course[0], course[1]]
      end
    end
    expect(response).to have_http_status(:success)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of(Array)
    courses = [['1', 'New Course 1'], ['2', 'New Course 2']]
    courses.each do |course|
      expect(body).to include(course)
    end
  end
end
