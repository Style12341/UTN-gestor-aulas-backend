require 'rails_helper'

RSpec.describe 'Docentes', type: :request do
  before do
  end
  scenario 'Get Docentes stored in docentes.csv' do
    get docentes_url
    expect(response).to have_http_status(:success)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of(Array)
    file_path = Rails.root.join('public', 'files', 'docentes', 'docentes.csv')
    docentes = []
    CSV.foreach(file_path, headers: true) do |row|
      docentes << [row['id'], row['nombre'], row['apellido']] # Assuming the docente name is in the first column
    end
    docentes.each do |docente|
      expect(body).to include(docente)
    end
  end
  scenario 'Get Docentes stored in docentes.csv after updating the file' do
    # Update the docentes.csv file
    get docentes_url
    expect(response).to have_http_status(:success)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of(Array)
    file_path = Rails.root.join('public', 'files', 'docentes', 'docentes.csv')
    docentes_orig = []
    CSV.foreach(file_path, headers: true) do |row|
      docentes_orig << [row['id'], row['nombre'], row['apellido']] # Assuming the docente name is in the first column
    end
    docentes_orig.each do |docente|
      expect(body).to include(docente)
    end
    CSV.open(file_path, 'w') do |csv|
      csv << %w[id nombre apellido]
      csv << ['1', 'New', 'docente 1']
      csv << ['2', 'New', 'docente 2']
    end

    get docentes_url
    CSV.open(file_path, 'w') do |csv|
      csv << %w[id nombre apellido]
      for docente in docentes_orig
        csv << docente
      end
    end
    expect(response).to have_http_status(:success)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of(Array)
    docentes = [['1', 'New', 'docente 1'], ['2', 'New', 'docente 2']]
    # Expect each item to be included in the response as this one is sortes
    docentes.each do |docente|
      expect(body).to include(docente)
    end
  end
end
