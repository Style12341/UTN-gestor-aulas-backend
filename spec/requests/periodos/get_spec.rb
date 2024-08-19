require 'rails_helper'

RSpec.describe 'Periodos', type: :request do
  before do
    # Create 2019 periodo
    day_c1_inicio = Faker::Date.between(from: '2019-03-01', to: '2019-03-10')
    day_c1_fin = Faker::Date.between(from: '2019-07-05', to: '2019-07-15')
    day_c2_inicio = Faker::Date.between(from: '2019-08-01', to: '2019-08-10')
    day_c2_fin = Faker::Date.between(from: '2019-12-05', to: '2019-12-15')
    @p1 = Periodo.create(año: 2019, inicio_cuatrimestre_uno: day_c1_inicio, fin_cuatrimestre_uno: day_c1_fin,
                         inicio_cuatrimestre_dos: day_c2_inicio, fin_cuatrimestre_dos: day_c2_fin)
  end
  scenario 'Get Periodo for año after current year' do
    get periodos_url(2030)
    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['error']).to eq('Año futuro')
  end
  scenario 'Get current Periodo' do
    get periodos_current_url
    expect(response).to have_http_status(:success)
    periodo = JSON.parse(response.body)
    expect(periodo['año']).to eq(Time.now.year)
  end
  scenario 'Get periodo of previous año' do
    get periodos_url(2019)
    expect(response).to have_http_status(:success)
    periodo = JSON.parse(response.body)
    # Equals to the created periodo
    expect(periodo['año']).to eq(2019)
    expect(periodo['inicio_cuatrimestre_uno']).to eq(@p1.inicio_cuatrimestre_uno.to_s)
    expect(periodo['fin_cuatrimestre_uno']).to eq(@p1.fin_cuatrimestre_uno.to_s)
    expect(periodo['inicio_cuatrimestre_dos']).to eq(@p1.inicio_cuatrimestre_dos.to_s)
    expect(periodo['fin_cuatrimestre_dos']).to eq(@p1.fin_cuatrimestre_dos.to_s)
  end
end
