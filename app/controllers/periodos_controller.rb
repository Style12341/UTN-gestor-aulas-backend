class PeriodosController < ApplicationController
  def show
    año = params[:ano].to_i
    return render json: { error: 'Año inválido' }, status: :bad_request unless año.positive?
    return render json: { error: 'Año futuro' }, status: :bad_request if año > Time.now.year

    periodo = Periodo.find_by(año:) || getPeriodo(año)
    if periodo
      render json: periodo
    else
      render json: { error: 'Periodo inexistente' }, status: :not_found
    end
  end

  def current
    periodo = Periodo.find_by(año: Time.now.year) || getPeriodo(Time.now.year)
    if periodo
      render json: periodo
    else
      render json: { error: 'Periodo inexistente' }, status: :not_found
    end
  end

  private

  def getPeriodo(año)
    # Creates and return a fake Periodo object
    day_c1_inicio = Faker::Date.between(from: "#{año}-03-01", to: "#{año}-03-10")
    day_c1_fin = Faker::Date.between(from: "#{año}-07-05", to: "#{año}-07-15")
    day_c2_inicio = Faker::Date.between(from: "#{año}-08-01", to: "#{año}-08-10")
    day_c2_fin = Faker::Date.between(from: "#{año}-12-05", to: "#{año}-12-15")
    p1 = Periodo.new(año:, inicio_cuatrimestre_uno: day_c1_inicio, fin_cuatrimestre_uno: day_c1_fin,
                     inicio_cuatrimestre_dos: day_c2_inicio, fin_cuatrimestre_dos: day_c2_fin)
    p1.save
    p1
  end
end
