class PeriodosController < ApplicationController
  def show
    año = params[:ano].to_i
    return render json: { error: 'Año inválido' }, status: :bad_request unless año.positive?
    return render json: { error: 'Año futuro' }, status: :bad_request if año > Time.now.year

    periodo = Periodo.get_periodo_by_year(año)
    if periodo
      render json: periodo
    else
      render json: { error: 'Periodo inexistente' }, status: :not_found
    end
  end

  def current
    periodo = Periodo.get_periodo_by_year(Time.now.year)
    if periodo
      render json: periodo
    else
      render json: { error: 'Periodo inexistente' }, status: :not_found
    end
  end
end
